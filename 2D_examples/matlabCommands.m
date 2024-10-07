I = imread("imgFile.jpg"); % Get image
imshow(A); % show image
imshowpair(I,I2,"montage"); %Show images in montage

% Save image to png format and reload:
imwrite(I, "myImage.png"); % Save image
Inew = imread("myImage.png"); % Read image
imshow(Inew); % show image

%Get image size
sz = size(I);
% => 600 400 3 <= el 3 es por RGB

% Extract R G or B plane of the photo
R = I(:,:,2); %1: Red, 2: Green, 3:Blue

% Get maximum value of a plane (from 0 to 255)
Rmax = max(R,[],"all");
Rmin = min(R,[],"all");

% Divide image by R G B and show them in montage:
[R,G,B] = imsplit(I);
montage({R,G,B});

gs = im2gray(I);

%Show histogram
imhist(gs)
