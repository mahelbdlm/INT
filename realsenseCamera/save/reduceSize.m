% This scripts reduces the number of frames of a video if it has too many
% Optimized for mahelv3

vid_path = "mahel/video_stable/europeo6/";
maxFrame = 130;

 color = load(vid_path+"video_color.mat");
 video_color = struct();
 video_color = color.video_color(1:maxFrame);
 save(vid_path+"video_color2.mat","video_color");

 depth = load(vid_path+"video_depth.mat");
 video_depth = struct();
 video_depth = depth.video_depth(1:maxFrame);
 save(vid_path+"video_depth2.mat","video_depth");

 color2 = load(vid_path+"video_color2.mat");
 depth2 = load(vid_path+"video_depth2.mat");