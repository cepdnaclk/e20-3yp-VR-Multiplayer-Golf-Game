# import serial
# import pandas as pd
# import time
#
# # Replace 'COMx' with the correct port for Windows or '/dev/ttyUSBx' for Linux/Mac
# SERIAL_PORT = "COM12"  # Example for Windows, use "/dev/ttyUSB0" or "/dev/ttyACM0" for Linux/Mac
# BAUD_RATE = 115200  # Same as in the Arduino code
# CSV_FILE = "arduino_data.csv"
#
# # Open serial connection
# ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
# time.sleep(2)  # Allow time for Arduino to reset
#
# # Create an empty DataFrame
# data_list = []
#
# try:
#     print("Reading data from Arduino... Press Ctrl+C to stop.")
#
#     while True:
#         if ser.in_waiting > 0:
#             data = ser.readline().decode("utf-8").strip()
#             timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
#             print(f"{timestamp}: {data}")
#
#             # Append data to list
#             data_list.append([timestamp, data])
#
#             # Save to CSV every 10 entries (to reduce file write operations)
#             if len(data_list) % 10 == 0:
#                 df = pd.DataFrame(data_list, columns=["Timestamp", "Data"])
#                 df.to_csv(CSV_FILE, index=False)
#
# except KeyboardInterrupt:
#     print("\nStopping data logging...")
#
#     # Save final data
#     df = pd.DataFrame(data_list, columns=["Timestamp", "Data"])
#     df.to_csv(CSV_FILE, index=False)
#     print(f"Data saved to {CSV_FILE}")
#
# finally:
#     ser.close()
#
#



import serial
import pandas as pd
import time
import re

# Define serial port and baud rate (change COMx for Windows or /dev/ttyUSBx for Linux/Mac)
SERIAL_PORT = "COM12"  # Example: "/dev/ttyUSB0" or "/dev/ttyACM0" for Linux/Mac
BAUD_RATE = 115200  # Must match Arduino

# Define file names
RAW_CSV_FILE = "arduino_data.csv"
FILTERED_CSV_FILE = "filtered_gyro_data.csv"

# Open serial connection
ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
time.sleep(2)  # Allow time for Arduino to reset

# Lists to store raw and structured data
raw_data_list = []
structured_data = []

try:
    print("Reading data from Arduino... Press Ctrl+C to stop.")

    while True:
        if ser.in_waiting > 0:
            data = ser.readline().decode("utf-8").strip()
            timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
            print(f"{timestamp}: {data}")

            # Store raw data
            raw_data_list.append([timestamp, data])

            # Extract numerical values using regex
            match = re.search(r"Gyro: ([\d\-]+),([\d\-]+),([\d\-]+),([\d\-]+),([\d\-]+),([\d\-]+)", data)
            if match:
                gyro_x = int(match.group(1))
                gyro_y = int(match.group(2))
                gyro_z = int(match.group(3))
                accel_x = int(match.group(4))
                accel_y = int(match.group(5))
                accel_z = int(match.group(6))

                # Append structured data
                structured_data.append([timestamp, gyro_x, gyro_y, gyro_z, accel_x, accel_y, accel_z])

            # Save to CSV every 10 entries (to reduce file write operations)
            if len(raw_data_list) % 10 == 0:
                # Save raw data
                raw_df = pd.DataFrame(raw_data_list, columns=["Timestamp", "Data"])
                raw_df.to_csv(RAW_CSV_FILE, index=False)

                # Save structured data
                filtered_df = pd.DataFrame(structured_data, columns=["Timestamp", "Gyro_X", "Gyro_Y", "Gyro_Z", "Accel_X", "Accel_Y", "Accel_Z"])
                filtered_df.to_csv(FILTERED_CSV_FILE, index=False)

except KeyboardInterrupt:
    print("\nStopping data logging...")

    # Save final raw data
    raw_df = pd.DataFrame(raw_data_list, columns=["Timestamp", "Data"])
    raw_df.to_csv(RAW_CSV_FILE, index=False)

    # Save final structured data
    filtered_df = pd.DataFrame(structured_data, columns=["Timestamp", "Gyro_X", "Gyro_Y", "Gyro_Z", "Accel_X", "Accel_Y", "Accel_Z"])
    filtered_df.to_csv(FILTERED_CSV_FILE, index=False)

    print(f"Raw data saved to {RAW_CSV_FILE}")
    print(f"Filtered data saved to {FILTERED_CSV_FILE}")

finally:
    ser.close()

