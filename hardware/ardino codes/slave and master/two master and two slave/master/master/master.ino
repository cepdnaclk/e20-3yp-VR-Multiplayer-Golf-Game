#include <SoftwareSerial.h>

SoftwareSerial btMaster1(10, 11);  // Master 1 (paired with Slave 1)
SoftwareSerial btMaster2(8, 9);  // Master 2 (paired with Slave 2)

String msg1 = "";
String msg2 = "";

void setup() {
    Serial.begin(9600);
    btMaster1.begin(9600);
    btMaster2.begin(9600);
}

void loop() {
    // Read from both modules without blocking
    if (btMaster1.available()) {
        char c = btMaster1.read();
        if (c == '\n') {
            printParallel();
            msg1 = "";  // Clear for the next message
        } else {
            msg1 += c;
        }
    }

    if (btMaster2.available()) {
        char c = btMaster2.read();
        if (c == '\n') {
            printParallel();
            msg2 = "";  // Clear for the next message
        } else {
            msg2 += c;
        }
    }
}

// Function to print messages in parallel
void printParallel() {
    Serial.print("Slave 1: ");
    Serial.print(msg1);
    Serial.print(" | Slave 2: ");
    Serial.println(msg2);
}
