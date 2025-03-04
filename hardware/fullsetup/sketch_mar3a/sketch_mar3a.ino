#include "Wire.h"
#include "MPU6050.h"
#include <SoftwareSerial.h>

SoftwareSerial BTSerial(2, 3);  // Bluetooth TX (D3) & RX (D2)

// Define two MPU6050 sensors
MPU6050 gyro1(0x68);  // First MPU6050 (AD0 → GND)
MPU6050 gyro2(0x69);  // Second MPU6050 (AD0 → 5V)

int16_t gyroData1[6];  // Array to store data from first sensor
int16_t gyroData2[6];  // Array to store data from second sensor

// Define button pins (4-12)
const int buttons[] = {4, 5, 6, 7, 8, 9, 10, 11, 12};
const int numButtons = sizeof(buttons) / sizeof(buttons[0]);

void setup() {
    Serial.begin(115200);
    BTSerial.begin(9600);
    Wire.begin();

    // Initialize buttons as INPUT_PULLUP
    for (int i = 0; i < numButtons; i++) {
        pinMode(buttons[i], INPUT_PULLUP);
    }

    Serial.println("Initializing Gyroscopes...");

    gyro1.initialize();
    gyro2.initialize();

    if (!gyro1.testConnection()) Serial.println("Gyro1 (0x68) not responding!");
    else {
        Serial.println("Gyro1 connected.");
        calibrateMPU6050(gyro1);
    }

    if (!gyro2.testConnection()) Serial.println("Gyro2 (0x69) not responding!");
    else {
        Serial.println("Gyro2 connected.");
        calibrateMPU6050(gyro2);
    }

    // Set gyro sensitivity to ±2000°/s
    gyro1.setFullScaleGyroRange(MPU6050_GYRO_FS_2000);
    gyro2.setFullScaleGyroRange(MPU6050_GYRO_FS_2000);

    Serial.println("Started data collection.");
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
    // Read data from both gyros
    gyro1.getMotion6(&gyroData1[0], &gyroData1[1], &gyroData1[2], &gyroData1[3], &gyroData1[4], &gyroData1[5]);
    gyro2.getMotion6(&gyroData2[0], &gyroData2[1], &gyroData2[2], &gyroData2[3], &gyroData2[4], &gyroData2[5]);

    // Print and send data over Bluetooth
    sendData();

    delay(10);  // Reduce delay for faster response
}

void sendData() {
    Serial.print("Gyro1: ");
    BTSerial.print("Gyro1: ");

    for (int j = 0; j < 6; j++) {
        Serial.print(gyroData1[j]); Serial.print("\t");
        BTSerial.print(gyroData1[j]); BTSerial.print(",");
    }

    Serial.print(" | Gyro2: ");
    BTSerial.print(" | Gyro2: ");

    for (int j = 0; j < 6; j++) {
        Serial.print(gyroData2[j]); Serial.print("\t");
        BTSerial.print(gyroData2[j]); BTSerial.print(",");
    }

    Serial.print(" | Buttons: ");
    BTSerial.print(" | Buttons: ");

    // Read and print button states
    for (int i = 0; i < numButtons; i++) {
        int state = digitalRead(buttons[i]) == LOW ? 1 : 0;  // 1 = pressed, 0 = not pressed
        Serial.print("B"); Serial.print(buttons[i]); Serial.print(":"); Serial.print(state); Serial.print("\t");
        BTSerial.print("B"); BTSerial.print(buttons[i]); BTSerial.print(":"); BTSerial.print(state); BTSerial.print(",");
    }

    Serial.println();
    BTSerial.println();
}
