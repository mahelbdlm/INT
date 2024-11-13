# SAVE
The scripts in this folder are used in order to save data from the 3D camera to a .mat file

## SAVE2MAT
Save data from the depth sensor and rgb sensor to .mat format for processing without camera. 
Upon execution, the script will automatically create a new folder named testx, with x the first number available (starting from 1), and save in .mat file the RGB images resized to match the depth one (_video_color_resized.mat_), the original data from the depth sensor (_video_depth_original_) and the data filtered (_video_depth_filtered_).

You can optionally uncomment all the appearances of _video_color_original_ to save it.

> [!NOTE]
> The RGB image has been resized to match the resolution of the depth image.
