/*
 Stepper Motor Control - one revolution

 This program drives a unipolar or bipolar stepper motor.
 The motor is attached to digital pins 8 - 11 of the Arduino.

 The motor should revolve one revolution in one direction, then
 one revolution in the other direction.


 Created 11 Mar. 2007
 Modified 30 Nov. 2009
 by Tom Igoe

 */

#include <Stepper.h>

const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution
// for your motor

// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, 8, 9, 10, 11);
void avant(){
  Serial.println("Activating energy");
 pinMode(12, OUTPUT);
  digitalWrite(12, HIGH);
digitalWrite(8, HIGH);
digitalWrite(9, LOW);
digitalWrite(10, HIGH);
digitalWrite(11, LOW);
Serial.println("Beggining in 1");
delay(1000);
 for (int i=15; i <= 500; i++){
      Serial.println(i);
      myStepper.setSpeed(i);
     myStepper.step(15);}
 
for (int i=500; i >= 15; i--){
      Serial.println(i);
      myStepper.setSpeed(i);
     myStepper.step(15);}
Serial.println("Desactivating stepper motor in 3");
delay(1000);
Serial.println("Desactivating stepper motor in 2");
delay(1000);
Serial.println("Desactivating stepper motor in 1");
delay(1000);
Serial.println("Stepper motor desactivated");
digitalWrite(8, LOW);
digitalWrite(9, LOW);
digitalWrite(10, LOW);
digitalWrite(11, LOW);
Serial.println("Desactivating energy 3");
delay(1000);
Serial.println("Desactivating energy 2");
delay(1000);
Serial.println("Desactivating energy 1");
delay(1000);
Serial.print("Energy desactivated");
  digitalWrite(12, LOW);
}
void arriere(){
  Serial.println("Activating energy");
 pinMode(12, OUTPUT);
  digitalWrite(12, HIGH);
Serial.println("Activating stepper motor in 3");
delay(1000);
Serial.println("Activating stepper motor in 2");
delay(1000);
Serial.println("Activating stepper motor in 1");
delay(1000);
Serial.println("Stepper motor activated");
    digitalWrite(8, HIGH);
digitalWrite(9, LOW);
digitalWrite(10, HIGH);
digitalWrite(11, LOW);
Serial.println("Beggining in 3");
delay(1000);
Serial.println("Beggining in 2");
delay(1000);
Serial.println("Beggining in 1");
delay(1000);
 for (int i=100; i <= 220; i++){
      Serial.println(i);
      myStepper.setSpeed(i);
     myStepper.step(-15);}
 
myStepper.setSpeed(220);
myStepper.step(-3000);
for (int i=220; i >= 100; i--){
      Serial.println(i);
      myStepper.setSpeed(i);
     myStepper.step(-15);}
Serial.println("Desactivating stepper motor in 3");
delay(1000);
Serial.println("Desactivating stepper motor in 2");
delay(1000);
Serial.println("Desactivating stepper motor in 1");
delay(1000);
Serial.println("Stepper motor desactivated");
digitalWrite(8, LOW);
digitalWrite(9, LOW);
digitalWrite(10, LOW);
digitalWrite(11, LOW);
Serial.println("Desactivating energy 3");
delay(1000);
Serial.println("Desactivating energy 2");
delay(1000);
Serial.println("Desactivating energy 1");
delay(1000);
Serial.print("Energy desactivated");
  digitalWrite(12, LOW);
}
void setup() {
Serial.begin(9600);
  }
void loop() {
  avant();
for (int i=30; i >= 0; i--){
      Serial.println(i);
      delay(1000);}
  arriere();
  for (int i=30; i >= 0; i--){
      Serial.println(i);
      delay(1000);}
  // step one revolution  in one direction:
}
