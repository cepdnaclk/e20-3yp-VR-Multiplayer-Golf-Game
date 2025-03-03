import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.animation import FuncAnimation

# Load CSV file
file_path = "filtered_gyro_data.csv"  # Ensure this is the correct path
df = pd.read_csv(file_path)

# Extract gyroscope values
gx = df["Gyro_X"]
gy = df["Gyro_Y"]
gz = df["Gyro_Z"]

# Convert gyroscope readings into a simulated position (simple integration)
x_pos = np.cumsum(gx - np.mean(gx)) / 1000
y_pos = np.cumsum(gy - np.mean(gy)) / 1000
z_pos = np.cumsum(gz - np.mean(gz)) / 1000

# Create figure
fig = plt.figure(figsize=(8, 6))
ax = fig.add_subplot(111, projection="3d")

# Initialize plot
line, = ax.plot([], [], [], marker="o", linestyle="-", color="b", label="Gyroscope Path")

# Set axis labels
ax.set_xlabel("X Position")
ax.set_ylabel("Y Position")
ax.set_zlabel("Z Position")
ax.set_title("3D Gyroscope Movement Path")

# Set axis limits dynamically
ax.set_xlim(min(x_pos), max(x_pos))
ax.set_ylim(min(y_pos), max(y_pos))
ax.set_zlim(min(z_pos), max(z_pos))

# Function to update animation
def update(num):
    line.set_data_3d(x_pos[:num], y_pos[:num], z_pos[:num])
    return line,

# Create animation
ani = FuncAnimation(fig, update, frames=len(x_pos), interval=100, repeat=True)

# Show plot
plt.legend()
plt.show()
