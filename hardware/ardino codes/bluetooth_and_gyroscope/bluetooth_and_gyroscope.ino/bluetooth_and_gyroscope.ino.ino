#include <Wire.h>
#include <MPU6050.h>
#include <SoftwareSerial.h>

MPU6050 mpu;
SoftwareSerial BTSerial(10, 11);  // RX, TX for Bluetooth

void setup() {
    Serial.begin(115200);
    BTSerial.begin(9600);
    Wire.begin();
    mpu.initialize();

    if (mpu.testConnection()) {
        Serial.println("MPU6050 connected");
        BTSerial.println("MPU6050 connected");
    } else {
        Serial.println("MPU6050 connection failed");
        BTSerial.println("MPU6050 connection failed");
    }
}

void loop() {
    int16_t ax, ay, az, gx, gy, gz;
    mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

    // Format data
    String data = "Accel: " + String(ax) + "," + String(ay) + "," + String(az) +
                  " Gyro: " + String(gx) + "," + String(gy) + "," + String(gz);

    Serial.println(data);
    BTSerial.println(data);  // Send data via Bluetooth

    delay(1000);
}
