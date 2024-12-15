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
| ```frame = frame.enableDebugMode();``` | Enable the debug mode. This will show messages about each state to the console. Don't forget to ```clc``` it after! |
| ```frame = frame.enableIntelFilters();``` | The depth returned will be filtered using the intel filters. |
| ```frame = frame.init();``` | Initialize the frame class. This step is mandatory as it is when the camera pipe is created / the files are loaded |
| ```[frame,depth,color] = frame.get_frame_original(frame);``` | Returns _depth_original_ and _color_original_ already in image format. This function is deprecated. Use get_frame_aligned instead. |
| ```[frame,depth,color] = frame.get_frame_aligned(frame);``` | Returns _depth_aligned_to_color_ and _color_. The depth has not been processed, just changed to matrix format. This allows to be able to measure distances using the getDepth function.|
| ```distance = frame.getDepth(img, point)``` | point is a vector [x y]. This function returns the depth of the desired point, and if it is 0, returns the maximum point in a range of +-5 width +-5 height using matrices  |
| ```[frame,depth,color] = frame.get_frame_at_index(indexFrame)``` | Get a frame at a desired index (only for stored files) |
| ```frame.stop()``` | Corresponds to the ```pipe.stop()``` of the realsense code |

Below are detailed the properties of this class:
| Attribute  | Description |
| ------------- | ------------- |
| ```type```  | Stores the type of use: camera or local file |
| ```path```  | Stores the path to the local file |
| ``` isActive```  | Used for playback in local file. This parameter switches to 0 once all the frames have been read. This makes it easy to put in a while loop.|
| ```cameraParam```  | stores the _cameraParam_ class|
| ```cameraPipeline```  | stores the camera pipeline (when connecting a camera, after initialization) |
| ```cameraProfile```  | stores the camera profile (when connecting a camera, after initialization) |
| ```file_color_original```  | Stores the color frame in _mahelv2_ and _mahelv3_ format |
| ```file_video```  | Stores the mat video file of _jan_ format |
| ```file_index```  | Stores the current index of the frame to return |
| ```file_depth_oringinal```  | Stores the depth frames in _mahelv2_ and _mahelv3_. Keep in mind that _mahelv2_ depth frames have been colorized, and therefore don't show much information. This is the main reason for the switch to _mahelv3_  |
| ```nbFrames```  | Total number of frames of the local video file |
| ```debugMode```  | If activated, prints more information on the console  |
| ```saveType```  | Stores the local file type: _mahelv2_, _mahelv3_ or _jan_|
| ```intelFilters```  | If enabled, processes the frames through the intel filters. (this part has not been tested, we're not using it and don't know if it really works)|
| ```colorizer```  | Stores the depth colorizer to be used if intelFilters is activated |
| ```distance```  | Stores the _distanceClass_ class |

More information about the _cameraParams_ and _distanceClass_ classes can be found below.


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
This format only saves the depth aligned to color and color frames. It also stores the camera intrinsics in a separate file to be able to measure distances.

</details>


## CameraParams
This class is used to store camera parameters, such as intrinsics and the depth scale. 
It is automatically initialized in the getFrames class, and can be accessed through the frame.cameraParam property. 

Below are detailed the properties of this class:
| Properties  | Description |
| ------------- | ------------- |
| ```depthHighAccuracy```  | 1: High accuracy mode enabled.<br/>0: High accuracy mode disabled.<br/>Default value: 0<br/> We recommend to keep this value to default.|
| ```cameraWidth```  | Width in pixels of the image we want to recieve from the camera.<br/>Default value: 640|
| ```cameraHeight```  | Height in pixels of the image we want to recieve from the camera.<br/>Default value: 480 |
| ```FPS```  | Number of frames per second the camera returns.<br/>Default value: 30 |
| ```defaultSizeColor```  | Make the camera return the color frames in default sizes<br/>Default value: 0<br/>We recommend to keep this value to default.|
| ```depthHighDensity```  | Improve the depth camera density<br/>Default value: 1|

As explained before, this classed is stored in the cameraParam property of the getFrames class. 
To change the parameters of the camera, you can call one of the following functions:
| Function  | Description |
| ------------- | ------------- |
| ```frame = frame.setCameraParams("setDepthHighAccuracy");``` | Enable the depth high accuracy (not recommended) |
| ```frame = frame.setCameraParams("setDepthHighDensity");``` | Enable the depth high density (recommended) |
| ```frame = frame.setCameraParams("setWidthAndHeight",width, height");``` | Define custom width and height |
| ```frame = frame.setCameraParams("setFPS",fps);``` | Define custom fps |
| ```frame = frame.setCameraParams("setDefaultSizeColor");``` | Set the default size for the color camera |

Keep in mind that **these functions must be called before calling frame.init()**

## distanceClass
This class stores all information relative to measuring distances with the camera. Its properties are: 
| Properties  | Description |
| ------------- | ------------- |
| ```intrinsics```  | Intrinsics of the camera. Come from the camera itself if connected, or the stores cameraParams.mat file (in _mahelv3_ format). Other formats don't support this feature. |
| ```depthScale```  | Depth scale of the camera. Used to convert the raw depth information to relative distance.|
| ```correctionConstant```  | Correction constant obtained using the mahel/calibration algorithm. It is primordial to retrieve the correct distance between two 3D points.  |

The class also has function to convert points to 3D and measure the distances between 3D points. These codes come from https://github.com/IntelRealSense/librealsense/blob/5e73f7bb906a3cbec8ae43e888f182cc56c18692/include/librealsense2/rsutil.h and have been translated to matlab

| Function  | Description |
| ------------- | ------------- |
| ```point = frame.distance.deproject_pixel_to_point(pixel, depthDistance)``` | Converts the [x y] point and z obtained from frame.getDistance to a 3D point. |
| ```distance = frame.distance.setCameraParams("setDepthHighDensity");``` | Returns the distance between 2 3D points obtained from the _deproject_pixel_to_point_ function |

# Working codes
Codes using this class can be found in the /mahel folder. 
We recommend you take a look at the calibration code, which uses most of the functions stated above. 
You can try saving frames using the /mahel/save/save2mat_v3.m file, and run the calibration code with the saved frames. 

This is the main advantage of this class, it is extremely easy to switch from the camera to a stored file, and doesn't require to change the code at all.
