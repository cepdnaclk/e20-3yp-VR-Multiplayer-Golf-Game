#include "Wire.h"
#include "MPU6050.h"
#include <SoftwareSerial.h>

SoftwareSerial BTSerial(2, 3);  // Bluetooth TX (D3) & RX (D2)

MPU6050 gyro(0x68);  // Single MPU6050 (AD0 → GND)

int16_t gyroData[6];  // Array to store sensor data
bool collectingData = false;  // Flag to track data collection state

// Button pins
const int startButton = 5;  // Start collecting data
const int stopButton = 6;   // Stop collecting data

void setup() {
    Serial.begin(115200);
    BTSerial.begin(9600);
    Wire.begin(); 

    // Initialize buttons as INPUT_PULLUP
    pinMode(startButton, INPUT_PULLUP);
    pinMode(stopButton, INPUT_PULLUP);

    Serial.println("Initializing Gyroscope...");

    gyro.initialize();
    if (!gyro.testConnection()) Serial.println("Gyro (0x68) not responding!");
    else {
        Serial.println("Gyro connected.");
        calibrateMPU6050(gyro);
    }

    // Prevent overflow by setting gyro sensitivity to ±2000°/s
    gyro.setFullScaleGyroRange(MPU6050_GYRO_FS_2000);
}

void calibrateMPU6050(MPU6050 &gyro) {
    Serial.println("Calibrating...");
    int32_t gx_offset = 0, gy_offset = 0, gz_offset = 0;

    for (int i = 0; i < 200; i++) {
        int16_t ax, ay, az, gx, gy, gz;
        gyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

        gx_offset += gx;
        gy_offset += gy;
        gz_offset += gz;

        delay(10);
    }

    gx_offset /= 200;
    gy_offset /= 200;
    gz_offset /= 200;

    gyro.setXGyroOffset(-gx_offset);
    gyro.setYGyroOffset(-gy_offset);
    gyro.setZGyroOffset(-gz_offset);

    Serial.println("Calibration complete.");
}

void loop() {
    // Debounce buttons by checking if they stay pressed for 50ms
    if (digitalRead(startButton) == LOW) {
        delay(50);  
        if (digitalRead(startButton) == LOW) {  
            collectingData = true;
            Serial.println("Started data collection.");
        }
    }

    if (digitalRead(stopButton) == LOW) {
        delay(50);  
        if (digitalRead(stopButton) == LOW) {  
            collectingData = false;
            Serial.println("Stopped data collection.");
        }
    }

    if (collectingData) {
        // Read data from gyro
        gyro.getMotion6(&gyroData[0], &gyroData[1], &gyroData[2], &gyroData[3], &gyroData[4], &gyroData[5]);

        // Print and send only gyro data
        sendData();
    }

    delay(10);  // Reduced delay for faster response
}

void sendData() {
    Serial.print("Gyro: ");
    BTSerial.print("Gyro: ");

    for (int j = 0; j < 6; j++) {  
        Serial.print(gyroData[j]); Serial.print("\t");
        BTSerial.print(gyroData[j]); BTSerial.print(",");
    }
    Serial.println();
    BTSerial.println();
}
