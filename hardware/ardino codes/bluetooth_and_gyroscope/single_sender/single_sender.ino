#include <SoftwareSerial.h>

SoftwareSerial BTSerial(10, 11); // RX, TX

void setup() {
    Serial.begin(9600);
    BTSerial.begin(9600);
}

void loop() {
    BTSerial.println("Hello from Sender!");
    Serial.println("Sent: Hello from Sender!");
    delay(2000); // Send message every 2 seconds
}
