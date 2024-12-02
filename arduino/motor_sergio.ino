//Simpler version of the arduino_stepper_motor, in the commented area there's the serial functions 0, 1 & 2
//to turnOn (lock), turnOff and spin indefinitely until 0 is sent, respectively
//Added code to implement a push-button to activate the motor and a potentiometer 100K to vary the rpm.
//Also added potentiometer 1K to the 12V supply for control.
//Added booting function to let the motor start slowly pulling the pallet until it reaches the wanted speed.
#include <Stepper.h>

int val = 0;
int rpm = 300;
const int stepsPerRevolution = 200;

int buttonPin = 2;
int buttonState = 0;
int poteValue;

int enable_arr = 0;


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

void arranque() {
  for (int i=150; i<rpm; i+=1) {
      myStepper.setSpeed(i);
      myStepper.step(10);
  }
}

void setup() {
  Serial.begin(9600);
  pinMode(buttonPin, INPUT);
}

void loop() {
  enable_arr = 1;
  buttonState = digitalRead(buttonPin);
  
  while (buttonState == HIGH) {
    poteValue= analogRead(A0); //goes from 0 to 1023
    rpm = map(poteValue, 0, 1023, 0, 300);
    Serial.print(rpm);

    //Arranque
    if (enable_arr == 1) {
      arranque();
    }
    enable_arr = 0;
    //Velocidad constante
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
