# MEASURE
The files contained in this folder allow to measure distances using the realsense camera.  
The description of each file is detailed below: 

## measure_dist_pixel
This code creates an image using the 3D sensor and prompts you to click on a point in the image in order to obtain the distance. 
Upon execution, it opens a new figure and waits for the user to left-click on the picture. Once this is done, it displays where the user clicked and the corresponding distance from the depth sensor. 

> [!NOTE]
> You can load the next frame right-clicking or pressing the right arrow button

<details>

<summary>USAGE EXAMPLE</summary>

Upon executing the code: 
<div align="center">
    <img height="60%" width="60%" alt="Image from matlab" src="https://github.com/user-attachments/assets/3fcadc4c-8a2e-46fc-8716-af14347cae51">
</div>
As it can be seen in the previous picture, the camera detects the changes of depth depending on the point chosen. 
The following configuration was used:
<div align="center">
    <img height="60%" width="60%" alt="Realsense config" src="https://github.com/user-attachments/assets/3904bb0d-abcd-4c37-89de-63cabaed67cb">
</div>

Example using a roud bin:
<div align="center">
    <img height="60%" width="60%" alt="Image from matlab" src="https://github.com/user-attachments/assets/6c6a70fa-ba17-4485-bc42-f3648d3f1ab7">
</div>
The camera shows correctly the distance changing due to the round nature of the object.


</details>

## select_2_pixel.m
This code allows to calculate a distance using the depth camera between 2 points, selecting them on the plot.