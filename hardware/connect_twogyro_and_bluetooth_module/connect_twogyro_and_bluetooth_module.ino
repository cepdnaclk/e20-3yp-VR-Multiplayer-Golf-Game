#include "Wire.h"
#include "MPU6050.h"
#include <SoftwareSerial.h>

SoftwareSerial BTSerial(2, 3);  // Bluetooth TX (D3) & RX (D2)

MPU6050 gyro1(0x68);  // First MPU6050 (AD0 → GND)
MPU6050 gyro2(0x69);  // Second MPU6050 (AD0 → VCC)

// 2D array to store sensor data: [Gyro Index][6 Data Points]
int16_t gyroData[2][6]; 

void setup() {
    Serial.begin(115200); // Serial monitor
    BTSerial.begin(9600); // Bluetooth module

    Wire.begin();  // Initialize hardware I2C
    Serial.println("Initializing Gyroscopes...");

    // Initialize Gyroscope 1
    gyro1.initialize();
    if (!gyro1.testConnection()) {
        Serial.println("Gyro1 (0x68) not responding!");
    } else {
        Serial.println("Gyro1 connected.");
        calibrateMPU6050(gyro1);
    }

    // Initialize Gyroscope 2
    gyro2.initialize();
    if (!gyro2.testConnection()) {
        Serial.println("Gyro2 (0x69) not responding!");
    } else {
        Serial.println("Gyro2 connected.");
        calibrateMPU6050(gyro2);
    }
}

// Function to calibrate MPU6050 gyroscope offsets
void calibrateMPU6050(MPU6050 &gyro) {
    Serial.println("Calibrating...");
    int32_t gx_offset = 0, gy_offset = 0, gz_offset = 0;

    // Take multiple readings to calculate average offset
    for (int i = 0; i < 200; i++) {
        int16_t ax, ay, az, gx, gy, gz;
        gyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

        gx_offset += gx;
        gy_offset += gy;
        gz_offset += gz;

        delay(10);  // Small delay between readings
    }

    // Compute average offset
    gx_offset /= 200;
    gy_offset /= 200;
    gz_offset /= 200;

    // Set offsets
    gyro.setXGyroOffset(-gx_offset);
    gyro.setYGyroOffset(-gy_offset);
    gyro.setZGyroOffset(-gz_offset);

    Serial.println("Calibration complete.");
}

void loop() {
    // Read data from first gyro
    gyro1.getMotion6(&gyroData[0][0], &gyroData[0][1], &gyroData[0][2], &gyroData[0][3], &gyroData[0][4], &gyroData[0][5]);

    // Read data from second gyro
    gyro2.getMotion6(&gyroData[1][0], &gyroData[1][1], &gyroData[1][2], &gyroData[1][3], &gyroData[1][4], &gyroData[1][5]);

    // Print and send data
    sendData();

    Serial.println("------------------------");
    delay(1000);  // Wait 1 second before next reading
}

// Function to send data via Bluetooth
void sendData() {
    for (int i = 0; i < 2; i++) {  // Loop through both gyros
        Serial.print("Gyro"); Serial.print(i + 1); Serial.print(": ");
        BTSerial.print("Gyro"); BTSerial.print(i + 1); BTSerial.print(": ");

        for (int j = 0; j < 6; j++) {  // Loop through 6 data points
            Serial.print(gyroData[i][j]); Serial.print("\t");
            BTSerial.print(gyroData[i][j]); BTSerial.print(",");
        }
        Serial.println();
        BTSerial.println(); // Send newline over Bluetooth
    }
}
