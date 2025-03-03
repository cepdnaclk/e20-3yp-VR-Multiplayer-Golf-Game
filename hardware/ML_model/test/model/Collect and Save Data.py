import serial
import csv
import time

def read_and_save_data(serial_port='COM12', baud_rate=9600, file_name="sensor_data.csv"):
    ser = serial.Serial(serial_port, baud_rate, timeout=1)

    with open(file_name, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["timestamp", "raw_data"])  # Store all data as raw text

        while True:
            try:
                if ser.in_waiting > 0:
                    # Read line from serial and ignore encoding errors
                    data = ser.readline().decode('utf-8', errors='ignore').strip()

                    # Save with timestamp
                    timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
                    writer.writerow([timestamp, data])

                    # Print received data
                    print(f"[{timestamp}] {data}")

            except Exception as e:
                print("Error:", e)

# Start collecting data
read_and_save_data()
