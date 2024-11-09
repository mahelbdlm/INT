% Set up the RealSense pipeline
pipeline=connectDepth();

% Get the depth sensor and set the preset to high accuracy
sensor = profile.get_device().first(realsense.camera_info.depth_sensor);
sensor.set_option(realsense.option.visual_preset, realsense.visual_preset.high_accuracy);

% Initialize filters
color_map = realsense.colorizer();
color_map.set_option(realsense.option.color_scheme, 2); % Black-to-white color scheme

decimation = realsense.decimation_filter();
decimation.set_option(realsense.option.filter_magnitude, 2);

depth2disparity = realsense.disparity_transform();
disparity2depth = realsense.disparity_transform(false);

spatial_filter = realsense.spatial_filter();
spatial_filter.set_option(realsense.option.holes_fill, 5);

temporal_filter = realsense.temporal_filter();

align = realsense.align(realsense.stream.depth); % Align to depth

% Main loop for processing frames
while true
    % Wait for the next frame
    frames = pipeline.wait_for_frames();
    
    % Align the frames to depth
    aligned_frames = align.process(frames);
    
    % Get the depth frame
    depth_frame = aligned_frames.get_depth_frame();
    
    % Apply decimation filter
    depth_frame = decimation.process(depth_frame);
