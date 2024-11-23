#include <Stepper.h>

int val = 0;
int rpm = 200;
const int stepsPerRevolution = 200;

int buttonPin = 2;
int buttonState = 0;
int poteValue;


Stepper myStepper(stepsPerRevolution, 8, 9, 10, 11);

void turnOn() {
  Serial.println("Motor ON");
  digitalWrite(8, HIGH);
  digitalWrite(9, LOW);
  digitalWrite(10, HIGH);
  digitalWrite(11, LOW);
}

void turnOff() {
  Serial.println("Motor OFF");
  digitalWrite(8, LOW);
  digitalWrite(9, LOW);
  digitalWrite(10, LOW);
  digitalWrite(11, LOW);
}

void setup() {
  Serial.begin(9600);
  pinMode(buttonPin, INPUT);
}

void loop() {
  buttonState = digitalRead(buttonPin);
  
  while (buttonState == HIGH) {
    poteValue= analogRead(A0); //goes from 0 to 1023
    rpm = map(poteValue, 0, 1023, 0, 300);
    Serial.print(rpm);
    
    myStepper.setSpeed(rpm);
    myStepper.step(stepsPerRevolution);
    buttonState = digitalRead(buttonPin);
  }
  turnOn();
//  val = Serial.read();
//  if (val == '0') {
//    turnOff();
//  }
//  if (val == '1') {
//    turnOn();
//  }
//  if (val == '2') {
//    turnOn();
//    while (val != '0') {
//      myStepper.setSpeed(rpm);
//      myStepper.step(stepsPerRevolution);
//      val = Serial.read();
//    }
//    turnOff();
}
