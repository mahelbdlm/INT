# edge_detection
This code tries to detect the pallet. This will be especially useful to identify whether the palet has a missing / not aligned splinter, or not. 

## Step by step explanation of the code

> [!WARNING]
> This example has been made with low-quality images. The result will not be very good, but it allows to understand what the code does.

### DETECTION OF THE LARGEST STRAIGHT LINE
| Function  | Description | Image result |
| ------------- | ------------- | ------------- |
| ```[frame,depth,color] = frame.get_frame_at_index(120);```  | Returns the ```color``` image (120th frame of _missing_splinter1_) |![image](https://github.com/user-attachments/assets/21461776-19b6-40e7-b56a-3f44b03a6fb0)|
| ```grayImg = rgb2gray(color);```  | Convert RGB image to gray | ![image](https://github.com/user-attachments/assets/df7ca9f8-e8c8-428f-91ab-0c5f3ed7efe1 ) |
| ```grayImg = rgb2gray(color);```  | Convert RGB image to gray | ![image](https://github.com/user-attachments/assets/df7ca9f8-e8c8-428f-91ab-0c5f3ed7efe1 ) |
| ```bwImg = imbinarize(grayImg, 'adaptive', 'Sensitivity', 0.5);```  | Convert image to a 1/0 image for edge detection |![image](https://github.com/user-attachments/assets/0a298ee0-b0b5-445d-ad92-93954aa7399c)|
| ```bwFilled = imfill(bwImg, 'holes');```  | Fill holes (0's) by 1's |![image](https://github.com/user-attachments/assets/b6770dc7-05a9-4167-ae0b-af60c918a79e)|
| ```edges = edge(bwFilled, 'canny');```  | Uses canny edge detection algorithm |![image](https://github.com/user-attachments/assets/ff6ac517-c8bf-4611-b558-f44a0a6f6b1a)|
| ```[H,T,R]=hough(edges);```  | Perform a Hough transformation on the binary file to identify straight lines ||
| ``` P  = houghpeaks(H,1,'threshold',ceil(0.3*max(H(:))));```<br/><br/>```lines = houghlines(bwFilled,T,R,P,'FillGap',5,'MinLength',7);```  | houghpeaks identifies the most prominent lines (peaks in H)<br/><br/>houghlines extracts the line segments corresponding to these peaks. |![image](https://github.com/user-attachments/assets/9c9871b2-df31-4a6e-9a7a-7a95f4611407)|

### ROTATE, RESIZE IMAGE
| Function  | Description | Image result |
| ------------- | ------------- | ------------- |
| ```I=imrotate(color,90+lines(1).theta);```  | Rotate the image to be vertical on the straight line obtained before |![image](https://github.com/user-attachments/assets/bc5ee079-97f4-4e0c-a237-3bd5f3b3d74b)|
| ```if mod(lines(1).theta, 90) - 45 < 0```<br/>```    hcrop = find(I(:,3) > 0, 1);```<br/>```    wcrop = length(I(1,:)) - find(I(3, end:-1:1) > 0, 1);```<br/>```end```<br/>```if mod(lines(1).theta, 90) - 45 > 0```<br/>```    hcrop = find(I(end:-1:1,3) > 0, 1);```<br/>```    wcrop = length(I(1,:)) - find(I(3,:) > 0, 1);```<br/>```end```<br/>```I = I(hcrop:end-hcrop, end-wcrop:wcrop);```  |  The image I is cropped to focus on the relevant portion<br/><br/>Depending on the orientation of the detected line (angle relative to 90°), the code calculates cropping indices hcrop (for height) and wcrop (for width). It uses pixel intensity checks ```find(I(:,3) > 0, 1)``` to determine the cropping regions.  |![image](https://github.com/user-attachments/assets/0158e606-c0e6-471d-8fa3-1eb8c17d8d0b)|
| ```Iscaled = uint8(255 * double(I) ./ double(max(I(:))));```<br/>```rgbI = repmat(Iscaled, 1, 1, 3);```  | Create an grayscale image for each RGB channel (red, blue, green) |![image](https://github.com/user-attachments/assets/182a379f-aa6d-4a2d-9199-b0afa084fcdf)|
| ``` ```  |  ||
| ``` ```  |  ||
