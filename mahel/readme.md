Below is a list of all the codes developped, their utility and their current status in the ```/mahel``` folder

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
| :asterisk: | ```deep_learning/selected_frames/DL_demo_OK``` | Uses the segmentAnything model to separate the pallet from the background and applies two bondingBox detections. Specific for the frame with the good part of the pallet. |
| :asterisk: | ```deep_learning/selected_frames/DL_demo_NO``` | Uses the segmentAnything model to separate the pallet from the background and applies two bondingBox detections. Specific for the frame with the palet missing a part. |
| :x: | ```deep_learning/DL``` |  |
| :white_check_mark:| ```detect_missing_part/ideal_img/detect_ideal_palet``` |  |
| :movie_camera: | ```detect_missing_part/missing_splinter1``` | Format: mahelv2 | 
| :movie_camera: | ```detect_missing_part/missing_splinter2``` | Format: mahelv2 | 
| :asterisk:| ```detect_missing_part/edge_detection``` |  |   
| :recycle: |  ```research/``` |  |
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
| :movie_camera: |  ```video_stable/europeo1``` | Format: mahelv3 |
| :movie_camera: |  ```video_stable/europeo2``` | Format: mahelv3 |
| :movie_camera: |  ```video_stable/europeo3``` | Format: mahelv3 |
| :movie_camera: |  ```video_stable/europeo4``` | Format: mahelv3 |
| :movie_camera: |  ```video_stable/europeo5``` | Format: mahelv3 |
| :movie_camera: |  ```video_stable/europeo6``` | Format: mahelv3 |

Most of the codes above uses the ```modules``` folder and ```class``` folder. 
The getFrames, getDistance and cameraParams class are custom created to our needs. 
You can find more information about the classes [here](/class)
