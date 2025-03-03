#include <SoftwareSerial.h>

SoftwareSerial BT(2, 3);  // TX=2, RX=3

void setup() {
    Serial.begin(9600);
    BT.begin(9600);  // Ensure baud rate matches your module
}

void loop() {
    BT.println("Hello, I am slave");
    delay(1000);  // Send message every 1 second
}
