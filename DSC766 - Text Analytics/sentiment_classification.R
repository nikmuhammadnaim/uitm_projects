library(tidyverse)
library(tm)
library(SnowballC)
library(caTools)
library(e1071)
library(gmodels)

judgement = c('Positive', 'Neutral', 'Negative')

netflix <- read_csv('DSC766 - Text Analytics/data/netflix_final_2.csv', 
                    col_types = cols(
                      Keyword        = col_factor(NULL),
                      FinalSentiment = col_factor(judgement),
                      NLTK           = col_factor(judgement),
                      ExpertC        = col_factor(judgement),
                      ExpertB        = col_factor(judgement),
                      ExpertA        = col_factor(judgement)
                    ))
netflix

# -----------------------------------------------
# NLTK vs Human Experts
# -----------------------------------------------

CrossTable(x = netflix$FinalSentiment, 
           y = netflix$NLTK, 
           prop.chisq = FALSE, 
           prop.t = FALSE, 
           dnn = c('actual', 'predicted'))

# Only 44% accuracy


# -----------------------------------------------
# Self-Program vs Human Experts
# -----------------------------------------------

# Create corpus
netflix_corpus <- VCorpus(VectorSource(netflix$Tweet))


# Look at the corpus
netflix_corpus
netflix_corpus[[1]]$content
netflix_corpus[[100]]$content


# Convert everything to lower case
my_corpus <- tm_map(netflix_corpus, content_transformer(tolower))

my_corpus[[1]]$content


# Remove punctuation
my_corpus <- tm_map(my_corpus, removePunctuation)

my_corpus[[1]]$content


# Remove stopwords
my_corpus <- tm_map(my_corpus, removeWords, stopwords("english"))

my_corpus[[1]]$content


# Stem document
my_corpus <- tm_map(my_corpus, stemDocument)

my_corpus[[1]]$content


# Create matrix
dtm = DocumentTermMatrix(my_corpus)

dtm

# Check 
findFreqTerms(dtm, lowfreq=10)


# Remove Sparse Terms
sparse <- removeSparseTerms(dtm, 0.99)

# Convert into dataframe and then into tibble
netflixSparse <- as.data.frame(as.matrix(sparse))
netflixSparse

netflixSparse <- as_tibble(netflixSparse)
netflixSparse


# Add target variable
netflixSparse$sentiment <- netflix$FinalSentiment


# Split the data into training and testing dataset
set.seed(624)

split = sample.split(netflixSparse$sentiment, SplitRatio = 0.7)

train <- netflixSparse[split, ]
test  <- netflixSparse[!split,]

# Check ratio
prop.table(table(netflixSparse$sentiment))
prop.table(table(train$sentiment))
prop.table(table(test$sentiment))


# Convert for Naive Bayes
convert_counts <- function(x) {
  x <- if_else(x > 0, "Yes", "No")
}

train_nb <- train %>% 
  select(-sentiment) %>% 
  mutate_all(funs(convert_counts))


test_nb <- test %>% 
  select(-sentiment) %>% 
  mutate_all(funs(convert_counts))

train_labels <- train$sentiment
test_labels  <- test$sentiment


# --- Naive Bayes ---
nb_classifier <- naiveBayes(train_nb, train_labels)

# Evaluate Naive Bayes
nb_test_pred <- predict(nb_classifier, test_nb)

CrossTable(y = nb_test_pred, 
           x = test_labels, 
           prop.chisq = FALSE, 
           prop.t = FALSE, 
           dnn = c('actual', 'predicted'))


# --- Random Forest ---
rf_classifier <- randomForest(sentiment ~ ., data = train, ntree = 300)

rf_test_pred <- predict(rf_classifier, newdata = test)

CrossTable(y = rf_test_pred, 
           x = test_labels, 
           prop.chisq = FALSE, 
           prop.t = FALSE, 
           dnn = c('actual', 'predicted'))
