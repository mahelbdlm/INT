# ALIGN DEPTH RGB
The scripts in this folder try to match the RGB and depth camera data by applying photoshop-like resizing, and distortionning.

> [!CAUTION]
> These codes won't be used as we realized the camera itself has an alignment function.

# TEST_ALL_ALIGN
This code uses the realsense integrated _align_to_ function to align the depth and color sensor. 
<details>

<summary>USAGE EXAMPLE</summary>

Upon executing the code: 
<div align="center">
    <img height="60%" width="60%" alt="Image" src="https://github.com/user-attachments/assets/a49db956-c47f-4cf1-b1dd-73c952978080">
</div>
As it can be seen in the previous picture, the camera already has a function to align depth and color data, we now need to make them match in the same dimensions.

</details>

## ALIGN_LIVE_STREAM
This scripts shows a live video of both the RGB camera and depth sensor overlayed, 
and some cursors in order to apply the necessary transformations to match the RGB and the depth data.
> [!WARNING]
> This code was created before making the realsense align_to work. We are currently evaluating whether it will be used or not. 

> [!TIP]
> Press the s key to show the values of the sliders (in matlab), and r key to revert to original values


<details>

<summary>USAGE EXAMPLE</summary>

Upon executing the code: 
<div align="center">
    <img height="60%" width="60%" alt="Image from matlab" src="/../main/mahel/img/img6.png?raw=true">
</div>
As it can be seen in the previous picture, the picture can be modified by using the sliders. 
This allows to control manually how the two pictures overlay. 

The values of deformation used can be seen pressing the "s" key. In this case: 
```matlab
sliderX_init = -30;
sliderY_init = -126;
sliderScale_init = 1.18;
sliderWidth_init = 0.97;
sliderHeight_init = 1.28;
```

</details>

Using this script, it will be determined if a simple transformation can make the depth correspond to the image. 

## ALIGN_MANUALLY
This code allows to configure manually a resizing of the depth and rgb image data superposed.
Using a reference (for example a squared box), it is possible to align the RGB and depth data.

> [!WARNING]
> This code was created before making the realsense align_to work. We are currently evaluating whether it will be used or not. 

> [!TIP]
> You can see the values of the sliders by pressing the "s" key

<details>

<summary>USAGE EXAMPLE</summary>

Upon executing the code: 
<div align="center">
    <img height="60%" width="60%" alt="Image from matlab" src="/../main/mahel/img/img5.png?raw=true">
</div>
As it can be seen in the previous picture, the picture can be modified by using the sliders. 
This allows to control manually how the two pictures overlay. 

The values of deformation used can be seen pressing the "s" key. In this case: 
```dx = 2, dy = -117, scale = 1.12, width_scale = 1.00, height_scale = 1.34```

</details>
