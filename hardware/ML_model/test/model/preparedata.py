import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler

# Load data
data = pd.read_csv("gyro1_data.csv")

# Normalize data
scaler = MinMaxScaler()
data_scaled = scaler.fit_transform(data)

# Convert to input-output pairs (for LSTM)
X = []
y = []
time_steps = 10  # Number of previous readings used for prediction

for i in range(len(data_scaled) - time_steps):
    X.append(data_scaled[i:i+time_steps])
    y.append(data_scaled[i+time_steps])

X = np.array(X)
y = np.array(y)

# Split into training and testing
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
