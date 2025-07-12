// #include <WiFi.h>
// #include <WiFiUdp.h>
// #include <Wire.h>
// #include <Adafruit_MPU6050.h>
// #include <Adafruit_Sensor.h>

// Adafruit_MPU6050 mpu;
// WiFiUDP udp;

// // Wi-Fi credentials
// const char* ssid = "Methpura";
// const char* password = "hj85kt22827";

// // IP and port of the mobile device running Unity
// const char* udpAddress = "192.168.8.186"; // <-- Replace with your phone's IP
// const int udpPort = 4210;

// int buttonPins[6] = {14, 27, 26, 25, 33, 32}; // Last one is B6

// void setup() {
//   Serial.begin(115200);
//   delay(1000);

//   // Connect to Wi-Fi
//   Serial.print("Connecting to Wi-Fi");
//   WiFi.begin(ssid, password);
//   while (WiFi.status() != WL_CONNECTED) {
//     delay(500);
//     Serial.print(".");
//   }
//   Serial.println("\nConnected to Wi-Fi. IP: ");
//   Serial.println(WiFi.localIP());

//   // Start I2C and MPU6050
//   Wire.begin();
//   if (!mpu.begin()) {
//     Serial.println("Failed to find MPU6050");
//     while (1) delay(10);
//   }
//   Serial.println("MPU6050 connected!");

//   // Configure MPU settings
//   mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
//   mpu.setGyroRange(MPU6050_RANGE_500_DEG);
//   mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

//   // Init buttons
//   for (int i = 0; i < 6; i++) {
//     pinMode(buttonPins[i], INPUT_PULLUP);
//   }
// }

// void loop() {
//   bool b6Pressed = digitalRead(buttonPins[5]) == LOW;

//   String data;

//   // Read sensor data
//   sensors_event_t a, g, temp;
//   mpu.getEvent(&a, &g, &temp);

//   // Only send real gyro data if B6 is pressed, otherwise send zeros
//   if (b6Pressed) {
//     data = String(a.acceleration.x, 2) + "," + String(a.acceleration.y, 2) + "," + String(a.acceleration.z, 2) + ",";
//     data += String(g.gyro.x, 2) + "," + String(g.gyro.y, 2) + "," + String(g.gyro.z, 2);
//   } else {
//     data = "0,0,0,0,0,0"; // Zeroed acceleration and gyro
//   }

//   // Append button states
//   for (int i = 0; i < 6; i++) {
//     int state = digitalRead(buttonPins[i]) == LOW ? 1 : 0;
//     data += "," + String(state);
//   }

//   // Send via UDP
//   udp.beginPacket(udpAddress, udpPort);
//   udp.print(data);
//   udp.endPacket();

//   Serial.println(data); // Debug print
//   delay(30); // ~33Hz
// }




/* second code*/




// #include <WiFi.h>
// #include <WiFiUdp.h>
// #include <Wire.h>
// #include <Adafruit_MPU6050.h>
// #include <Adafruit_Sensor.h>

// Adafruit_MPU6050 mpu;
// WiFiUDP udp;

// // Wi-Fi credentials
// const char* ssid = "MethpuraKP";
// const char* password = "123456789";

// // Static IP configuration
// IPAddress local_IP(192, 168, 108, 222);  // <-- Set a fixed IP
// IPAddress gateway(192, 168, 108, 1);
// IPAddress subnet(255, 255, 255, 0);

// int udpPort = 4210;
// IPAddress remoteIP;
// int remotePort;

// int buttonPins[6] = {14, 27, 26, 25, 33, 32}; // Last one is B6

// void setup() {
//   Serial.begin(115200);
//   delay(1000);

//   // Apply static IP BEFORE WiFi.begin()
//   if (!WiFi.config(local_IP, gateway, subnet)) {
//     Serial.println("Failed to configure static IP");
//   }

//   WiFi.begin(ssid, password);
//   while (WiFi.status() != WL_CONNECTED) {
//     delay(500);
//     Serial.print(".");
//   }
//   Serial.println("\nConnected. ESP32 IP: ");
//   Serial.println(WiFi.localIP());

//   Wire.begin();
//   if (!mpu.begin()) {
//     Serial.println("MPU6050 not found");
//     while (1) delay(10);
//   }

//   mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
//   mpu.setGyroRange(MPU6050_RANGE_500_DEG);
//   mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

//   for (int i = 0; i < 6; i++) {
//     pinMode(buttonPins[i], INPUT_PULLUP);
//   }

//   udp.begin(udpPort);
// }

// void loop() {
//   // Wait for Unity to send first packet
//   int packetSize = udp.parsePacket();
//   if (packetSize) {
//     remoteIP = udp.remoteIP();
//     remotePort = udp.remotePort();
//   }

//   if (remotePort == 0) return;  // Wait until Unity connects

//   bool b6Pressed = digitalRead(buttonPins[5]) == LOW;

//   String data;

//   sensors_event_t a, g, temp;
//   mpu.getEvent(&a, &g, &temp);

//   if (b6Pressed) {
//     data = String(a.acceleration.x, 2) + "," + String(a.acceleration.y, 2) + "," + String(a.acceleration.z, 2) + ",";
//     data += String(g.gyro.x, 2) + "," + String(g.gyro.y, 2) + "," + String(g.gyro.z, 2);
//   } else {
//     data = "0,0,0,0,0,0";
//   }

//   for (int i = 0; i < 6; i++) {
//     int state = digitalRead(buttonPins[i]) == LOW ? 1 : 0;
//     data += "," + String(state);
//   }

//   udp.beginPacket(remoteIP, remotePort);
//   udp.print(data);
//   udp.endPacket();

//   Serial.println(data);
//   delay(30);  // ~33Hz
// }




/* third code - this code generate another bit for clibrations.*/

// program eka ptan ganne double press eken passe, 500 ms press karddi, doouble press eken passe palaweni data set eka value 13ma send karnawa 13th bit eka 1 karala. ita passe aye eka 0 wenawa.

#include <WiFi.h>
#include <WiFiUdp.h>
#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

Adafruit_MPU6050 mpu;
WiFiUDP udp;

// Wi-Fi credentials
const char* ssid = "Methpura";
const char* password = "hj85kt22827";

// IP and port of the mobile device running Unity
const char* udpAddress = "192.168.8.186"; // <-- Replace with your Unity device IP
const int udpPort = 4210;

int buttonPins[6] = {14, 27, 26, 25, 33, 32}; // Button pin mapping

// State tracking
bool programStarted = false;         // Indicates whether double-press was successful
unsigned long firstPressTime = 0;    // For timing the first press
int pressCount = 0;                  // Count button 6 presses
bool calibrationSent = false;        // Sends calibration bit only once

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

  // Initialize I2C and MPU6050
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

  // Setup buttons
  for (int i = 0; i < 6; i++) {
    pinMode(buttonPins[i], INPUT_PULLUP);
  }

  Serial.println("Double-press Button 6 within 500ms to start...");
}

void loop() {
  static bool lastState = HIGH;
  bool currentState = digitalRead(buttonPins[5]); // Button 6

  if (!programStarted) {
    // Detect falling edge (button press)
    if (lastState == HIGH && currentState == LOW) {
      unsigned long now = millis();

      if (pressCount == 0) {
        firstPressTime = now;
        pressCount = 1;
      } else if (pressCount == 1 && (now - firstPressTime <= 500))
      { // press time check karanne methanin; 500 ms athlatha press karanna ona. nathnam aye state eka 0 wenawa press eke ilaga 500 ms athulatha. 
        programStarted = true;
        Serial.println("Double press detected. Program started!");
      }
      else
      {
        pressCount = 0; // Reset if delay too long
      }
    }

    // Reset if time expired without second press
    if (pressCount == 1 && (millis() - firstPressTime > 500)) {
      pressCount = 0;
    }

    lastState = currentState;
    delay(10); // debounce
    return;    // wait until program starts
  }

  // --- Main logic starts after calibration ---

  bool b6Pressed = (currentState == LOW);
  String data;

  // Read accelerometer and gyroscope
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  if (b6Pressed) {
    data = String(a.acceleration.x, 2) + "," +
           String(a.acceleration.y, 2) + "," +
           String(a.acceleration.z, 2) + "," +
           String(g.gyro.x, 2) + "," +
           String(g.gyro.y, 2) + "," +
           String(g.gyro.z, 2);
  } else {
    data = "0,0,0,0,0,0"; // Zero output when button not held
  }

  // Append button states (button 1–6)
  for (int i = 0; i < 6; i++) {
    int state = digitalRead(buttonPins[i]) == LOW ? 1 : 0;
    data += "," + String(state);
  }

  // Append calibration bit (13th bit): send '1' once after double press
  if (!calibrationSent) {
    data += ",1";
    calibrationSent = true; // only once
  } else {
    data += ",0";
  }

  // Send the data packet via UDP
  udp.beginPacket(udpAddress, udpPort);
  udp.print(data);
  udp.endPacket();

  Serial.println(data); // Optional debug output
  delay(30); // ~33 Hz
}
