# MEASURE
This folder contains code using the realsense depth sensor in order to obtain distances.

## measure_dist_pixel
This code creates an image using the 3D sensor and prompts you to click on a point in the image in order to obtain the distance. 
Upon execution, it opens a new figure and waits for the user to left-click on the picture. Once this is done, it displays where the user clicked and the corresponding distance from the depth sensor. 

> [!NOTE]
> You can load the next frame right-clicking or pressing the right arrow button

<details>

<summary>USAGE EXAMPLE</summary>

### Usage example
<div align="center">
    <img height="60%" width="60%" alt="Image from matlab" src="/../main/mahel/img/img1.png?raw=true">
</div>
As it can be seen in the previous picture, the camera detects the changes of depth depending on the point chosen. 
The following configuration was used:
<div align="center">
    <img height="60%" width="60%" alt="Realsense config" src="/../main/mahel/img/img2.JPEG?raw=true">
</div>

> [!WARNING]
> The distance shown can be incorrect due to distorsion from vision angle of the camera


Example using a roud bin:
<div align="center">
    <img height="60%" width="60%" alt="Image from matlab" src="/../main/mahel/img/img3.png?raw=true">
</div>
The camera shows correctly the distance changing due to the round nature of the object.


</details>

## select_2_pixel.m
This code allows to calculate a distance using the depth camera between 2 points, selecting them on the plot.

> [!CAUTION]
> This code does not work for now.

## depth_stream_video
This code streams from the camera in both depth and rgb image and shows them in a montage. 

> [!CAUTION]
> This code does not work for now.

## config_DepthHighAccuracy
This code is a copy of [connectDepth.m](/../main/modules/connectDepth.m) configuring high-precision mode for the depth sensor.
Please use [connectDepth.m](/../main/modules/connectDepth.m) with the right parameters instead.
Information about connectDepth and its parameters: [connectDepth.m](/../main/modules/readme.md)