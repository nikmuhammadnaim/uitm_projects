# DSC721 - Enterprise Data Analytics

## Introduction

This project was carried out using RapidMiner software. The work can be replicated in RapidMiner by importing the .rmp files into the RapidMiner environment using the 'import process' function in the menu. 

Effort to replicate the work into R is in progress.

## Objectives
  
1. To correctly predict Taiwanese clients' credit card default payment for the month October 2005.

2. To compare the performance of single machine learning models with an ensemble model. 
    * Three single learners that will be used are:
      1. Naïve Bayes
      2. Decision Tree
      3. Deep Learning
        
    * The ensemble model will use the majority voting technique of the three single learners.
    
## RapidMiner Process

### Data Pre-Processing

![data_pre_processing](https://user-images.githubusercontent.com/24283367/43643058-8c17a754-975c-11e8-9693-d3128e7e2f12.PNG)


### Single Learners

![single_learners](https://user-images.githubusercontent.com/24283367/43643644-8659d9ca-975e-11e8-870a-0401c6bcb36e.PNG)


### Ensemble Model

![ensemble_model](https://user-images.githubusercontent.com/24283367/43643414-cb8d68a0-975d-11e8-9611-31cfc6409045.PNG)

* Inside the voting sub-process are the single learners (using the same settings from earlier)

![ensemble_model_detailed](https://user-images.githubusercontent.com/24283367/43643462-f05f2c2c-975d-11e8-9bef-8646d7eea591.PNG)
    
## Results

Decision Tree have the best performance out of the four models. It has the highest accuracy and recall. 

| Machine Learning Model  | Accuracy | Precision | Recall |
| ----------------------- |:--------:| --------- | ------ |
| Decision Tree           | 83.34%   | 84.85%    | 96.09% |
| Ensemble (voting)       | 83.29%   | 85.23%    | 95.41% |
| Deep Learning           | 83.26%   | 85.48%    | 94.96% |
| Naïve Bayes             | 65.29%   | 88.30%    | 64.68% |

## Team Member

* Muhammad Arief Roslan
* Nur Faiqah Zulkefli

## Lecturer

[Dr. Ruhaila Maskat](https://fskm.uitm.edu.my/v4/index.php?option=com_content&view=article&id=178&catid=45&Itemid=227)

## Dataset

Data was made available by  I-Cheng Yeh and retrieved from UCI Machine Learning website.

* Yeh, I. C., & Lien, C. H. (2009). The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients. Expert Systems with Applications, 36(2), 2473-2480.

* Dua, D. and Karra Taniskidou, E. (2017). [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml). Irvine, CA: University of California, School of Information and Computer Science.
