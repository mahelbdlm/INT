<!-- To learn more about github md syntax, visit https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax -->

# MATLAB COMMANDS FOR 2D VISION
In this section, a list of usable functions for matlab will be displayed.

### To search
```xcorr2```

## Reading and Writing image files

| Action  | Matlab code |
| ------------- | ------------- |
| Read image  | ```I = imread("imgFile.jpg");```  |
| Show image  | ```imshow(A);```  |
| Show two images  | ```imshowpair(I,I2,"montage");```  |
| Show montage of multiple images  | ```montage({R,G,B});```  |

## Image dimensions, plane and values
| Action  | Matlab code | Notes |
| ------------- | ------------- | ------------- |
| Get image size  | ```sz = size(I);```  | Output: 600 400 3 (vertical * horizontal * planes) |
| Extract (single) R G or B plane  | ```R = I(:,:,2);```  | 1: Red, 2: Green, 3:Blue |
| Extract R G and B plane  | ```[R,G,B] = imsplit(I);```  |
| Get maximum value of plane  | ```Rmax = max(R,[],"all");```  |
| Get minimum value of plane  | ```Rmin = min(R,[],"all");```  | Values go from 0 to 255 |


## Image filters and histogram
| Action  | Matlab code |
| ------------- | ------------- |
| Convert image to grayscale  | ```gs = im2gray(I);```  |
| Show histogram | ```imhist(gs);```  |
| Automatically adjust contrast (gray scale image)  | ```gsAdj = imadjust(gs);```  |
| Automatically adjust contrast (color scaled)  | ```I2adj = imlocalbrighten(I2);```  |

## Threshold and binary extraction
| Action  | Matlab code | Notes |
| ------------- | ------------- | ------------- |
| Threshold 255/2  | ```BW = gsAdj > 255/2```  |
| Select threshold automatically   | ```BW = imbinarize(gsAdj);```  | Threshold is global |
| Select threshold automatically   | ```BWadapt = imbinarize(gsAdj, "adaptive");```  | Threshold is different for each region<br />Assumed foreground light and background dark |
| Select threshold automatically   | ```BWadapt = imbinarize(gsAdj,"adaptive","ForegroundPolarity","dark");```  | When foreground of interest is dark |

# Average Filtering
| Action  | Matlab code | Notes |
| ------------- | ------------- | ------------- |
| Create 3 by 3 average filter  | ```H = fspecial("average",3);```  |
| Apply filter  | ```gssmooth = imfilter(gs,H);```  | Default setting of imfilter sets pixels outside the image to zero |
| Apply filter  | ```gssmooth = imfilter(gs,H,"replicate");```  |  the "replicate" option uses pixel intensity values on the image border for pixels outside the image |

# Remove background of image
```matlab
I = imread("IMG_001.jpg");
gs = im2gray(I);
gs = imadjust(gs);
H = fspecial("average",3);
gs = imfilter(gs,H,"replicate");
BW = imbinarize(gs,"adaptive","ForegroundPolarity","dark");
```
| Action  | Matlab code | Notes |
| ------------- | ------------- | ------------- |
| Create Structuring Element  | ```SE = strel("disk",8);```  | Disk with radius 8px |
| Closing operation  | ```Ibg = imclose(gs,SE);```  | Emphasize White | 
| Open Image  | ```BWstripes = imopen(BW,SE);```  | Emphasize Dark text |
| Remove Background  | ```gsSub = Ibg - gs;```  |
| Invert black and white  | ```BWsub = ~imbinarize(gsSub);```  |
| Create a square Structuring Element  | ```SE = strel("rectangle",[3 25]);```  | height=3 pixels and width=25 pixels |
| Mostrar histograma   | ``````S = sum(BWstripes,2);plot(S);``````  |

# Datastore
| Action  | Matlab code | Notes |
| ------------- | ------------- | ------------- |
| Create image datastore  | ```ds = imageDatastore("testimages");```  | Create databse for a folder named testimages |
| Count number of files in db  | ```nFiles = numel(ds.Files);```  |
| Read _n_th image of db  | ```I = readimage(ds,n);```  |
| T  | ``` ```  |
| T  | ``` ```  |
| T  | ``` ```  |
| T  | ``` ```  |

Filtering DB image: 
```matlab
ds = imageDatastore("testimages");
nFiles = numel(ds.Files);
isReceipt = false(1,nFiles);
for k=1:nFiles
    I = readimage(ds,k);
    isReceipt(k) = classifyImage(I);
end
receiptFiles = ds.Files(isReceipt);
montage(receiptFiles);
```

<!--
| Action  | Matlab code | Notes |
| ------------- | ------------- | ------------- |
| T  | ``` ```  |
| T  | ``` ```  |
| T  | ``` ```  |
| T  | ``` ```  |
| T  | ``` ```  |
| T  | ``` ```  |
| T  | ``` ```  |
| T  | ``` ```  |
-->





