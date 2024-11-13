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
#include <EEPROM.h>
#include <Stepper.h>
int val=0;
const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution
// for your motor

// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, 8, 9, 10, 11);
void allumer(){
  Serial.println("Energy and stepper motor activated");
 pinMode(12, OUTPUT);
  digitalWrite(12, HIGH);
    digitalWrite(8, HIGH);
digitalWrite(9, LOW);
digitalWrite(10, HIGH);
digitalWrite(11, LOW);
}
void eteindre(){
 Serial.println("Energy and stepper motor desactivated");
digitalWrite(8, LOW);
digitalWrite(9, LOW);
digitalWrite(10, LOW);
digitalWrite(11, LOW);
  digitalWrite(12, LOW);
}
void ouvrir(){
  allumer();
    myStepper.setSpeed(50);
myStepper.step(920);
for (int i=50; i <= 90; i++){
  myStepper.setSpeed(i);
myStepper.step(2);
  }
myStepper.setSpeed(90);
myStepper.step(2180);
for (int i=90; i >= 50; i--){
  myStepper.setSpeed(i);
myStepper.step(2);
  }
myStepper.setSpeed(50);
myStepper.step(420);
for (int i=50; i >= 30; i--){
  myStepper.setSpeed(i);
myStepper.step(2);
  }
myStepper.setSpeed(30);
myStepper.step(400);
eteindre();
eeprom_ouvert();
}
void fermer(){
  allumer();
  myStepper.setSpeed(50);
myStepper.step(-920);
for (int i=50; i <= 90; i++){
  myStepper.setSpeed(i);
myStepper.step(-2);
  }
myStepper.setSpeed(90);
myStepper.step(-1480);
for (int i=90; i >= 50; i--){
  myStepper.setSpeed(i);
myStepper.step(-2);
  }
myStepper.setSpeed(50);
myStepper.step(-1560);
eteindre();
eeprom_ferme();
}
void eeprom_ouvert(){
  int eeAddress = 0;
  int f = 0;
  EEPROM.put(eeAddress, f);
  Serial.println("---");
  Serial.println("EEPROM -- ouvert");
  Serial.println("---");
  }
void eeprom_ferme(){
  int eeAddress = 0;
  int f = 1;
  EEPROM.put(eeAddress, f);
  Serial.println("---");
  Serial.println("EEPROM -- ferme");
  Serial.println("---");
  }
void setup() {
  Serial.begin(9600);
  Serial.println("Send the q letter if you want to stop the opening/closing");
  Serial.println("You have 3 seconds");
  delay(3000);
  if(not(Serial.available())){
Serial.println("Delay 7 seconds before activating system");

///*
delay(7000);

int f = 2;   //Variable to store data read from EEPROM.
  int eeAddress = 0; //EEPROM address to start reading from

  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  Serial.print("Read float from EEPROM: ");

  //Get the float data from the EEPROM at position 'eeAddress'
  EEPROM.get(eeAddress, f);
  if(f==1){
    //moteur vers la gauche
  allumer();
  Serial.println("Ouvrir");
  Serial.println("Beginning in 5 seconds");
  delay(5000);
    ouvrir();
  }
  else if(f==0){
    //moteur vers la droite
  allumer();
  Serial.println("Fermer");
  delay(5000);
  Serial.println("Beginning in 5 seconds");
    fermer();
  }

  //*/
  }
  else{
    Serial.println("Serial available");
  }
  }
void loop() {
  val=Serial.read();
  if(val=='1'){
     allumer();
  }
  if(val=='0'){
    eteindre();
  }
  if(val=='o'){
    ouvrir();
  }
  if(val=='f'){
    fermer();
  }
  if(val=='c'){
    allumer();
myStepper.setSpeed(30);
myStepper.step(-4300);
eteindre();
  }
  if(val=='d'){
    allumer();
    for (int i=1; i <= 43; i++){
    myStepper.setSpeed(50);
myStepper.step(100);
delay(1000);
eteindre();
  }
  }
  //Moteur vers la droite
  if(val=='6'){
    allumer();
myStepper.setSpeed(50);
myStepper.step(-50);
eteindre();
  }
   if(val=='7'){
    allumer();
myStepper.setSpeed(50);
myStepper.step(-50);
eteindre();
  }
  if(val=='8'){
    allumer();
myStepper.setSpeed(50);
myStepper.step(-500);
eteindre();
  }

  if(val=='9'){
    allumer();
    myStepper.setSpeed(100);
    myStepper.step(-2150);
    eteindre();
  }
  //Moteur vers la gauche
    if(val=='2'){
    allumer();
myStepper.setSpeed(50);
myStepper.step(50);
eteindre(); }

  if(val=='3'){
    allumer();
myStepper.setSpeed(50);
myStepper.step(100);
eteindre();
  }

  if(val=='4'){
    allumer();
    myStepper.setSpeed(100);
    myStepper.step(500);
    eteindre();
  }
  if(val=='5'){
    allumer();
    myStepper.setSpeed(100);
    myStepper.step(2150);
    eteindre();
  }
  if(val=='z'){
    eeprom_ouvert();
  }
  if(val=='x'){
   eeprom_ferme();
  }
}
