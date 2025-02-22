#include <SoftwareSerial.h>

SoftwareSerial BT(8,9);  // TX=2, RX=3

void setup() {
    Serial.begin(9600);
    BT.begin(9600);
}

void loop() {
    if (BT.available()) {
        Serial.write(BT.read());  // Print received message to Serial Monitor
    }
}
