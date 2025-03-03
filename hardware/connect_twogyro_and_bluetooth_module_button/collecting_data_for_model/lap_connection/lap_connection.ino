#include <SoftwareSerial.h>

SoftwareSerial BTSerial(2, 3);  // Bluetooth TX (D3) & RX (D2)

void setup() {
    Serial.begin(115200);  // Serial communication with the computer
    BTSerial.begin(9600);  // Bluetooth communication with the first board
}

void loop() {
    // Forward data from Bluetooth to Serial
    if (BTSerial.available()) {
        char data = BTSerial.read();
        Serial.print(data);
    }

    // Forward data from Serial to Bluetooth (if needed)
    if (Serial.available()) {
        char data = Serial.read();
        BTSerial.print(data);
    }
}