# Image segmenter app
## Segment anything model
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
|Initial image||![image](https://github.com/user-attachments/assets/7c1745a3-1347-4314-97c4-0e87890d6938)|
|Resion based|100|![image](https://github.com/user-attachments/assets/6d9c2c9f-d183-4374-bc76-d3385e332ec4)|
|Edge based|100|![image](https://github.com/user-attachments/assets/f76e5214-f939-43be-8f62-ff8a66718c25)|
|Edge based|200|![image](https://github.com/user-attachments/assets/a31bd490-43b7-4fc5-9394-fedcd50291e8)|

Exporting the script and running it, we obtain: 
<div align="center">
  <img width="60%" height="60%" src="https://github.com/user-attachments/assets/868fd7c2-aebe-4539-b90e-ae050cbedb08"></img>
</div>
