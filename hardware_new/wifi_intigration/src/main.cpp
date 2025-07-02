#include <WiFi.h>
#include <WiFiUdp.h>
#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

Adafruit_MPU6050 mpu;
WiFiUDP udp;

// Wi-Fi credentials
const char* ssid = "Rashmika";
const char* password = "rashmika1";

// IP and port of the mobile device running Unity
const char* udpAddress = "192.168.208.69"; // <-- Replace with your phone's IP
const int udpPort = 4210;

int buttonPins[6] = {14, 27, 26, 25, 33, 32}; // Last one is B6

void setup() {
  Serial.begin(115200);
  delay(1000);

  // Connect to Wi-Fi
  Serial.print("Connecting to Wi-Fi");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to Wi-Fi. IP: ");
  Serial.println(WiFi.localIP());

  // Start I2C and MPU6050
  Wire.begin();
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050");
    while (1) delay(10);
  }
  Serial.println("MPU6050 connected!");

  // Configure MPU settings
  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  // Init buttons
  for (int i = 0; i < 6; i++) {
    pinMode(buttonPins[i], INPUT_PULLUP);
  }
}

void loop() {
  bool b6Pressed = digitalRead(buttonPins[5]) == LOW;

  String data;

  // Handle gyro data
  if (b6Pressed) {
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);
    data = String(g.gyro.x, 2) + "," + String(g.gyro.y, 2) + "," + String(g.gyro.z, 2);
  } else {
    data = "0,0,0"; // Gyro is zeroed
  }

  // Handle button states: convert LOW to 1 (pressed), HIGH to 0 (not pressed)
  for (int i = 0; i < 6; i++) {
    int state = digitalRead(buttonPins[i]) == LOW ? 1 : 0;
    data += "," + String(state);
  }

  // Send via UDP
  udp.beginPacket(udpAddress, udpPort);
  udp.print(data);
  udp.endPacket();

  Serial.println(data); // Debug
  delay(30); // ~33Hz
}
