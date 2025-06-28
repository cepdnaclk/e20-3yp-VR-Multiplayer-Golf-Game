#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

Adafruit_MPU6050 mpu;

int buttonPins[6] = {14, 27, 26, 25, 33, 32}; // Adjust these GPIOs if needed

void setup() {
  Serial.begin(115200);
  delay(1000); // Give time for serial monitor

  // Start I2C
  Wire.begin(); // SDA = 21, SCL = 22 for ESP32

  // Initialize MPU6050
  if (!mpu.begin()) {
    Serial.println("MPU6050 not found. Check connections.");
    while (1) delay(10);
  }
  Serial.println("MPU6050 ready!");

  // Configure MPU settings if needed
  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  // Set up push buttons
  for (int i = 0; i < 6; i++) {
    pinMode(buttonPins[i], INPUT_PULLUP);
  }
}

void loop() {
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  // Print gyroscope values
  Serial.print("Gyro X: "); Serial.print(g.gyro.x, 2);
  Serial.print(" | Y: "); Serial.print(g.gyro.y, 2);
  Serial.print(" | Z: "); Serial.print(g.gyro.z, 2);

  // Print button states
  for (int i = 0; i < 6; i++) {
    int state = digitalRead(buttonPins[i]);
    Serial.print(" | B"); Serial.print(i + 1); Serial.print(": ");
    Serial.print(state == LOW ? "Pressed" : "Released");
  }

  Serial.println();
  delay(200);
}
