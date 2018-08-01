# STA705 - Statistical Computing

## Individual Project: Time Series Analysis

### Introduction

The task given by the Professor was to analyze time series data. Any time series data can be used but must be analyzed thoroughly.  
  
I chose to analyze Malaysian stock market focusing on the following four companies:
  1. Nestle
  2. Dutch Lady
  3. F&N
  4. Ajinomoto

The primary focus of this study will be on Nestle stock price. The other three stock price will be used for comparative investment gain. 

### Dataset

The data used in this project spans from January 2013 to December 2017. It was retrieved directly from [Yahoo! Finance](https://finance.yahoo.com/) through the `tq_get()` R command which is part of the `tidyquant` library.  
  
The following code shows how Nestle stock price data can be directly downloaded into the R environment.

```R
library(tidyquant)

nestle <- tq_get("4707.KL", get = "stock.prices", from = "2013-01-01", to = "2017-12-31")
```  

Table below shows the Yahoo! Finance symbol to be used inside the R code. 

| KLSE    | Yahoo! Finance Symbol| Company Name                         |
| ------- |:--------------------:| ------------------------------------ |
| NESTLE  | 4707.KL              | Nestle Malaysia Berhad               |
| DLADY   | 3026.KL              | Dutch Lady Milk Industries Bhd       |
| F&N     | 3689.KL              | Fraser & Neave (F&N) Holdings Berhad |
| AJI     | 2658.KL              | Ajinomoto Malaysia Berhad            |

The data used in this project were exported and are made available in this github. 

### Analysis

#### 1. Stock Price Movement

![nestle_stock_price](https://user-images.githubusercontent.com/24283367/43524131-0bbe9536-95d1-11e8-8f9a-6490cd201663.png)

The graph above shows the stock price change for Nestle from January 2013 to January 2017. Price have increases from RM 62.86 to RM 103.20.

#### 2. 50-day & 200-day Simple Moving Average (SMA)
  
One of the most popular technical trend indicator among stock investors are the simple moving average 50-days and 200-days.  
  
![nestle_sma](https://user-images.githubusercontent.com/24283367/43528327-47e8fba0-95db-11e8-8482-00d600bfe5f8.png)

If the 50-day SMA crosses under the 200-day SMA, it is usually a good indicator to sell the stock. The same goes the other way, if the 50-day SMA crosses over the 200-day SMA, investors will generally rush to buy the stocks
  
## Group Project: Multivariate Linear Regression Analysis

### Introduction

A good concrete has the following qualities: strong, durable and resist wear and tear. There are three tests that are good at measuring concrete strength. Those tests are:
  * concrete slump test
  * flow table test
  * compressive strength test

### Objectives

1. To model our three measure of concrete strength into three separate linear regression.  
  
2. To identify the best variable selection method for our linear models:
    * BIC via regsubset() function
    * AIC va step() function

3. Explore the simulation() function with our three linear models.

### Results

AIC selection method has the highest adjusted-R<sup>2</sup> for all three models.

Original adjusted-R<sup>2</sup> means all the variables/predictors are used to build the linear regression model.

| Linear Model  | Original Adjusted R<sup>2</sup> | BIC Adjusted R<sup>2</sup>| AIC Adjusted R<sup>2</sup>|
| ------------- |:-------------------------------:| :-----------------------: | ------------------------- |
| Slump         | 0.2734                          | 0.2773                    | 0.2773                    |
| Flow          | 0.4656                          | 0.4745                    | 0.4857                    |
| Strength      | 0.8892                          | 0.887                     | 0.8897                    |

### Team Members

* Danial Syairiman Razali
* Muhammad Arief Roslan

### Dataset

Data was made available by I-Cheng Yeh and retrieved from UCI Machine Learning website. 

* Yeh, I-Cheng, "Modeling slump flow of concrete using second-order regressions and artificial neural networks," Cement and Concrete Composites, Vol.29, No. 6, 474-480, 2007

* Dua, D. and Karra Taniskidou, E. (2017). [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml). Irvine, CA: University of California, School of Information and Computer Science.

## Lecturer

[Assoc. Prof. Dr. Sayang Mohd Deni](https://fskm.uitm.edu.my/v4/index.php?option=com_content&view=article&id=236&catid=44&Itemid=227)
