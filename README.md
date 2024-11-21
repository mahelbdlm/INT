# WHAT IS THE PROJECT ABOUT?
Nowadays, the vast majority of transit of goods is done via pallets. They are easy to use, reuse and come in standard sizes. But as they are made of wood and degrade over time, they can be a real threat to warehouses, especially automated ones. 
That’s why every warehouse is equipped with a PIE (or Product Inspection Entry). Its main purpose is to determine whether the pallet (and merchandise) meets the required conditions in order to be stocked. It is crucial to discard defective pallets, especially in automated warehouses, as they can have huge consequences, from losing merchandise to a total warehouse blockage.

The objective of this project is to detect the defects a palet can have using 3D cameras. In order to do so, we will use the intel realsense D435i camera and the matlab code in this folder.

> [!NOTE]
> This project is currently at early stage. Each team member is working on some parts which will then be assembled into one general folder for each functionnality the system must have.

# TWO DISTINCTS PARTS
This project will be divided into two distinct parts:

1. Detection of the palet from below
2. Detection of the palet from the sides

More information about each section will be provided below. 

> [!WARNING]
> Due to budget cuts in our project, only two out of three cameras will be available. One will be placed below the palet, and the other on one side. 

<details>

<summary>More information about palet defects</summary>

### ALL THE DEFECTS A PALET CAN HAVE

![Raklapok_3_EN_V2](https://github.com/user-attachments/assets/b8ae4ea6-bd8c-49f1-ae6a-81bd0d1aafb4)
<div align="center">Image Source: [dewinter](https://dewinter.hu/standards/)</div>

Palets can have many diferent defects, from missing the EU sign to missing parts of the palet itself. 

In this project we will treat the following defects: 
* Incorrect sizes
* Missing panel
* TBD

</details>

## Detection of the palet from the sides
<div align="center">
    <img height="60%" width="60%" alt="Image" src="https://github.com/user-attachments/assets/8f85b794-b99f-4169-b10d-4218a8bd55a7">
</div>
One camera will capture the palet using this angle. This will help us identify the following issues: 

1. Incorrect sizes
   - Detecting the squares of the palet, we can identify if the palet is european
2. Missing panel

> [!IMPORTANT]
> The script will be able to identify if it is a european palet. As we don't have an american palet available, the correct identification of an american palet is not assured.
## Detection of the palet from below
<div align="center">
    <img height="30%" width="30%" alt="Image" src="https://github.com/user-attachments/assets/39c15630-afaa-466e-b110-62b829ce1f09">
</div>
