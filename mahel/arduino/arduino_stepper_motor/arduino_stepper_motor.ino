/*
 Stepper Motor Control for INT project
 Based on https://docs.arduino.cc/learn/electronics/stepper-motors/

 */
#include <Stepper.h>
int val=0;
const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution
//const float 3.0; //Cm for 1 revolution
// for your motor

// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, 8, 9, 10, 11);
void allumer(){
  Serial.println("Stepper motor activated");
  digitalWrite(8, HIGH);
  digitalWrite(9, LOW);
  digitalWrite(10, HIGH);
  digitalWrite(11, LOW);
}
void eteindre(){
 Serial.println("Stepper motor deactivated");
  digitalWrite(8, LOW);
  digitalWrite(9, LOW);
  digitalWrite(10, LOW);
  digitalWrite(11, LOW);
}

void setup() {
  Serial.begin(9600);
}

void loop() {
  val=Serial.read();
  if(val=='1'){
     allumer();
  }
  if(val=='v'){
    Serial.print("Speed (rpm): ");
     allumer();

  }
  if(val=='0'){
    eteindre();
  }
  if(val=='4'){
    allumer();
    myStepper.setSpeed(300);
    myStepper.step(350*5);
    eteindre();
  }
  if(val=='6'){
    allumer();
    myStepper.setSpeed(300);
    myStepper.step(-350*5);
    eteindre();
  }
}
