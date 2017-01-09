
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



View(brent_prices)


#ggplot(brent_prices, aes(x = Date, y = USD_Barrel)) +
#  geom_line()


plot_ly(data = brent_prices,
        x = ~Date,
        y = ~USD_Barrel,
        type = 'scatter',
        mode = 'lines')


