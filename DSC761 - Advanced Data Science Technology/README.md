# DSC761 - Advanced Data Science Technology
  
## Group Project: Predictive Modeling for Student Performance Data Using Python Machine Learning Algorithm (Decision Tree & SVM)

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

Only the SVM results is shown below as this is the part that I performed. The decision tree model is completed by the other three team members.

| SVC Model          | Portuguese Dataset | Portuguese Dataset (with parameter tuning) | Mathematics Dataset | Mathematics Dataset (with parameter tuning) |
| ------------------ |:------------------:| :----------------------------------------: | :-----------------: | ------------------------------------------- |
| Training Accuracy  | 0.8811             | 0.7753                                     | 0.8950              | 0.8877                                      |
| Testing Accuracy   | 0.5744             | 0.6769                                     | 0.5546              | 0.6050                                      |

For Portuguese score dataset, we see an improvement in the accuracy by 10.3% when we perform parameter tuning.  
  
For Math score dataset, we see an improvement in the accuracy by 5.04% when we perform parameter tuning. 

### Team Members

* Danial Syairiman Razali
* Muhammad Arief Roslan 
* Muhammad Zharif Zamri
* Izwan Asraf Md Zin

### Dataset

Data was made available by Paulo Cortez and retrieved from UCI Machine Learning website. 

* P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7.

* Dua, D. and Karra Taniskidou, E. (2017). [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml). Irvine, CA: University of California, School of Information and Computer Science.

## Lecturer

[Dr. Maryam]  
[Dr. Azlan Ismail](https://fskm.uitm.edu.my/v4/index.php?option=com_content&view=article&id=246&catid=43&Itemid=227)
