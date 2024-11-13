# MODULES
This folder contains modules necessary for the correct behaviour of some programs.
Below is detailed the purpose of each file.

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