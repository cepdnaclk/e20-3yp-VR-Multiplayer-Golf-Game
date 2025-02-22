#include <SoftwareSerial.h>

SoftwareSerial BTSerial(2, 3); // TX=2, RX=3 (Bluetooth module)

void setup() {
    Serial.begin(9600);
    BTSerial.begin(9600);  // Ensure this baud rate matches your Bluetooth module
}

void loop() {
    BTSerial.println("I'm slave 1");  // Change this to "I'm slave 2" for Slave 2
    delay(1000);  // Send message every second
}
