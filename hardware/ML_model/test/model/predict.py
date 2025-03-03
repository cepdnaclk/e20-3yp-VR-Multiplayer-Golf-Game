import matplotlib.pyplot as plt

# Get predictions
y_pred = model.predict(X_test)

# Convert back to original scale
y_pred_original = scaler.inverse_transform(y_pred)

# Plot predictions vs actual values
plt.figure(figsize=(10,5))
plt.plot(y_pred_original[:, 0], label="Predicted Gyro X")
plt.plot(y_test[:, 0], label="Actual Gyro X")
plt.legend()
plt.show()
