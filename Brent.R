
# Europe Brent Spot Price FOB (Dollars per Barrel)
# https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=PET&s=rbrte&f=D


library(readxl)
library(plotly)


data_url <- "https://www.eia.gov/dnav/pet/hist_xls/RBRTEd.xls"
data_file <- basename(data_url)

data_dir <- "data"
data_path <- paste(data_dir, data_file, sep = "/")

if(!file.exists(data_path)) {
  download.file(data_url, destfile = data_path, method = "wget")
}


brent_prices <- read_excel(data_path, sheet = "Data 1", skip = 2)
brent_prices <- na.omit(brent_prices)
names(brent_prices) <- c("Date", "USD_Barrel")
brent_prices <- xts(brent_prices$USD_Barrel, brent_prices$Date)
names(brent_prices) <- c("USD_Barrel")

dygraph(brent_prices)

summary(brent_prices)

brent_prices_monthly <- 
  ts(apply.monthly(brent_prices, mean), start = c(1987),   frequency = 12)

plot(decompose(brent_prices_monthly, type = "multiplicative"))

brent_mult_decom <- decompose(brent_prices_monthly, type = "multiplicative")

dygraph(cbind(brent_mult_decom$x,
              brent_mult_decom$trend),
              group = "decompose") %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 1)) %>%
  dyRangeSelector()
dygraph(cbind(brent_mult_decom$seasonal,
              brent_mult_decom$random),
              group = "decompose")



dygraph(cbind(brent_mult_decom$x,
              brent_mult_decom$trend),
        group = "decompose")
dygraph(cbind(brent_mult_decom$seasonal,
              brent_mult_decom$random),
        group = "decompose")

xx2 <- ts(apply.monthly(xx, mean), start = c(1987),   frequency = 12)

plot(decompose(xx2, type = "multiplicative"))

plot(decompose(xx2, type = "additive"))

library(dygraphs)
dygraph(xx2)

library(quantmod)
getSymbols("COP", src = "yahoo", from = "1987-05-20", to = "2017-01-03")

summary(COP$COP.Close)

lungDeaths <- cbind(COP$COP.Close, brent_prices)

dygraph(COP$COP.Close -COP$COP.Open)

dygraph(COP$COP.Close -COP$COP.Open)

plot(density(COP$COP.Close -COP$COP.Open))
density(na.omit(diff(brent_prices)))

d1 <- brent_prices %>%
  diff %>%
  na.omit %>%
  density 

d2 <- (COP$COP.Close -COP$COP.Open) %>%
  density

plot(d1, col = "red")
lines(d2)

View(diff(brent_prices))

dygraph(lungDeaths) %>%
  dyRangeSelector()

dygraph(COP) %>%
  dyCandlestick() %>%
  dyRangeSelector()
dygraph(xx2)

