# MODULES
This folder contains modules necessary for the correct behaviour of some programs.
Below is detailed the purpose of each file.

## GET_FRAMES
This script defines a class called getFrames. It allows to load rapidly frames, whether it's from the camera or a stored file. 
The getFrames class is called in the same manner if you want to load from the camera or a file.
This allows to have the same code for treating data, and be able to switch rapidly to the desired input mode.


| Function  | Description |
| ------------- | ------------- |
| ```frame = getFrames();```<br/>```frame = getFrames("camera");```  | Define the frame class to load frames from the camera |
| ```frame = getFrames("mahel/save/palet_con_rodillos4");```  | Define the frame class to load frames from the folder ```mahel/save/palet_con_rodillos4```|
| ```frame = setDepthHighAccuracy();``` | Enable the depth high accuracy |
| ```frame = setWidthAndHeight(width, height);``` | Define custom width and height |
| ```frame = setFPS(fps);``` | Define custom fps |
| ```frame = frame = init();``` | Initialize the frame class. This step is mandatory as it is when the camera pipe is created / the files are loaded |
| ```[frame,depth,color] = get_frame_original(frame);``` | Returns _depth_original_ and _color_original_ already in image format |
| ```frame.stop()``` | Corresponds to the ```pipe.stop()``` of the realsense code |

<details>

<summary>EXAMPLE CODE WITH CAMERA</summary>

```matlab
frame = getFrames(); % Create frame to use camera
frame = frame.init(); % Calling the init function is mandatory

while (frame.isActive)
   % Wait for a new frame set
   disp("Getting frame");

   [frame,depth,color] = frame.get_frame_original(); % Get the frame

   color_img_resized = imresize(color, [480, 640]);

   imshowpair(depth,color_img_resized,"montage");
end
```
Switching from camera to file is as easy as replacing ```frame = getFrames();``` to ```frame = getFrames("mahel/save/palet_con_rodillos4");```

</details>

<details>

<summary>EXAMPLE CODE WITH FILE</summary>

```matlab
targetPath = "mahel/save/palet_con_rodillos4";
frame = getFrames(targetPath); %Create frame to use file at path
frame = frame.init(); % Calling the init function is mandatory

while (frame.isActive)
   % Wait for a new frame set
   disp("Getting frame");

   [frame,depth,color] = frame.get_frame_original(); % Get the frame

   color_img_resized = imresize(color, [480, 640]);

   imshowpair(depth,color_img_resized,"montage");
end
```
Switching from file to camera is as easy as replacing ```frame = getFrames("mahel/save/palet_con_rodillos4");``` to ```frame = getFrames();```

</details>

## connectDepth
This file connects the relasense camera and returns a pipe.
This function is customizable, using variable number of inputs (varargin, nargin).
For more information on varargin, visit [matlab site](https://mathworks.com/help/matlab/ref/varargin.html) or ask a fellow student.

```pipe=connectDepth(a,b,c,d);```
| Variable  | Description |
| ------------- | ------------- |
| ```pipe=connectDepth();```  | Default config: <br/> highAccuracy=0;<br/>WIDTH=640;<br/>HEIGHT=480;<br/>FPS= 30;|
| ```a```  | High accuracy. 1 for enabled, 0 for disabled  |
| ```b```  | FPS (30 by default)  |
| ```c,d```  | Width, Height<br/>IMPORTANT: c and d must be defined, you cannot only define c.  |

Below are some examples of utilization: 
| Code used  | Description |
| ------------- | ------------- |
| ```pipe=connectDepth();```  | Connect the realsense camera with default config  |
| ```pipe=connectDepth(1);```  | Connect with high accuracy for depth sensor  |
| ```pipe=connectDepth(1,60);```  | Connect with high accuracy and 60 fps  |
| ```pipe=connectDepth(0,60,640,480);```  | Connect without high accuracy, at 60 fps with width 640 and height 480  |

## checkPath
This function ensures the user has the right folder selected, or calculates the right relative path to this folder. 
If the user is outside the INT folder, or inside /folder2 when the path is /folder1/subfolder1, the function returns an error.