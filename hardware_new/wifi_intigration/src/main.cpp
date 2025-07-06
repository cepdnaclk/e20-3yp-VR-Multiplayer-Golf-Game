#include <WiFi.h>
#include <WiFiUdp.h>
#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

Adafruit_MPU6050 mpu;
WiFiUDP udp;

// Wi-Fi credentials
const char* ssid = "Rashmika";
const char* password = "rashmika";

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

  // Read sensor data
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  // Only send real gyro data if B6 is pressed, otherwise send zeros
  if (b6Pressed) {
    data = String(a.acceleration.x, 2) + "," + String(a.acceleration.y, 2) + "," + String(a.acceleration.z, 2) + ",";
    data += String(g.gyro.x, 2) + "," + String(g.gyro.y, 2) + "," + String(g.gyro.z, 2);
  } else {
    data = "0,0,0,0,0,0"; // Zeroed acceleration and gyro
  }

  // Append button states
  for (int i = 0; i < 6; i++) {
    int state = digitalRead(buttonPins[i]) == LOW ? 1 : 0;
    data += "," + String(state);
  }

  // Send via UDP
  udp.beginPacket(udpAddress, udpPort);
  udp.print(data);
  udp.endPacket();

  Serial.println(data); // Debug print
  delay(30); // ~33Hz
}