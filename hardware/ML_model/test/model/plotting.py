import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Load CSV file
file_path = "gyro1_data.csv"  # Change this to your CSV file path
df = pd.read_csv(file_path)

# Extract gyroscope values
gx = df["gx"]
gy = df["gy"]
gz = df["gz"]

# Create a 3D plot
fig = plt.figure(figsize=(8, 6))
ax = fig.add_subplot(111, projection="3d")

# Plot the gyroscope data
ax.plot(gx, gy, gz, marker="o", linestyle="-", color="b", label="Gyroscope Path")

# Labels
ax.set_xlabel("Gx (Angular Velocity X)")
ax.set_ylabel("Gy (Angular Velocity Y)")
ax.set_zlabel("Gz (Angular Velocity Z)")
ax.set_title("3D Gyroscope Data Visualization")

# Show legend
ax.legend()

# Show the plot
plt.show()
