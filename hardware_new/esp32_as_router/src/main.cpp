#include <WiFi.h>
#include <WiFiUdp.h>
#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

Adafruit_MPU6050 mpu;
WiFiUDP udp;

const char* ssid = "ESP32_AP";
const char* password = "12345678";

// Port to send to (same as Unity listener)
const int udpPort = 4210;

// Replace with phone's IP after connecting to ESP32 AP
const char* clientIP = "192.168.4.2";

int buttonPins[6] = {14, 27, 26, 25, 33, 32};

void setup() {
  Serial.begin(115200);
  delay(1000);

  // Start Wi-Fi Access Point
  WiFi.softAP(ssid, password);
  Serial.println("ESP32 AP Started. IP:");
  Serial.println(WiFi.softAPIP()); // Usually 192.168.4.1

  Wire.begin();
  if (!mpu.begin()) {
    Serial.println("MPU6050 not found!");
    while (1);
  }

  for (int i = 0; i < 6; i++) {
    pinMode(buttonPins[i], INPUT_PULLUP);
  }
}

void loop() {
  bool b6 = digitalRead(buttonPins[5]) == LOW;

  String data;
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  if (b6) {
    data = String(a.acceleration.x, 2) + "," + String(a.acceleration.y, 2) + "," + String(a.acceleration.z, 2) + ",";
    data += String(g.gyro.x, 2) + "," + String(g.gyro.y, 2) + "," + String(g.gyro.z, 2);
  } else {
    data = "0,0,0,0,0,0";
  }

  for (int i = 0; i < 6; i++) {
    int state = digitalRead(buttonPins[i]) == LOW ? 1 : 0;
    data += "," + String(state);
  }

  udp.beginPacket(clientIP, udpPort);
  udp.print(data);
  udp.endPacket();

  Serial.println(data);
  delay(30);
}