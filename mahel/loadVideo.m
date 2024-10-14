% Import video file and work with it
%vid_color= load("video_color.mat");
%vid_depth= load("video_depth.mat");

imageArr=[];
imgindex=1;
numberImagesHorizontal = 4;
for i=1:10:150
    rotated_img = imrotate(vid_depth.video_depth(i).df, -90);
    img_colormap = ind2rgb(gray2ind(mat2gray(rotated_img), 256), parula(256));
    imageArr{imgindex} = vid_color.video_color(i).df;
    imageArr{imgindex+1} = img_colormap;
    imgindex=imgindex+2;
end

montage(imageArr,'Size', [round(imgindex/numberImagesHorizontal)-1, numberImagesHorizontal]);
