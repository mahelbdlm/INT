# SAVE
The scripts in this folder are used in order to save data from the 3D camera to a .mat file

## SAVE2MATV3
This function allows to save color/depth data to a .mat file in order to treat it later. 
This code uses de _mahelv3_ format, that saves the raw depth data (contrary to _mahelv2_ that saved the colorized depth). 
This script has been optimized to work with the get_frames class. In this way, changes can be made instantly for all scripts connecting to the camera.
The main advantage of the getFrames class is to be able to work with the same code, and switching easily from the camera to a saved file. 

## depth_stream_video_v2
This code uses the getFrames class to obtain frames from the camera / user file depending on the configuration.
It is designed to easily switch from one to the other.
For more information regarding the getFrames class, [click here](/../main/modules/readme.md)

## LOAD_VIDEO
Loads a video from a file using the getFrames class.

## REDUCE_SIZE
Reduces the number of frames of a saved _mahelv3_ file to the desired number of frames. 
This allows to reduce the size of the file, and thus uploading it to github.

## SAVE2MATv1 / SAVE2MATV2

> [!CAUTION]
> This code is deprecated and should not be used

Save data from the depth sensor and rgb sensor to .mat format for processing without camera. 
Upon execution, the script will automatically create a new folder named testx, with x the first number available (starting from 1), and save in .mat file the RGB images resized to match the depth one (_video_color_resized.mat_), the original data from the depth sensor (_video_depth_original_) and the data filtered (_video_depth_filtered_).

You can optionally uncomment all the appearances of _video_color_original_ to save it.

> [!NOTE]
> The RGB image has been resized to match the resolution of the depth image.
