function [dist12]=measure_3d_dist(P1,P2,I) 
%MEASURE Measure the 3d distance between two pixels P1 and P2
%
% P1 and P2 are 1x2 matrices containing the (row=hpos,column=wpos) of the pixels we
%want to measure. 
% 
% I is the 2D depth_frame from where we get the depth value of the pixels we want
% to measure across. Make shure that I is indeed a depth frame (2D matrix)
% and not a colorized_depth_frame (3D matrix)
% 
% It is assumed that we are using a 435i camera and using a 640*480 pixel 
% resolution for the depth frames, thus: the baseline B=5cm and the 
% horizontal and vertical FOV are HFOV=75º VFOV=62º

    % Baseline = 50mm, distance between two cameras
    B=50;
    % Horitzontal field of view
    HFOV=75*pi/180;
    % Vertical field of view
    VFOV=62*pi/180;

% Check that I is a valid 2D matrix
    [height,width,check_is2dMatrix]=size(I);
    if ~and(isnumeric(I),check_is2dMatrix==1)
        error('Make shure that I is indeed a depth frame (2D matrix) and not a colorized_depth_frame (3D matrix)');
    end
    I=double(I);
% Check that P1 and P2 are within the image
    hpos1=P1(1);wpos1=P1(2);
    hpos2=P2(1);wpos2=P2(2);
    try
        depth1=I(hpos1,wpos1);
        depth2=I(hpos2,wpos2);
    catch
        error('P1 or P2 out of range...Make shure that P1 and P2 are valid points of the image I!');
    end
% See 4.4 Depth Field of View at Distance (Z) from the 435i datasheet https://www.intelrealsense.com/download/21345/?tmstv=1697035582
    w1=-2*(wpos1-width/2)*(depth1*tan(HFOV/2)-B)/width;
    if(wpos1>=width/2)
        w1=-2*(wpos1-width/2)*(depth1*tan(HFOV/2))/width;
    end
    w2=2*(wpos2-width/2)*(depth2*tan(HFOV/2)-B)/width;
    if(wpos2>=width/2)
        w2=2*(wpos2-width/2)*(depth2*tan(HFOV/2))/width;
    end
    dist12x=(HFOV/VFOV)*(w1+w2);
    dist12y=(VFOV/HFOV)*2*(-depth1*(hpos1-height/2)+depth2*(hpos2-height/2))*tan(HFOV/2)/height;
    dist12=hypot(hypot(dist12x,dist12y),abs((depth1)-(depth2)))/1000;%in meters!
end