# ARDUINO
This part of the project uses an Arduino UNO 3 to control a stepper motor for the prototipe.
This will allow us to move the palet/camera at a constant speed, thus improving the output result.

Based on [Arduino docs](https://docs.arduino.cc/learn/electronics/stepper-motors/)

Schematic circuit: 
<div align="center">
    <img height="60%" width="60%" alt="Image from matlab" src="https://docs.arduino.cc/static/ab1a1fcdc08dc7e8a5cec48a5b705cbc/0a47e/bipolarKnob_schms.png">
</div>

Datasheet of bipolar stepper motor
[Datasheet](https://www.oyostepper.com/images/upload/File/17HS19-2004S1.pdf)

<div align="center">
    <p>Configuration as for now: </p>
    <img height="60%" width="60%" alt="Image" src="https://github.com/user-attachments/assets/42ac0648-68c9-4ba8-a98d-e4ff1276e735">
    <p>The stepper motor will be mounted upon a piece of wood, which will make it more stable. </p>
    <img height="60%" width="60%" alt="Image" src="https://github.com/user-attachments/assets/1fc7d6c6-7ba3-4120-806b-e54fc8864dc3">
</div>

As for now, I am currently updating the code in order to determine the maximum stable velocity of the stepper motor. 

> [!WARNING]
> I have connected the stepper motor to a source of 12V, and burned myself while touching the SN754410NE (H bridge), I'm currently searching to see if the maximum voltage would not be 9V instead...
