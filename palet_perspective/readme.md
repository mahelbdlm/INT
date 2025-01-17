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
| :asterisk: | ```deep_learning/selected_frames/DL_demo_OK``` | Uses the segmentAnything model to separate the pallet from the background and applies two bondingBox detections. Specific for the frame with the good part of the pallet. |
| :asterisk: | ```deep_learning/selected_frames/DL_demo_NO``` | Uses the segmentAnything model to separate the pallet from the background and applies two bondingBox detections. Specific for the frame with the palet missing a part. |
| :x: | ```deep_learning/DL``` |  |
| :white_check_mark:| ```detect_missing_part/ideal_img/detect_ideal_palet``` |  |
| :movie_camera: | ```detect_missing_part/missing_splinter1``` | Format: mahelv2 | 
| :movie_camera: | ```detect_missing_part/missing_splinter2``` | Format: mahelv2 | 
| :asterisk:| ```detect_missing_part/edge_detection``` |  |   
| :recycle: |  ```research/``` |  |
| :movie_camera: |  ```video_stable/europeo1``` | Format: mahelv3 |
| :movie_camera: |  ```video_stable/europeo2``` | Format: mahelv3 |
| :movie_camera: |  ```video_stable/europeo3``` | Format: mahelv3 |
| :movie_camera: |  ```video_stable/europeo4``` | Format: mahelv3 |
| :movie_camera: |  ```video_stable/europeo5``` | Format: mahelv3 |
| :movie_camera: |  ```video_stable/europeo6``` | Format: mahelv3 |

Most of the codes above uses the ```modules``` folder and ```class``` folder. 
The getFrames, getDistance and cameraParams class are custom created to our needs. 
You can find more information about the classes [here](/class)
