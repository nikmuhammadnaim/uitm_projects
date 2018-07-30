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

### Detailed Analysis
  
  
  
## Group Project: Multivariate Linear Regression Analysis

### Introduction


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
