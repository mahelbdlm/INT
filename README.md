> [!CAUTION]
> This project has reached its end of development the 19/12/2024.


# WHAT IS THE PROJECT ABOUT?
Nowadays, the vast majority of transit of goods is done via pallets. They are easy to use, reuse and come in standard sizes. But as they are made of wood and degrade over time, they can be a real threat to warehouses, especially automated ones. 
That’s why every warehouse is equipped with a PIE (or Product Inspection Entry). Its main purpose is to determine whether the pallet (and merchandise) meets the required conditions in order to be stocked. It is crucial to discard defective pallets, especially in automated warehouses, as they can have huge consequences, from losing merchandise to a total warehouse blockage.

The objective of this project is to detect the defects a palet can have using 3D cameras. 
To do this, we will use MATLAB and the intel realsense D435i. 

> [!NOTE]
> Custom classes have been defined in this project (```getFrames```, ```getDistance```,...). Their purpose is to facilitate the transition between frames from the camera and saved frames. This was an approach to standarize the code between each member of the team, and facilitate bulk changes.

# TWO DISTINCTS PARTS
This project will be divided into several parts:

1. Detection of the palet from below
2. Detection of the palet from a perspective
3. Palet integrity

More information about each section will be provided below. 

> [!WARNING]
> Due to budget cuts in our project, only two out of three cameras will be available. One will be placed below the palet, and the other on one side.

The cameras used are intel realsense D435i

<details>

<summary>More information about palet defects</summary>

### ALL THE DEFECTS A PALET CAN HAVE

![Raklapok_3_EN_V2](https://github.com/user-attachments/assets/b8ae4ea6-bd8c-49f1-ae6a-81bd0d1aafb4)
<div align="center">Image Source: [dewinter](https://dewinter.hu/standards/)</div>

Palets can have many diferent defects, from missing the EU sign to missing parts of the palet itself. 

In this project we will treat the following defects: 
* Incorrect sizes
* Missing panel

</details>

## Detection of the palet from below
<div align="center">
    <img height="30%" width="30%" alt="Image" src="https://github.com/user-attachments/assets/39c15630-afaa-466e-b110-62b829ce1f09">
</div>

[TODO: add more info]

## Detection of the palet with perspective
<div align="center">
    <img height="60%" width="60%" alt="Image" src="https://github.com/user-attachments/assets/5f1875cf-8dd7-4075-9e44-e8ceb45cc67f">
</div>
One camera will capture the palet using this angle. This will help us identify the following issues: 

1. Incorrect sizes
   - Detecting the squares of the palet, we can identify the palet sizes
2. Missing panel

More information about these codes can be found [here](mahel/readme.md)


# PROTOTYPE
This code will be used with a physical prototype. 
Below is a detail of all the material used in order to mount the prototype: 

| Element | Units | Price(total) | Reference/link |
| ------------- | ------------- | ------------- | ------------- |
| Realsense D435i depth cam | 2 | 668 | [link](https://store.intelrealsense.com/buy-intel-realsense-depth-camera-d435i.html) |
| Alum. profile 30x30 2m | 5 | 201.45 | [link](https://es.rs-online.com/web/p/tubos-y-perfiles/2647863) |
| Alum. profile 30x30 1m | 4 | 84.4 | [link](https://es.rs-online.com/web/p/tubos-y-perfiles/2647862?gb=s) |
| Alum. corner connection | 20 | 160.4 | [link](https://es.rs-online.com/web/p/componentes-de-conexion/3901798?gb=s) |
| Hammer-head M6 nut | 30 | 23.91 | [link](https://es.rs-online.com/web/p/componentes-de-conexion/2768170?gb=s) |
| M6 Allen screw 20mm | 50 | 24.49 | [link](https://es.rs-online.com/web/p/tornillos-allen/4839688?gb=a) |
| 80mm wheels | 5 | 44.15 | [link](https://es.rs-online.com/web/p/ruedas-industriales/6679463?gb=s) |
| M6 Allen screw 10mm | 20 | 17.92 | [link](https://es.rs-online.com/web/p/tornillos-allen/8741021) |
| Alum. lateral connection  | 4 | 95.44| [link](https://es.rs-online.com/web/p/componentes-de-conexion/3902000) |
| LED 5m strip | 1 | 86.89 | [link](https://es.rs-online.com/web/p/tiras-de-led/1533661?searchId=c3c85c20-2f5b-480a-a57e-2065bbc26e84&gb=s) |

