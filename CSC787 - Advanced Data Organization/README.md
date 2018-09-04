# CSC787 - Advanced Data Organization

## Introduction

Kiva is an international nonprofit, founded in 2005 and based in San Francisco, with a mission to connect people through lending to alleviate poverty. 

## Objectives

From the given dataset, our team were required to:  
1. Build data model 
2. Transform data into valuable insights.
    
## Data Pre-Processing

1. Change attribute types
2. Replace missing values
3. Generate new attributes
4. Join data with external source

## Analysis

*(All of the analysis below was completed by me. Some of the figures were created using R while the rest through Microsoft Power BI)*

### Where are Kiva borrowers originated from?

Kiva borrowers come from all part of the world. Mapping the borrower’s country of origin will allow us to observe the magnitude of impact Kiva is currently making around the world.

![world_map_detail](https://user-images.githubusercontent.com/24283367/45037481-adf41080-b091-11e8-8fd5-61a325e9e307.PNG)

The size of the circle in figure above indicates the number of Kiva borrowers from that country. Thus, the bigger the circle, the higher the number of borrowers. From the figure above we can see that Kiva borrowers comes mainly from third world countries.  

### Loan Use Description

When a request for a loan is being made on Kiva's website, borrowers usually includes a short description of their goal or obejectve.

One of the best method to investigate text analytics is through the use of word clouds. Word clouds highlights the most words that are being used by borrowers from our dataset. Figure 20 below shows the word cloud generated from the loan use description.

<p align="center">
  <img src = "https://user-images.githubusercontent.com/24283367/45037826-6de15d80-b092-11e8-9fb6-079ea2a60baf.png" width 280 height = 360/>
</p>

To gain a better insights on the usage of the loan made by the borrowers, business words such as *buy*, *purchase* and *sell* are removed. 

<p align="center">
  <img src = "https://user-images.githubusercontent.com/24283367/45038826-a1bd8280-b094-11e8-8031-97558a32f855.png" width 150 height = 300/>
</p>



## Team Members

* Syafiqah Mohd Hassan
* Muhammad Zharif Zamri

## Lecturers

* [Prof. Dr. Siti Zaleha Zainal Abidin](https://fskm.uitm.edu.my/v4/index.php?option=com_content&view=article&id=278&catid=43&Itemid=227)  
* [Suzana Ahmad](https://fskm.uitm.edu.my/v4/index.php?option=com_content&view=article&id=280&catid=43&Itemid=227)

## Dataset

Data was provided by our lecturers. It contains more rows but less columns than the Kiva dataset available at [Kaggle](https://www.kaggle.com/kiva/data-science-for-good-kiva-crowdfunding).
