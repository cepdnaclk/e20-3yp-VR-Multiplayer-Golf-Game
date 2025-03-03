#include <SoftwareSerial.h>

#define BT_TX 2  // HC-05 TX → Arduino RX (Pin 2)
#define BT_RX 3  // HC-05 RX → Arduino TX (Pin 3)

SoftwareSerial BTSerial(BT_TX, BT_RX);

void setup() {
    Serial.begin(9600);
    BTSerial.begin(9600);
    Serial.println("Slave 1 Ready...");
}

void loop() {
    BTSerial.println("I am Slave 1");
    Serial.println("Sent: I am Slave 1");
    delay(3000);  // Send message every 3 seconds
}
