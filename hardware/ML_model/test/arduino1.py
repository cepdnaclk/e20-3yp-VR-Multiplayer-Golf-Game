import time
import pyfirmata
from smbus2 import SMBus

# Bluetooth Serial Port (Change this to match your system)
SERIAL_PORT = "COM9"  # Windows example: "COM3", Linux/macOS: "/dev/rfcomm0"

# Initialize PyFirmata
board = pyfirmata.Arduino(SERIAL_PORT)

# Define Button Pins
button_pins = [4, 5, 6]

# Initialize Buttons as Inputs
for pin in button_pins:
    board.digital[pin].mode = pyfirmata.INPUT

# Initialize I2C (for MPU6050 sensors)
MPU6050_ADDR_1 = 0x68  # First MPU6050 (AD0 → GND)
MPU6050_ADDR_2 = 0x69  # Second MPU6050 (AD0 → VCC)

bus = SMBus(1)  # Use SMBus(1) for Raspberry Pi, check for other systems

def initialize_mpu6050(address):
    """ Initialize MPU6050 by waking it up """
    bus.write_byte_data(address, 0x6B, 0)  # Wake up sensor
    time.sleep(0.1)

def read_mpu6050(address):
    """ Read accelerometer and gyroscope data from MPU6050 """
    data = bus.read_i2c_block_data(address, 0x3B, 14)
    accel_x = (data[0] << 8) | data[1]
    accel_y = (data[2] << 8) | data[3]
    accel_z = (data[4] << 8) | data[5]
    gyro_x = (data[8] << 8) | data[9]
    gyro_y = (data[10] << 8) | data[11]
    gyro_z = (data[12] << 8) | data[13]

    return [accel_x, accel_y, accel_z, gyro_x, gyro_y, gyro_z]

# Initialize MPU6050 Sensors
initialize_mpu6050(MPU6050_ADDR_1)
initialize_mpu6050(MPU6050_ADDR_2)

print("Reading Data...")

while True:
    try:
        # Read Gyro Data
        gyro1_data = read_mpu6050(MPU6050_ADDR_1)
        gyro2_data = read_mpu6050(MPU6050_ADDR_2)

        # Read Button States
        button_states = [board.digital[pin].read() for pin in button_pins]

        # Print Data
        print(f"Gyro1: {gyro1_data}")
        print(f"Gyro2: {gyro2_data}")

        for i, state in enumerate(button_states):
            print(f"Button {i + 1}: {'PRESSED' if state == 0 else 'RELEASED'}")

        print("------------------------")
        time.sleep(0.5)

    except KeyboardInterrupt:
        print("Exiting...")
        board.exit()
        break
