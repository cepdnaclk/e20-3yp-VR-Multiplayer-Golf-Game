#define ledPin 12
#define buttonPin 8

int data = 0;

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT_PULLUP); // Internal pull-up resistor
  digitalWrite(ledPin, LOW);
  Serial.begin(9600); // Default baud rate for HC-05
}

void loop() {
  if (Serial.available() > 0) { // Check if data is received
    data = Serial.read(); // Read incoming data

    if (data == '0') {
      digitalWrite(ledPin, LOW);
      Serial.println("LED: OFF");
    } 
    else if (data == '1') {
      digitalWrite(ledPin, HIGH);
      Serial.println("LED: ON");
    }
  }

  // Read button state and send status over Bluetooth
  int buttonState = digitalRead(buttonPin);
  Serial.println(buttonState); // Send button state to Bluetooth
  delay(500); // Prevent flooding the serial monitor
}
