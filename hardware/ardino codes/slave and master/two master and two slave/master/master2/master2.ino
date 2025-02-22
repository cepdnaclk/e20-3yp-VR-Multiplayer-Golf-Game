#include <SoftwareSerial.h>

#define BT_TX 2
#define BT_RX 3

SoftwareSerial BTSerial(BT_TX, BT_RX);

String slave1 = "0022,03,018C0E";  // Replace with your actual Slave 1 address
String slave2 = "0022,09,011A0E";  // Replace with your actual Slave 2 address

void setup() {
    Serial.begin(9600);
    BTSerial.begin(9600);
    Serial.println("Master Bluetooth Ready...");
}

void loop() {
    connectToSlave(slave1);
    delay(2000); // Give time to establish connection
    receiveData();
    delay(5000); // Stay connected for 5 sec

    connectToSlave(slave2);
    delay(2000);
    receiveData();
    delay(5000);
}

void connectToSlave(String address) {
    Serial.println("Connecting to: " + address);
    BTSerial.println("AT+DISC");  // Disconnect any existing connection
    delay(1000);
    BTSerial.println("AT+LINK=" + address);
    delay(2000);  // Wait for connection
    Serial.println("Connected to: " + address);
}

void receiveData() {
    Serial.println("Waiting for data...");
    unsigned long startTime = millis();
    
    while (millis() - startTime < 4000) {  // Wait for 4 seconds to receive data
        if (BTSerial.available()) {
            String receivedData = "";
            while (BTSerial.available()) {
                char c = BTSerial.read();
                receivedData += c;
            }
            receivedData.trim();
            Serial.println("Master received: " + receivedData);
            return;
        }
    }
    Serial.println("No data received.");
}
