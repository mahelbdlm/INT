%Programa per grabar video (2d i depth) i guardar-lo...
% Make Pipeline object to manage streaming
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
colormap parula
% Main loop
video=struct();
for i = 1:fps*5 %5 seconds!!!
    %Obtain frames from a streaming device
    fs = pipe.wait_for_frames();
    depth=fs.get_depth_frame();
    color=fs.get_color_frame();
    depth_data=depth.get_data();
    depth_img=reshape(depth_data,[w,h]);
    color_data=color.get_data();
    color_img=permute(reshape(color_data,[3,wc,hc]),[3,2,1]);
    video(i).df=depth_img;
end

%  Stop streaming
pipe.stop();
save('video.mat',"video")