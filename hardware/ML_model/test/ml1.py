import serial

# Replace 'COM12' with your actual COM port (e.g., 'COM3' on Windows or '/dev/ttyUSB0' on Linux/Mac)
serial_port = "COM12"
baud_rate = 9600

try:
    # Open the serial connection
    ser = serial.Serial(serial_port, baud_rate, timeout=1)
    print(f"Connected to {serial_port} at {baud_rate} baud.")

    while True:
        if ser.in_waiting > 0:  # Check if data is available
            data = ser.readline().decode('utf-8').strip()  # Read and decode data
            print(f"Received: {data}")

except serial.SerialException as e:
    print(f"Error: {e}")
except KeyboardInterrupt:
    print("\nDisconnected.")
finally:
    if 'ser' in locals() and ser.is_open:
        ser.close()
