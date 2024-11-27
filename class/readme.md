# CLASS
This folder contains the classes defined in this project and used in some scripts.

## GET_FRAMES
This script defines a class called getFrames. It allows to load rapidly frames, whether it's from the camera or a stored file. 
The getFrames class is called in the same manner if you want to load from the camera or a file.
This allows to have the same code for treating data, and be able to switch rapidly to the desired input mode.


| Function  | Description |
| ------------- | ------------- |
| ```frame = getFrames();```<br/>```frame = getFrames("camera");```<br/>```frame = getFrames("camera", "jan");```  | Define the frame class to load frames from the camera |
| ```frame = getFrames("mahel/save/palet_con_rodillos4", "mahelv2");```  | Define the frame class to load frames from the folder ```mahel/save/palet_con_rodillos4``` in _mahelv2_ format|
| ```frame = getFrames(pathToFolder, "jan");```  | Define the frame class to load frames from the file in _jan_ saving format |
| ```frame = frame.setCameraParams("setDepthHighAccuracy");``` | Enable the depth high accuracy (not recommended) |
| ```frame = frame.setCameraParams("setDepthHighDensity");``` | Enable the depth high density (recommended) |
| ```frame = frame.setCameraParams("setWidthAndHeight",width, height");``` | Define custom width and height |
| ```frame = frame.setCameraParams("setFPS",fps);``` | Define custom fps |
| ```frame = frame.setCameraParams("setDefaultSizeColor");``` | Set the default size for the color camera |
| ```frame = enableDebugMode();``` | Enable the debug mode. This will show messages about each state to the console. Don't forget to ```clc``` it after! |
| ```frame = enableIntelFilters();``` | The depth returned will be filtered using the intel filters. |
| ```frame = frame = init();``` | Initialize the frame class. This step is mandatory as it is when the camera pipe is created / the files are loaded |
| ```[frame,depth,color] = get_frame_original(frame);``` | Returns _depth_original_ and _color_original_ already in image format |
| ```frame.stop()``` | Corresponds to the ```pipe.stop()``` of the realsense code |

<details>

<summary>Understand jan and mahel format</summary>

Due to the limitations in terms of performance and sizes available to upload in github, two saving formats have been defined.
The getFrames class intends to simplify the use of them. 

**jan format**:
This format intends to save all data to one .mat file. This includes color, depth but also fps and time for each frame.

**mahelv2 format**: 
This format splits each section onto separate files. This allows for smaller files, which can easily be uploaded through github.
It does not yet include fps and time for each frame.

**mahelv3 format**: 
This format yet not public will bring new possibilities to saving the content, such as timestamp saving, depth intrinsics save, etc... It is not yet functional.

</details>

<details>

<summary>EXAMPLE CODE WITH CAMERA</summary>

```matlab
frame = getFrames(); % Create frame to use camera
frame = frame.init(); % Calling the init function is mandatory

while (frame.isActive)
   % Wait for a new frame set
   disp("Getting frame");

   [frame,depth,color] = frame.get_frame_original(); % Get the frame

   imshowpair(depth,color,"montage");
end
```
Switching from camera to file is as easy as replacing ```frame = getFrames();``` to ```frame = getFrames("mahel/save/palet_con_rodillos4");```

</details>

<details>

<summary>EXAMPLE CODE WITH FILE</summary>

```matlab
targetPath = "mahel/save/palet_con_rodillos4";
frame = getFrames(targetPath, "mahelv2"); %Create frame to use file at path
frame = frame.init(); % Calling the init function is mandatory

while (frame.isActive)
   % Wait for a new frame set
   disp("Getting frame");

   [frame,depth,color] = frame.get_frame_original(); % Get the frame

   imshowpair(depth,color,"montage");
end
```
Switching from file to camera is as easy as replacing ```frame = getFrames("mahel/save/palet_con_rodillos4");``` to ```frame = getFrames();```

</details>
