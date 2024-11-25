/*
 Stepper Motor Control for INT project
 Based on https://docs.arduino.cc/learn/electronics/stepper-motors/

 */
#include <Stepper.h>
int val=0;
int rpm = 300;
const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution
const bool debugMode = false;
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
    int indexDec = 0, indexNumObtained=1;
    int numObtained[3];
    rpm = 0;
    while(val != ';' && val!=13 && val != ',' && val != '.'){
      val=Serial.read();
      if(val>='0' && val<'9'){
        numObtained[indexDec] = val-'0';
        indexDec++;

        if(debugMode){
          Serial.print("Num obtained: ");
          Serial.print(val-'0');

          Serial.println("Array: ");
          for(int i=0; i<3; i++){
            Serial.println(numObtained[i]);
          }
        }
      }
      //rpm = rpm + indexDec * val-'0';
      //Serial.println(rpm);
      //indexDec++;
    }
    for(int i=indexDec-1; i>=0; i--){
        rpm = rpm + indexNumObtained * numObtained[i];
        indexNumObtained*=10;
        if(debugMode){
          Serial.print("Num obtained at index : ");
          Serial.print(i);
          Serial.print(" : ");
          Serial.print(numObtained[i]);
          Serial.print(",  RPM: ");
          Serial.print(rpm);
          Serial.print(",  Index: ");
          Serial.println(indexNumObtained);
        }
        
      }
      Serial.print("RPM: ");
      Serial.println(rpm);
     //allumer();

  }
  if(val=='0'){
    eteindre();
  }
  if(val=='4'){
    allumer();
    for(int i=100; i<rpm; i+=5){
      Serial.println(i);
      myStepper.setSpeed(i);
      myStepper.step(10);
    }
    myStepper.setSpeed(rpm);
    myStepper.step(100*5);
    for(int i=rpm; i>100; i-=5){
      myStepper.setSpeed(i);
      myStepper.step(10);
    }
    eteindre();
  }
  if(val=='6'){
    allumer();
    myStepper.setSpeed(300);
    myStepper.step(-100*5);
    eteindre();
  }
}
