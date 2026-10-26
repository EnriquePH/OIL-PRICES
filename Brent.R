# Europe Brent Spot Price FOB (Dollars per Barrel)
# https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=PET&s=rbrte&f=D
#
# ARIMA forecast of the monthly mean price for the next `h` months.
# Usage: Rscript Brent.R [h] [--update]
#   --update  download the EIA data now (by default only when older than 7 days)
# Output: output/brent_forecast.csv and output/brent_forecast.png


suppressPackageStartupMessages(library(forecast))
library(ggplot2)
source("R/brent.R")


args <- commandArgs(trailingOnly = TRUE)
update <- "--update" %in% args
args <- setdiff(args, "--update")
h <- if (length(args) > 0) as.integer(args[1]) else 12

download_brent(max_age_days = if (update) 0 else 7)
daily <- read_brent()
cat("Data until", format(end(daily)), "\n")
brent <- monthly_brent(daily)

fit <- auto.arima(brent, lambda = 0, biasadj = TRUE,
                  stepwise = FALSE, approximation = FALSE)
brent_fc <- forecast(fit, h = h)

print(fit)
print(brent_fc)

dir.create("output", showWarnings = FALSE)

fc_df <- data.frame(Month = format(as.Date(zoo::as.yearmon(time(brent_fc$mean))), "%Y-%m"),
                    as.data.frame(brent_fc), row.names = NULL, check.names = FALSE)
write.csv(fc_df, "output/brent_forecast.csv", row.names = FALSE)

p <- autoplot(window(brent, start = end(brent)[1] - 8)) +
  autolayer(brent_fc, series = "ARIMA") +
  labs(title = paste("Brent forecast:", as.character(fit)),
       x = "", y = "USD/Barrel") +
  theme(legend.position = "none")
ggsave("output/brent_forecast.png", p, width = 9, height = 5)


# Forecast table in README.md, between the forecast:start and forecast:end marks
fmt <- function(x) formatC(x, format = "f", digits = 1)
table <- c(
  sprintf("Model **%s** on log(price). Data until **%s** (last price %s USD), updated %s.",
          as.character(fit), format(end(daily)), fmt(as.numeric(last(daily))),
          format(Sys.Date())),
  "",
  "| Month | Forecast | 80 % interval | 95 % interval |",
  "| --- | ---: | :---: | :---: |",
  sprintf("| %s | %s | %s – %s | %s – %s |", fc_df$Month,
          fmt(fc_df$`Point Forecast`), fmt(fc_df$`Lo 80`), fmt(fc_df$`Hi 80`),
          fmt(fc_df$`Lo 95`), fmt(fc_df$`Hi 95`))
)
readme <- readLines("README.md")
start <- grep("<!-- forecast:start -->", readme, fixed = TRUE)
end <- grep("<!-- forecast:end -->", readme, fixed = TRUE)
if (length(start) == 1 && length(end) == 1) {
  readme <- c(readme[1:start], table, readme[end:length(readme)])
  writeLines(readme, "README.md")
}
