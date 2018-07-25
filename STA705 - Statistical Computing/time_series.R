# --------------------------------------------
# Data Loading
# --------------------------------------------

# Load library
library(tidyquant)
library(lattice)
library(latticeExtra)
library(forecast)
library(tseries)

# Download data from Yahoo!Finance using tidyquant library
nestle <- tq_get("4707.KL", get = "stock.prices", from = "2013-01-01", to = "2017-12-31")
dlady  <- tq_get("3026.KL", get = "stock.prices", from = "2013-01-01", to = "2017-12-31")
fnn    <- tq_get("3689.KL", get = "stock.prices", from = "2013-01-01", to = "2017-12-31")
aji    <- tq_get("2658.KL", get = "stock.prices", from = "2013-01-01", to = "2017-12-31")

# Explore the structure of the data
str(nestle)

# Explore basic statistics
summary(nestle)


# --------------------------------------------
# Data Pre-Processing
# --------------------------------------------

# Find the date with missing values
nestle %>% filter_all(any_vars(is.na(.)))

nestle %>% fill(open) %>% filter_all(any_vars(is.na(.)))

# Find days with 0 volume traded
nestle %>% filter(volume == 0) %>% head()

# Look for 2-3 days before and after of one of them
nestle %>% filter(date >= "2014-01-29", date <= "2014-02-05")

# Replacing the missing values
nestle.cleaned <- nestle %>% 
  fill(close, adjusted) %>% 
  mutate(open   = if_else(is.na(open), close, open),
         high   = if_else(is.na(high), close, high),
         low    = if_else(is.na(low), close, low),
         volume = if_else(is.na(volume), 0, volume))

# Verify no more missing values
sum(is.na(nestle.cleaned))

# Convert into xts object
NESTLE <- xts(nestle.cleaned[,2:7], order.by = nestle.cleaned$date)

# Verify time series object
class(NESTLE)


#---
# Convert un-cleaned data into xts object
NESTLE.OLD <- xts(nestle[,2:7], order.by = nestle$date)

# Verify time series object
class(NESTLE.OLD)

# --------------------------------------------
# Exploratory
# --------------------------------------------

# Plot Nestle stock price
plot(NESTLE$close, main = "Nestle Stock Price\nJanuary 2013 - December 2017")

# Plot Nestle stock price with missing data
plot(NESTLE.OLD$close, main ="Nestle Stock Price with Missing Values")

# Plot with lattice package
asTheEconomist(xyplot(NESTLE$close, 
                      main = "Nestle Stock Price\nJanuary 2013 - December 2017", 
                      col = "#0F52BA"),
               ylab = "Closing Value (RM)")

# Convert to Weekly 
wk <- NESTLE
NESTLE.weekly <- to.weekly(wk)

# Check the first 2 rows and the last row
NESTLE.monthly[c(1:2, nrow(NESTLE.monthly)), ]

# Convert to Monthly Data
mo <- NESTLE
NESTLE.monthly <- to.monthly(mo)

# Covert to normal time series object
NESTLE.monthly.tib <- as_tibble(NESTLE.monthly)
NESTLE.monthly.ts <- ts(NESTLE.monthly.tib$mo.Close, frequency = 12, start = c(2013, 1))

# Plot the Seasonal Decomposition
NESTLE.season <- stl(NESTLE.monthly.ts, s.window = "period")
plot(NESTLE.season)
title(main = "Seasonal Decomposition on Nestle Monthly Stock Price", line = 2.25)

# Components of each seasonal observation
NESTLE.season$time.series %>% head()


# --- Candelstick Chart ---

# Convert to a OHLC type
OHLC <- NESTLE.monthly[,-6]
NESTLE.ohlc <- as.quantmod.OHLC(OHLC,col.names = c("Open", "High", "Low", "Close", "Volume"))

#Verify that the type changed
class(NESTLE.ohlc)
NESTLE.ohlc[c(1:2, nrow(NESTLE.ohlc)), ]

# Plot the candlestick chart
chartSeries(NESTLE.ohlc, theme = "white.mono", name = "NESTLE OHLC")


# --- Simple Moving verage --- 

# Select the close price only
NESTLE.sma <- NESTLE[,4]

# Create SMA 50 and 200 
NESTLE.sma$sma50 <- rollmeanr(NESTLE.sma$close, k = 50)
NESTLE.sma$sma200 <- rollmeanr(NESTLE.sma$close, k = 200)

# Verify SMA 50 and 200 are created
NESTLE.sma[250:265, ]


# Select data after 2015 using subset()
NESTLE.sma.2015 <- subset(NESTLE.sma, index(NESTLE.sma) >= "2015-01-01")

# Verify data completeness
NESTLE.sma.2015 %>% head()
sum(is.na(NESTLE.sma.2015))

# Set the y-range
y.range <- range(NESTLE.sma.2015)

# Plot the original graph with the two sma lines
plot(x = index(NESTLE.sma.2015), 
     y = NESTLE.sma.2015$close,
     ylim = y.range,
     ylab = "Closing Price (RM)",
     xlab = "Date",
     type = "l",
     main = "NESTLE Stock - Simple Moving Average\nJanuary 2014 - December 2017")
lines(x = index(NESTLE.sma.2015), y = NESTLE.sma.2015$sma50, lty = 2)
lines(x = index(NESTLE.sma.2015), y = NESTLE.sma.2015$sma200, lwd = 3)
legend("topleft",
       c("Nestle Stock\nPrice", "50-Day\nMoving Average", "200-Day\nMoving Average"), 
       lty = c(1, 2, 1), lwd = c(1, 1, 3), cex = 0.75)


# --- Bollinger Bands --- 
nestle.sma <- nestle.cleaned %>% 
  filter(!is.na(close)) %>%
  mutate(sma20 = rollapply(close, FUN = mean, width = 20, fill = NA, align = "right"),
         sd = rollapply(close, FUN = sd, width = 20, fill = NA, align = "right"), 
         sd2up = sma20 + 2 * sd, 
         sd2dn = sma20 - 2 * sd)

# Filter the data for above 2015
nestle.sma.2015 <- nestle.sma %>% 
  filter(date >= "2015-01-01")

# Create the overbought and oversold criteria
nestle.over <- nestle.sma.2015 %>% 
  filter(close - sd2up >= 0.85) %>% 
  mutate(category = "overbought")

nestle.under <- nestle.sma.2015 %>% 
  filter(close - sd2dn < - 0.5)%>% 
  mutate(category = "oversold")

# Create the plot using ggplot2
nestle.sma.2015 %>% 
  ggplot(aes(x = date)) +
  geom_ribbon(aes(ymin = sd2dn, ymax = sd2up), alpha = 0.3, fill = "khaki") +
  geom_line(aes(y = close, linetype = "typeA"), color = "tomato") + 
  geom_line(aes(y = sma20, linetype = "typeB"), color = "black") +
  geom_line(aes(y = sd2up, linetype = "typeC"), color = "dimgrey") +
  geom_line(aes(y = sd2dn), linetype = "dotted", size = 0.7, color = "dimgrey") +
  geom_text(data = nestle.under, aes(x = date + 8, y = close - 0.5, label = category), color = "#BF00FF") +
  geom_point(data = nestle.under, aes(x = date, y = close), color = "orchid") +
  geom_text(data = nestle.over, aes(x = date - 10, y = close + 0.5, label = category), color = "firebrick") +
  geom_point(data = nestle.over, aes(x = date, y = close), color = "darkred") +
  annotate(geom = "text", x = date("2015-08-01"), y = 75, label = "Upper\nBand") +
  annotate(geom = "text", x = date("2015-08-01"), y = 69.5, label = "Lower\nBand") +
  ggtitle("Bollinger Bands on Nestle Stock Prices", "January 2015 - December 2017") +
  labs(x ="Date", y = "Price ($)") +
  scale_linetype_manual(values = c(1, 2, 3), labels = (c("Closing Price", "SMA20", "Band"))) +
  theme(plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
        plot.subtitle = element_text(face = "bold", size = 12, hjust = 0.5),
        axis.title = element_text(face = "bold", size = 13),
        axis.title.x = element_text(margin = margin(t = 15)),
        axis.title.y = element_text(margin = margin(r = 10)),
        panel.background = element_rect(fill = "white"),
        panel.grid = element_blank(),
        axis.line = element_line(),
        axis.text = element_text(size = 13),
        legend.title = element_blank(),
        legend.background = element_rect(color = "black", fill = "white"),
        legend.key = element_rect(fill = "white"),
        legend.text = element_text(size = 12),
        legend.position = c(0.1, 0.9))

#--- EXTRA ---



# Seasonal Decomposition
seasonplot(NESTLE.monthly.ts, year.labels = TRUE)


# --------------------------------------------
# Forecasting
# --------------------------------------------

# Pass the Nestle stock price data to the ets()
NESTLE.forecast <- ets(NESTLE$close)

# Display the output
NESTLE.forecast

# Get the accuracy of the forecast
accuracy(NESTLE.forecast)


plot(forecast(NESTLE.forecast))

test2 <- ets(NESTLE.monthly.ts, model = "MAM", damped = TRUE)
plot(forecast(test2))



# --------------------------------------------
# ARIMA
# --------------------------------------------

Acf(NESTLE$close, main = "Acf Plot")
acf(NESTLE$close)
Pacf(nestle$close)

# Log transformation
NESTLE.log <- log(NESTLE$close)

# Square root transformation
NESTLE.sqrt <- sqrt(NESTLE$close)

# Box-Cox Transformation
lamda <- BoxCox.lambda(NESTLE$close)
NESTLE.boxcox <- BoxCox(NESTLE$close, lamda)

# ACF and PACF
Acf(NESTLE.log)
Pacf(NESTLE.log)

# Diff
diff.ori    <- diff(NESTLE$close)
diff.log    <- diff(NESTLE.log)
diff.sqrt   <- diff(NESTLE.sqrt)
diff.boxcox <- diff(NESTLE.boxcox)

par(mfrow = c(2,2))
plot(diff.ori, main = "Original Data")
plot(diff.log, main = "Log-transformed Data", col = "#29AB87")
plot(diff.sqrt, main = "Square root transformed Data", col = "#CC7722")
plot(diff.boxcox, main = "Box-Cox transformed Data", col = "#7285A5")

# Ljung-Box Test for zero autocorrelation
Box.test(NESTLE$close, lag = 10, type = "Ljung-Box")

# Dickey-Fullet Test
adf.test(diff.ori[-1])
adf.test(diff.log[-1])
adf.test(diff.sqrt[-1])
adf.test(diff.boxcox[-1])


# Plot Acf
par(mfrow = c(2,2))
Acf(diff.ori)
Acf(diff.log)
Acf(diff.sqrt)
Acf(diff.boxcox)
Pacf(diff.log)
Acf(NESTLE$close)


# Auto Arima
NESTLE.arima <- auto.arima(NESTLE$close)
par(mfrow = c(1,1))
plot(forecast(NESTLE.arima, 20))


# --------------------------------------------
# Cleaning other data
# --------------------------------------------
DLADY  <- tq_get("3026.KL", get = "stock.prices", from = "2013-01-01", to = "2017-12-31")
FNN    <- tq_get("3689.KL", get = "stock.prices", from = "2013-01-01", to = "2017-12-31")
AJI    <- tq_get("2658.KL", get = "stock.prices", from = "2013-01-01", to = "2017-12-31")

# Replace all missing values for DLADY, FNN & AJI
DLADY.cleaned <- DLADY %>% 
  fill(close, adjusted) %>% 
  mutate(open   = if_else(is.na(open), close, open),
         high   = if_else(is.na(high), close, high),
         low    = if_else(is.na(low), close, low),
         volume = if_else(is.na(volume), 0, volume))

FNN.cleaned   <- FNN %>% 
  fill(close, adjusted) %>% 
  mutate(open   = if_else(is.na(open), close, open),
         high   = if_else(is.na(high), close, high),
         low    = if_else(is.na(low), close, low),
         volume = if_else(is.na(volume), 0, volume))

AJI.cleaned  <- AJI %>% 
  fill(close, adjusted) %>% 
  mutate(open   = if_else(is.na(open), close, open),
         high   = if_else(is.na(high), close, high),
         low    = if_else(is.na(low), close, low),
         volume = if_else(is.na(volume), 0, volume))



# --------------------------------------------
# Cleaning other data
# --------------------------------------------

# A function that will rename our columns and turn it into a xts object
ren_xts <- function(myData, stockName, stockColNames) {
  myCol <-  str_c(stockName, capitalize(stockColNames), sep = ".")
  colnames(myData) <- myCol
  myData <- xts(myData[, 2:7], order.by = myData[[1]])
  
  return(myData)
}

NESTLE.cleaned <- ren_xts(nestle.cleaned, "NESTLE", colnames(nestle.cleaned))
DLADY.cleaned <- ren_xts(DLADY.cleaned, "DLADY", colnames(DLADY.cleaned))
FNN.cleaned <- ren_xts(FNN.cleaned, "FNN", colnames(FNN.cleaned))
AJI.cleaned <- ren_xts(AJI.cleaned, "AJI", colnames(AJI.cleaned))

# Select the Close price only
closePrices <- cbind(NESTLE.cleaned$NESTLE.Close, 
                     DLADY.cleaned$DLADY.Close, 
                     FNN.cleaned$FNN.Close, 
                     AJI.cleaned$AJI.Close)
closePrices[c(1:3, nrow(closePrices)), ]


# Convert the data into dataframe
closeDataframe <- cbind(Date = index(closePrices), data.frame(closePrices))
rownames(closeDataframe) <- seq(1, nrow(closeDataframe), 1)
names(closeDataframe) <- c("Date","NESTLE", "DLADY", "FNN", "AJI")
closeDataframe <- as_tibble(closeDataframe)

# Normalize the data
myData <- closeDataframe %>% 
  mutate_at(vars(matches("[[:upper:]]$", ignore.case = FALSE)), funs(idx = ./.[1]))
myData[c(1:3, nrow(myData)), ]


par(oma = c(0, 0, 3, 0))
par(mfrow = c(2, 2))
y.range <- range(myData[,6:9])
plot(x = myData$Date, 
     xlab = "", 
     y = myData$AJI_idx,
     ylim = y.range,
     ylab = "",
     type = "l",
     col = "gray",
     main = "Nestle Stock")
lines(x = myData$Date, y = myData$DLADY_idx, col = "gray")
lines(x = myData$Date, y = myData$FNN_idx, col = "gray")
lines(x = myData$Date, y = myData$NESTLE_idx, col = "#0F52BA", lwd = 2.5)
abline(h=1)

plot(x = myData$Date,
     y = myData$AJI_idx,
     xlab = "",
     ylab = "",
     ylim = y.range,
     type = "l",
     col = "gray",
     main = "Dutch Lady Stock")
lines(x = myData$Date, y = myData$NESTLE_idx, col = "gray")
lines(x = myData$Date, y = myData$FNN_idx, col = "gray")
lines(x = myData$Date, y = myData$DLADY_idx, col = "limegreen", lwd = 2.5)
abline(h=1)

plot(x = myData$Date, 
     xlab = "", 
     y = myData$DLADY_idx,
     ylim = y.range,
     ylab = "",
     type = "l",
     col = "gray",
     main = "Ajinomoto Stock")
lines(x = myData$Date, y = myData$NESTLE_idx, col = "gray")
lines(x = myData$Date, y = myData$FNN_idx, col = "gray")
lines(x = myData$Date, y = myData$AJI_idx, col = "#DC143C", lwd = 2.5)
abline(h=1)

plot(x = myData$Date, 
     xlab = "", 
     y = myData$AJI_idx,
     ylim = y.range,
     ylab = "",
     type = "l",
     col = "gray",
     main = "F&N Stock")
lines(x = myData$Date, y = myData$NESTLE_idx, col = "gray")
lines(x = myData$Date, y = myData$DLADY_idx, col = "gray")
lines(x = myData$Date, y = myData$FNN_idx, col = "coral", lwd = 2.5)
abline(h=1)

title(main = "Value of RM1 Invested in Malaysia Stock Market\nJanuary 2013 - December 2017", 
      outer = TRUE, line = -1, cex = )


