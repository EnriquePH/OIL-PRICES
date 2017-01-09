library("quantmod")
library("Quandl")




getSymbols("COP")
chartSeries(c(COP,BNO), theme = "white")
getSymbols("OFDP/FUTURE_GC2")




getSymbols("BNO")
chartSeries(BNO, theme = "white")
