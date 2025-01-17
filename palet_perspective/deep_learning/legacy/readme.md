# Image segmenter app
The scripts in this folder use the Image Segmenter app from matlab to separate the foreground (the palet) from the background. This allows us to have better results when applying the edge detection algorithm. 

## Segment anything model
The segment anything model is an easy-to-use deep learning algorithm which aims at extracting a ROI (region of interest) from the backgroud. 
> [!IMPORTANT]
> This algorithm is really slow and takes about 15-30 seconds for an image. It will not be used in our case.

Using the image segmenter app and segment anything model of matlab, we can easily use deep learning to achieve our goals. 
<div align="center">
  <img width="60%" height="60%" src="https://github.com/user-attachments/assets/dd9ec519-ce54-4beb-b415-2ff87d505970"></img>
</div>
And the deep learning algorithm uses that information to segment the image
<div align="center">
  <img width="60%" height="60%" src="https://github.com/user-attachments/assets/52a2e29f-2976-4f92-8ec8-baeee6ebf362"></img>
</div>
Then, we can use the active contours tool to refine the image: 

| Method  | Iterations | Image result |
| ------------- | ------------- | ------------- |
|Initial image||<div align="center"><img width="60%" height="60%" src="https://github.com/user-attachments/assets/7c1745a3-1347-4314-97c4-0e87890d6938"></img></div>|
|Resion based|100|<div align="center"><img width="60%" height="60%" src="https://github.com/user-attachments/assets/6d9c2c9f-d183-4374-bc76-d3385e332ec4"></img></div>|
|Edge based|100|<div align="center"><img width="60%" height="60%" src="https://github.com/user-attachments/assets/f76e5214-f939-43be-8f62-ff8a66718c25"></img></div>|
|Edge based|200|<div align="center"><img width="60%" height="60%" src="https://github.com/user-attachments/assets/a31bd490-43b7-4fc5-9394-fedcd50291e8"></img></div>|

Exporting the script and running it, we obtain: 
![image](https://github.com/user-attachments/assets/868fd7c2-aebe-4539-b90e-ae050cbedb08)

Applying the edge canny filter: 

<div align="center">
  <img width="60%" height="60%" src="https://github.com/user-attachments/assets/b162b4fb-2a01-426f-87e0-42057fe21215"></img>
</div>

Applying hough transform: 
<div align="center">
  <img width="60%" height="60%" src="https://github.com/user-attachments/assets/22d0fd89-a8e7-45a5-9b09-bcf8ad50b5db"></img>
</div>
