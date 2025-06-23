#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <BluetoothSerial.h>

Adafruit_MPU6050 mpu;
BluetoothSerial SerialBT;

const int buttonPins[] = {32, 33, 25, 26, 27, 14};
bool buttonStates[6];

void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32_MPU6050"); // Bluetooth name
  Wire.begin(21, 22); // SDA, SCL

  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) delay(10);
  }

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  for (int i = 0; i < 6; i++) {
    pinMode(buttonPins[i], INPUT_PULLUP);
  }

  Serial.println("Setup done.");
  SerialBT.println("Bluetooth started.");
}

void loop() {
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  for (int i = 0; i < 6; i++) {
    buttonStates[i] = !digitalRead(buttonPins[i]); // Active LOW
  }

  String data = "Accel: ";
  if (buttonStates[5]) {  // If button 6 is pressed
    data += String(a.acceleration.x, 2) + ", ";
    data += String(a.acceleration.y, 2) + ", ";
    data += String(a.acceleration.z, 2) + " | Gyro: ";
    data += String(g.gyro.x, 2) + ", ";
    data += String(g.gyro.y, 2) + ", ";
    data += String(g.gyro.z, 2);
  } else {
    data += "0.00, 0.00, 0.00 | Gyro: 0.00, 0.00, 0.00";
  }

  data += " | Buttons: ";

  bool anyPressed = false;
  for (int i = 0; i < 6; i++) {
    if (buttonStates[i]) {
      data += String(i + 1);
      data += " ";
      anyPressed = true;
    }
  }

  if (!anyPressed) {
    data += "None";
  }

  Serial.println(data);
  SerialBT.println(data);

  delay(200);
}


