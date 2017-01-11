ggplot(brent_prices, aes(x = Date, y = USD_Barrel)) +
  geom_line()


xx <- xts(brent_prices$USD_Barrel, brent_prices$Date)

dygraph(xx)
plot(xx)