# Import all the required files
from keras import models, layers
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the dataset
customer = pd.read_csv('telco_customer_churn.csv')

# Verify that the data has been loaded properly
customer.info()

# Change TotalCharges to numeric
customer.TotalCharges = pd.to_numeric(customer.TotalCharges, errors='coerce')

# Change SeniorCitizen to object
customer.SeniorCitizen = customer.SeniorCitizen.apply(
                            lambda x: 'Yes' if x == 1 else 'No')

# Check the structure of the data again
customer.info()

# Plot a correlation heatmap
corr = customer.corr()
plt.figure(figsize=(15, 15))
sns.heatmap(corr, annot=True, cmap='Blues')
plt.title('Telco Customer Correlation Heatmap', fontsize=24)

# Data preprocessing
# a) Replace missing values with 0
customer.TotalCharges.fillna(0, inplace=True)

customer.isnull().sum().sum()

# b) Drop customerID column
customer.drop('customerID', axis=1, inplace=True)

# c) Change the output to numeric
customer.Churn.replace(to_replace='Yes', value=1, inplace=True)
customer.Churn.replace(to_replace='No', value=0, inplace=True)

# d) Covert into dummy variables
customer_dummies = pd.get_dummies(customer)

# Verify the changes
customer_dummies.head()

# e) Separate input variables and target variable
x = customer_dummies.drop('Churn', axis=1)
y = customer_dummies.Churn.values

# f) Create training and testing dataset
x_train, x_test, y_train, y_test = train_test_split(x,
                                                    y,
                                                    test_size=0.3,
                                                    random_state=424)

# g) Scale the whole dataset
scaler = StandardScaler()
x_train = scaler.fit_transform(x_train)
x_test = scaler.fit_transform(x_test)

# Check the shape of the dataset to set the input shape (depends on column num.)
x_train.shape

# --- Build the Deep Learning Model ---
# Build the layers
model = models.Sequential()
model.add(layers.Dense(64, kernel_initializer='uniform', activation='relu', input_shape = (46, )))
model.add(layers.Dense(64, kernel_initializer='uniform', activation='relu'))
model.add(layers.Dense(64, kernel_initializer='uniform', activation='relu'))
model.add(layers.Dense(64, kernel_initializer='uniform', activation='relu'))
model.add(layers.Dense(64, kernel_initializer='uniform', activation='relu'))
model.add(layers.Dense(64, kernel_initializer='uniform', activation='relu'))
model.add(layers.Dense(1, kernel_initializer='uniform', activation='sigmoid'))

# Compile the model
model.compile(optimizer='rmsprop',
              loss='binary_crossentropy',
              metrics=['accuracy'])

# Validation
history = model.fit(x_train,
                    y_train,
                    epochs=10,
                    batch_size=8,
                    validation_data=(x_test, y_test))

# Evaluate the model
model.evaluate(x_test, y_test)
