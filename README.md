> [!CAUTION]
> This project reached the end of its development on January 21, 2024.


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
3. 3D point cloud

More information about each section will be provided below. 

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
    <img height="30%" width="30%" alt="Image" src="https://github.com/user-attachments/assets/674588cd-bc12-42d0-ad5e-0a725db13059">
</div>

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
Our goal is to update a Product Inspection Entry point which has the following form: 
<div align="center">
    <img height="50%" width="50%" alt="Image" src="https://github.com/user-attachments/assets/190d18a3-aba0-4b0e-a054-64c58f7a9ebf">
</div>

As we cannot have a real life-size model of this structure in our laboratory, we decided to create a functioning prototype, in which the pallet is turned upside down respect to the PIE:
<div align="center">
    <img height="50%" width="50%" alt="Image" src="https://github.com/user-attachments/assets/70439c9e-9b7f-4d60-ac62-2dedea2599ce">
</div>

The pallet is able to move as it is onto a sliding platform:
<div align="center">
    <img height="30%" width="30%" alt="Image" src="https://github.com/user-attachments/assets/24c04ff5-bd0d-4030-baeb-154ce2c26b61">
</div>

And the cameras are mounted in the top of the prototipe, at a respective angle of 45º
<div align="center">
    <img height="30%" width="30%" alt="Image" src="https://github.com/user-attachments/assets/b329d5b4-302a-4db4-8844-2229e4813a09">
</div>

