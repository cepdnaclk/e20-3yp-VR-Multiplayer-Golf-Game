#include "Wire.h"
#include "MPU6050.h"
#include <SoftwareSerial.h>

SoftwareSerial BTSerial(2, 3);  // Bluetooth TX (D3) & RX (D2)

MPU6050 gyro(0x68);  // Single MPU6050

int16_t gyroData[6] = {0, 0, 0, 0, 0, 0};  // Store sensor readings
int16_t accelOffsets[3] = {0, 0, 0};       // Store accelerometer offsets
int16_t gyroOffsets[3] = {0, 0, 0};        // Store gyroscope offsets

// Button pins
const int resetButton = 4;
const int startButton = 5;
const int stopButton = 6;

bool collectingData = false; // Flag to control data collection

void setup() {
    Serial.begin(115200);
    BTSerial.begin(9600);
    Wire.begin(); 

    pinMode(resetButton, INPUT_PULLUP);
    pinMode(startButton, INPUT_PULLUP);
    pinMode(stopButton, INPUT_PULLUP);

    Serial.println("Initializing Gyroscope...");

    gyro.initialize();
    if (!gyro.testConnection()) Serial.println("Gyro (0x68) not responding!");
    else {
        Serial.println("Gyro connected.");
        calibrateMPU6050();
    } 
}

void calibrateMPU6050() {
    Serial.println("Calibrating...");
    int32_t ax_offset = 0, ay_offset = 0, az_offset = 0;
    int32_t gx_offset = 0, gy_offset = 0, gz_offset = 0;

    for (int i = 0; i < 200; i++) {
        int16_t ax, ay, az, gx, gy, gz;
        gyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

        ax_offset += ax;
        ay_offset += ay;
        az_offset += az;
        gx_offset += gx;
        gy_offset += gy;
        gz_offset += gz;

        delay(10);
    }

    accelOffsets[0] = ax_offset / 200;
    accelOffsets[1] = ay_offset / 200;
    accelOffsets[2] = az_offset / 200;
    gyroOffsets[0] = gx_offset / 200;
    gyroOffsets[1] = gy_offset / 200;
    gyroOffsets[2] = gz_offset / 200;

    Serial.println("Calibration complete.");
}

// Reset ALL sensor values to zero
void resetAllValues() {
    Serial.println("Resetting values...");

    int32_t ax_offset = 0, ay_offset = 0, az_offset = 0;
    int32_t gx_offset = 0, gy_offset = 0, gz_offset = 0;

    // Take multiple readings to average out noise
    for (int i = 0; i < 100; i++) {
        int16_t ax, ay, az, gx, gy, gz;
        gyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

        ax_offset += ax;
        ay_offset += ay;
        az_offset += az;
        gx_offset += gx;
        gy_offset += gy;
        gz_offset += gz;

        delay(10); // Small delay for stable readings
    }

    // Compute new offsets
    accelOffsets[0] = ax_offset / 100;
    accelOffsets[1] = ay_offset / 100;
    accelOffsets[2] = az_offset / 100;
    gyroOffsets[0] = gx_offset / 100;
    gyroOffsets[1] = gy_offset / 100;
    gyroOffsets[2] = gz_offset / 100;

    Serial.println("Offsets updated.");
}


void loop() {
    // Read button states
    bool resetPressed = digitalRead(resetButton) == LOW;
    bool startPressed = digitalRead(startButton) == LOW;
    bool stopPressed  = digitalRead(stopButton) == LOW;

    if (resetPressed) {
        resetAllValues();
    }
    
    if (startPressed) {
        collectingData = true;
        Serial.println("Data collection STARTED.");
    }

    if (stopPressed) {
        collectingData = false;
        Serial.println("Data collection STOPPED.");
    }

    if (collectingData) {
        readSensorData();
        sendData();
    }

    delay(50);
}

// Reads accelerometer & gyroscope data and applies offset correction
void readSensorData() {
    gyro.getMotion6(&gyroData[0], &gyroData[1], &gyroData[2], &gyroData[3], &gyroData[4], &gyroData[5]);

    // Apply offset correction for accelerometer
    gyroData[0] -= accelOffsets[0];
    gyroData[1] -= accelOffsets[1];
    gyroData[2] -= accelOffsets[2];

    // Apply offset correction for gyroscope
    gyroData[3] -= gyroOffsets[0];
    gyroData[4] -= gyroOffsets[1];
    gyroData[5] -= gyroOffsets[2];
}

// Sends data via Serial and Bluetooth
void sendData() {
    Serial.print("Gyro: ");
    BTSerial.print("Gyro: ");

    for (int i = 0; i < 6; i++) {  
        Serial.print(gyroData[i]); Serial.print("\t");
        BTSerial.print(gyroData[i]); BTSerial.print(",");
    }
    
    Serial.println();
    BTSerial.println();
}
