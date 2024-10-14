%Programa per grabar video (2d i depth) i guardar-lo...
% Make Pipeline object to manage streaming

distanceToPalet = 125; %cm

pipe = realsense.pipeline();

% Start streaming on an arbitrary camera with default settings
profile = pipe.start();

for i=0:10
    %discard first frames and obtain info
    fs = pipe.wait_for_frames();
    depth=fs.get_depth_frame();
    color=fs.get_color_frame();
    profile=fs.get_profile();
    fps=profile.fps();
    wc=color.get_width();
    hc=color.get_height();
    w=depth.get_width();
    h=depth.get_height();
    
end
% Main loop
video_depth=struct();
video_color=struct();

video_depth.distance = distanceToPalet;
video_depth.distance = distanceToPalet;


for i = 1:fps*5 %5 seconds!!!
    %Obtain frames from a streaming device
    fs = pipe.wait_for_frames();
    depth=fs.get_depth_frame();
    color=fs.get_color_frame();
    depth_data=depth.get_data();
    depth_img=reshape(depth_data,[w,h]);
    color_data=color.get_data();
    color_img=permute(reshape(color_data,[3,wc,hc]),[3,2,1]);
    video_depth(i).df=depth_img;
    video_color(i).df=color_img;
end

%  Stop streaming
pipe.stop();
save('video_depth_2.mat',"video_depth")
save('video_color_2.mat',"video_color")

%imshow(video_color(100).df);

%rotated_img = imrotate(video_depth(100).df, -90);
%imshow(rotated_img,[])
%colomap parula;