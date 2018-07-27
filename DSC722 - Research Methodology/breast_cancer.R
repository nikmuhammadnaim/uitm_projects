library(tidyverse)
library(caret)
library(psych)
library(neuralnet)
library(gmodels)
library(GGally)

# --------------------------------------
# Preparing the dataset
# --------------------------------------

# Read the data 
breast.cancer <- read_csv("DSC722 - Research Methodology/wdbc.csv",
                          col_names = FALSE, 
                          col_types = cols(X2 = col_factor(NULL)))


# Retrieve the column names from the UCI Website
column.names <- c("radius", "texture", "perimeter", "area", "smoothness", "compactness",
                  "concavity", "concave.points", "symmetry", "fractal.dimension")
column.a <- str_c(column.names, "mean", sep = "_")
column.b <- str_c(column.names, "SE", sep = "_")
column.c <- str_c(column.names, "worst", sep = "_")


# Rename our column dataset
names(breast.cancer) <- c("id", "diagnosis", column.a, column.b, column.c)


# Verify that data has been renamed properly
breast.cancer %>% glimpse()


# --------------------------------------
# Exploratory Data Analysis
# --------------------------------------

# Visualize attributes (mean) that are highly correlated to each other
pairs.panels(breast.cancer[3:12])

pairs.panels(breast.cancer[,c(12:21)], method="pearson",
             hist.col = "#1fbbfa", density=TRUE, ellipses=TRUE, show.points = TRUE,
             pch=1, lm=TRUE, cex.cor=1, smoother=F, stars = T, main="Cancer SE")

ggpairs(breast.cancer[2:5])


# --------------------------------------
# Data Pre-Processing
# --------------------------------------

# Create a normalize function for neural network
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

# Normalize our dataset
bc.norm <- breast.cancer %>% mutate_at(vars(-1:-2), funs(normalize))

# Compare the summary of original and normalized data
summary(breast.cancer)
summary(bc.norm)

# The neuralnet package requires each group to have their own numerical column
bc.norm.mod <- bc.norm %>% 
  mutate(M = if_else(diagnosis == "M", 1, 0), B = if_else(M == 1, 0, 1))

# Split  into test and training dataset
set.seed(1234)
data.partition <- createDataPartition(bc.norm.mod$diagnosis, p = 0.7, list = FALSE)
train.data <- bc.norm.mod[data.partition, -1]
test.data  <- bc.norm.mod[-data.partition, -1] 

# Check to make sure that split is done correctly
prop.table(table(breast.cancer$diagnosis))
prop.table(table(train.data$diagnosis))
prop.table(table(test.data$diagnosis))


# --------------------------------------
# Training Model
# --------------------------------------

set.seed(1220)

# Default ANN Model: Uses 1 hidden neurons
bc.model <- neuralnet(M + B ~ radius_mean + texture_mean + perimeter_mean + 
                        area_mean + smoothness_mean + compactness_mean + concavity_mean + 
                        concave.points_mean + symmetry_mean + fractal.dimension_mean + 
                        radius_SE + texture_SE + perimeter_SE + area_SE + smoothness_SE + 
                        compactness_SE + concavity_SE + concave.points_SE + symmetry_SE + 
                        fractal.dimension_SE + radius_worst + texture_worst + 
                        perimeter_worst + area_worst + smoothness_worst + 
                        compactness_worst + concavity_worst + concave.points_worst + 
                        symmetry_worst + fractal.dimension_worst, data = train.data, 
                      act.fct = "logistic", linear.output = FALSE, lifesign = "minimal")

# Custom ANN Model: Uses 6 hidden neurons 
bc.model2 <- neuralnet(M + B ~ radius_mean + texture_mean + perimeter_mean + 
                        area_mean + smoothness_mean + compactness_mean + concavity_mean + 
                        concave.points_mean + symmetry_mean + fractal.dimension_mean + 
                        radius_SE + texture_SE + perimeter_SE + area_SE + smoothness_SE + 
                        compactness_SE + concavity_SE + concave.points_SE + symmetry_SE + 
                        fractal.dimension_SE + radius_worst + texture_worst + 
                        perimeter_worst + area_worst + smoothness_worst + 
                        compactness_worst + concavity_worst + concave.points_worst + 
                        symmetry_worst + fractal.dimension_worst, data = train.data, 
                      act.fct = "logistic", linear.output = FALSE, hidden = 6, 
                      lifesign = "minimal")

# Plot the neural network topology
plot(bc.model)
plot(bc.model2)

# Check the available command for our ANN model
names(bc.model)

# List out the result - checking the output stored
bc.model$net.result

# Compute predictions on training dataset [compute is from the neuralnet package]
bc.trainResult  <- compute(bc.model, train.data[2:31])
bc.trainResult2 <- compute(bc.model2, train.data[2:31]) 

# Extract the training dataset results. Result is numerical in each column.
# The highest column is the one that is predicted by the model.
trainResult  <- bc.trainResult$net.result
trainResult2 <- bc.trainResult2$net.result

# Find the max column and label accordingly
predicted.train <- trainResult %>% 
  max.col() %>% 
  factor(., labels = c("M", "B"))

predicted.train2 <- trainResult2 %>% 
  max.col() %>% 
  factor(., labels = c("M", "B"))

# Compare the accuracy
train.original   <- max.col(train.data[32:33])
train.neuralnet  <- max.col(trainResult)
train.neuralnet2 <- max.col(trainResult2)
mean(train.original == train.neuralnet)
mean(train.original == train.neuralnet2)

train.data.mod <- train.data %>% 
  add_column(predicted = factor(predicted.train), .before = 1)

# Create confusion matrix with the training dataset for default ANN model
CrossTable(train.data.mod$diagnosis, train.data.mod$predicted, 
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c("Actual Diagnosis", "Predicted Diagnosis"))

# Compute predictions on test dataset
bc.testResult  <- compute(bc.model, test.data[2:31])
bc.testResult2 <- compute(bc.model2, test.data[2:31])

# Extract the testing datasetresults
testResult  <- bc.testResult$net.result
testResult2 <- bc.testResult2$net.result 

# Compare the accuracy
test.original   <- max.col(test.data[32:33])
test.neuralnet  <- max.col(testResult)
test.neuralnet2 <- max.col(testResult2)
mean(test.original == test.neuralnet)
mean(test.original == test.neuralnet2)

predicted.test <- testResult %>% 
  max.col() %>% 
  factor(., labels = c("M", "B"))

predicted.test2 <- testResult2 %>% 
  max.col() %>% 
  factor(., labels = c("M", "B"))

# Create the confusion matrix on the test dataset for the default ANN model
CrossTable(test.data$diagnosis, predicted.test, 
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c("Actual Diagnosis", "Predicted Diagnosis"))

# Create the confusion matrix on the test dataset for the custom ANN model
CrossTable(test.data$diagnosis, predicted.test2, 
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c("Actual Diagnosis", "Predicted Diagnosis"))


