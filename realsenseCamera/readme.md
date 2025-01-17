Below is a list of all the codes developped, their utility and their current status

Legend: 
| :white_check_mark:  Code is fully functional   |
|----|

| :asterisk:   Code is partially functional   |
|----|

| :recycle:  Code is deprecated (worked, but we changed things and created a new one)   |
|----|

| :x:  Code does not work   |
|----|

| :movie_camera:  The folder contains .mat video files   |
|----|

| Status | path | Description |
| ------------- | ------------- | ------------- |
| :white_check_mark: | ```calibration/manual_calib.m``` | Prompts user to select two points on an image and calculates the distance between the two points. Using the getFrames class, this code can be used with the real-time camera and with saved frames |
| :white_check_mark: | ```measure/measure_dist_pixel``` | Allows to measure the distance between two pixels, converting the selected points to 3D points |   
| :recycle: |  ```measure/select_2_pixels``` |  |
| :white_check_mark: |  ```save/depth_stream_video2``` |  |
| :white_check_mark: |  ```save/load_image``` |  |
| :white_check_mark: |  ```save/load_video``` |  |
| :white_check_mark: |  ```save/reduce_size``` |  |
| :white_check_mark: |  ```save/save2mat_jan``` |  |
| :recycle: |  ```save/save2mat_v1``` |  |
| :recycle: |  ```save/save2mat_v2``` |  |
| :white_check_mark: |  ```save/save2mat_v3``` |  |
| :movie_camera: |  ```save/palet_con_rodillos1``` | Format: mahelv2 |
| :movie_camera: |  ```save/palet_con_rodillos2``` | Format: mahelv2 |
| :movie_camera: |  ```save/palet_con_rodillos3``` | Format: mahelv2 |
| :movie_camera: |  ```save/palet_con_rodillos4``` | Format: mahelv2 |

Most of the codes above uses the ```modules``` folder and ```class``` folder. 
The getFrames, getDistance and cameraParams class are custom created to our needs. 
You can find more information about the classes [here](/class)
