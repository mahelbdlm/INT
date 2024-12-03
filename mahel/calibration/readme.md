# Calibration
One of the main advantages of the depth camera is the ability to measure sizes and distances.
As we know the ```x``` and ```y``` of the picture we have taken, as well as the ```z``` (the depth), we can convert it to a 3D space. 
It is then trivial to obtain the distances between two points.

## So, why calibrating?
It turns out that (with the measures we made), the distance result has a constant offset. Using the calibration script, you can calculate this constant in order to obtain the correct distance between two points

## CALIBRATION SCRIPT EXAMPLE
Using this script, you can calculate the calibration constant. 
This code works for frames taken with the camera as well as frames from a saved file (using _mahelv3_ format)

Get frames from file: 
```MATLAB
targetPath = "mahel/save/test2"; % Path of the video file
frame = getFrames(targetPath, "mahelv3");
frame = frame.init(); % Initialize the frame class
```

Get frames from camera: 
```MATLAB
frame = getFrames(targetPath);
frame = frame.init(); % Initialize the frame class
```

Once you click on the play button, a window will appear. You can select the point you want for the measure. 
<div align="center"><img width="60%" height="60%" src="https://github.com/user-attachments/assets/570f77aa-4a5f-42b8-b10e-da8e7f7ad0e2"></img></div>
Once two points are selected, the calculated distance will be printed on the console. 

You can then press the "c" or "k" key to introduce manually the correct distance. This will calculate and show the result of the corrected constant.
<div align="center">
  <img width="20%" height="20%" src="https://github.com/user-attachments/assets/87624c9c-5d2d-4cdf-89aa-639a1c1c7ae7"></img>
  <img width="30%" height="30%" src="https://github.com/user-attachments/assets/ee5be29c-cf29-4155-86f4-04543bcdd8c9"></img>
</div>

The scripts used to calculate the distances are in the getDistance class, and based on the following python scripts: 
[Python SDK](https://github.com/IntelRealSense/librealsense/blob/5e73f7bb906a3cbec8ae43e888f182cc56c18692/include/librealsense2/rsutil.h#L69)

