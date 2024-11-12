# ALIGN_MANUALLY
This code allows to configure manually a resizing of the depth and rgb image data superposed.
Using a reference (for example a squared box), it is possible to align the RGB and depth data.

> [!NOTE]
> You can see the values of the sliders by pressing the "s" key

> [!WARNING]
> This codes assumes the reshape values are constant. 
> This assumption will be approved / denied with further testing

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

# ALIGN_LIVE_STREAM
This code is the same as _align manually_ but using a video, and not only one snapshot.

> [!TIP]
> Try defining the parameters using the snapshot, it's visually more pleasing!