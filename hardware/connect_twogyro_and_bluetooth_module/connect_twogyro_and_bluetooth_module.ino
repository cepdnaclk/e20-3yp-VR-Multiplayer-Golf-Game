#include <Wire.h>
#include <MPU6050.h>

MPU6050 gyro1(0x68);  // First MPU6050 (AD0 → GND)
MPU6050 gyro2(0x69);  // Second MPU6050 (AD0 → VCC)

void setup() {
    Serial.begin(115200);
    Wire.begin();  // Initialize I2C as Master

    Serial.println("Initializing Gyroscopes...");

    gyro1.initialize();
    if (!gyro1.testConnection()) Serial.println("Gyro1 not responding!"); else Serial.println("Gyro1 connected.");

    gyro2.initialize();
    if (!gyro2.testConnection()) Serial.println("Gyro2 not responding!"); else Serial.println("Gyro2 connected.");
}

void loop() {
    int16_t ax, ay, az, gx, gy, gz;

    // Read data from first gyro
    gyro1.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
    Serial.print("Gyro1: X="); Serial.print(gx); Serial.print(" Y="); Serial.print(gy); Serial.print(" Z="); Serial.println(gz);

    // Read data from second gyro
    gyro2.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
    Serial.print("Gyro2: X="); Serial.print(gx); Serial.print(" Y="); Serial.print(gy); Serial.print(" Z="); Serial.println(gz);

    // Request data from second Arduino (Slave)
    Wire.requestFrom(8, 6); // Request 6 bytes (X, Y, Z gyro)
    if (Wire.available() == 6) {
        gx = Wire.read() << 8 | Wire.read();
        gy = Wire.read() << 8 | Wire.read();
        gz = Wire.read() << 8 | Wire.read();
        
        Serial.print("Gyro3: X="); Serial.print(gx);
        Serial.print(" Y="); Serial.print(gy);
        Serial.print(" Z="); Serial.println(gz);
    }

    Serial.println("------------------------");
    delay(1000);
}
