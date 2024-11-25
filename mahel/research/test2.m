%Programa per grabar video (2d i depth) i guardar-lo...
% Make Pipeline object to manage streaming

pipe = realsense.pipeline();

% Start streaming on an arbitrary camera with default settings
profile = pipe.start();

fs = pipe.wait_for_frames();
depth=fs.get_depth_frame();
color=fs.get_color_frame();
profile=fs.get_profile();
fps=profile.fps();
wc=color.get_width();
hc=color.get_height();
w=depth.get_width();
h=depth.get_height();

colormap parula;


