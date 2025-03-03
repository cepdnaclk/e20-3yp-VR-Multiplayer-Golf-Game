#include "Wire.h"
#include "MPU6050.h"
#include <SoftwareSerial.h>

SoftwareSerial BTSerial(2, 3);  // Bluetooth TX (D3) & RX (D2)

MPU6050 gyro1(0x68);  // First MPU6050 (AD0 → GND)
MPU6050 gyro2(0x69);  // Second MPU6050 (AD0 → VCC)

int16_t gyroData[2][6];  // 2D array to store sensor data
const int buttonPin = 4;  // Button connected to D4
int buttonState = 0;      // Variable to store button state

void setup() {
    Serial.begin(115200);
    BTSerial.begin(9600);
    Wire.begin(); 

    pinMode(buttonPin, INPUT_PULLUP);  // Use INPUT_PULLUP instead of INPUT_PULLDOWN

    Serial.println("Initializing Gyroscopes...");

    gyro1.initialize();
    if (!gyro1.testConnection()) Serial.println("Gyro1 (0x68) not responding!");
    else {
        Serial.println("Gyro1 connected.");
        calibrateMPU6050(gyro1);
    }

    gyro2.initialize();
    if (!gyro2.testConnection()) Serial.println("Gyro2 (0x69) not responding!");
    else {
        Serial.println("Gyro2 connected.");
        calibrateMPU6050(gyro2);
    }
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
    // Read data from first gyro
    gyro1.getMotion6(&gyroData[0][0], &gyroData[0][1], &gyroData[0][2], &gyroData[0][3], &gyroData[0][4], &gyroData[0][5]);

    // Read data from second gyro
    gyro2.getMotion6(&gyroData[1][0], &gyroData[1][1], &gyroData[1][2], &gyroData[1][3], &gyroData[1][4], &gyroData[1][5]);

    // Read button state (LOW when pressed, HIGH when released)
    buttonState = digitalRead(buttonPin);

    // Print and send data
    sendData();

    Serial.println("------------------------");
    delay(500);
}

void sendData() {
    for (int i = 0; i < 2; i++) { 
        Serial.print("Gyro"); Serial.print(i + 1); Serial.print(": ");
        BTSerial.print("Gyro"); BTSerial.print(i + 1); BTSerial.print(": ");

        for (int j = 0; j < 6; j++) {  
            Serial.print(gyroData[i][j]); Serial.print("\t");
            BTSerial.print(gyroData[i][j]); BTSerial.print(",");
        }
        Serial.println();
        BTSerial.println();
    }

    // Send button state over Bluetooth
    Serial.print("Button State: ");
    Serial.println(buttonState == LOW ? "PRESSED" : "RELEASED");
    BTSerial.print("Button State: ");
    BTSerial.println(buttonState == LOW ? "PRESSED" : "RELEASED");
}
