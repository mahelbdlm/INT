% Measure real-world depth data and allow pixel selection for distance measurement
% Last modification: 09/11/2024 18:05
% This code is now deprecated and will be updated at https://github.com/mahelbdlm/INT/blob/main/jan/select_2_pixels.m 


clear f;

% Connect with default configuration
try
    if ~exist("pipeline", "var")
        [pipeline, profile] = connectDepth(); % Connect depth with high accuracy

        % Initialize filters
        colorizer = realsense.colorizer();
        colorizer.set_option(realsense.option.color_scheme, 2);
    
        decimationfactor=2;
        decimation = realsense.decimation_filter();
        decimation.set_option(realsense.option.filter_magnitude, decimationfactor);
    
        depth2disparity = realsense.disparity_transform(true); % Depth to disparity
        disparity2depth = realsense.disparity_transform(false); % Disparity to depth
    
        spatial = realsense.spatial_filter();
        spatial.set_option(realsense.option.holes_fill, 5); % Fill all zero pixels
    
        temporal = realsense.temporal_filter();
    
    end
    
    % Discard the first 10 frames
    for i = 1:10
        frames = pipeline.wait_for_frames();
    end

    % Create figure if it doesn't exist
    if ~exist("f", "var")
        screenSize = get(0, 'ScreenSize');
        % Define the figure dimensions
        figWidth = 300;
        figHeight = 150;
        
        % Calculate the position for centering
        figX = (screenSize(3) - figWidth) / 2;
        figY = (screenSize(4) - figHeight) / 2;
        
        % Create the centered figure
        f = figure('Name', 'RealSense Depth Measurement', 'NumberTitle', 'off', ...
                   'Position', [figX, figY, figWidth, figHeight], 'CloseRequestFcn', @close_window);
    end

    % Processing frames in a loop
    while ishandle(f)
        % Wait for a new frame set
        frames = pipeline.wait_for_frames();
        depth = frames.get_depth_frame();
        
        if ~isempty(frames)
            depth_frame = frames.get_depth_frame();
    
            % Apply filters
            depth_frame = decimation.process(depth_frame);
            disparity_frame = depth2disparity.process(depth_frame);
            depth_frame = spatial.process(disparity_frame);
            depth_frame = temporal.process(depth_frame);
            depth_frame = disparity2depth.process(depth_frame);
            
            % Colorize depth frame
            colorized_depth = colorizer.colorize(depth_frame);
            
            % Display the colorized depth frame
            img = colorized_depth.get_data();
            height = depth.get_height()/decimationfactor;
            width = depth.get_width()/decimationfactor;
            depth_frame_colorized = permute(reshape(img', [3, width, height]), [3, 2, 1]);
            imshow(depth_frame_colorized, []);
            title('Select two points to measure distance');

            % Get the depth stream and intrinsics
            depthStream = profile.get_stream(realsense.stream.depth);
            if isempty(depthStream)
                error('Depth stream not available in this profile!');
            end
            depthProfile = depthStream.as('video_stream_profile');
            intrinsics = depthProfile.get_intrinsics();

            % Prompt user to select two points and ensure they are within valid range
            % We will work with u/v=[row column],that's why x and y are
            % swaped
            [x, y] = ginput(2);
            u = round([y(1), x(1)]); % First point
            v = round([y(2), x(2)]); % Second point
            
            % Get frame and frame dimensions
            frame_width = width;
            frame_height = height;
            depth_frame_img =reshape(depth_frame.get_data()', [width, height])';
            
            % Ensure points are within valid range
            if u(1) < 1 || u(1) > frame_height || u(2) < 1 || u(2) > frame_width || ...
               v(1) < 1 || v(1) > frame_height || v(2) < 1 || v(2) > frame_width
                error('Selected points are out of the valid range of the depth frame.');
            end
            hold on;
                % Plot points at (u(2), u(1)) and (v(2), v(1)) on the image
                plot(u(2), u(1), 'ro', 'MarkerSize', 10);  % Red point for u
                plot(v(2), v(1), 'bo', 'MarkerSize', 10);  % Blue point for v
            hold off;
            % Calculate 3D distance between selected points
            distance_3d = measure_3d_dist(u, v,depth_frame_img);
            fprintf('3D distance between selected points: %.2f meters\n', distance_3d);
            return;

        else
            error('No frames captured.');
        end
        pause(0.1);
    end
    
catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        fprintf(2, "The modules/class folder was not added to your matlab path.\nIt has now been added and the code execution was restarted.\n");
        addpath('modules');
        addpath('class');
        rethrow(error);
    elseif error.identifier == "MATLAB:ginput:FigureDeletionPause"
            fprintf(2, "Figure was closed before selecting points\n");
            clear f;
    else
        clear f;
        fprintf("Unknown error:\n");
        rethrow(error);
    end
end

% Callback function to stop the pipeline and close the window
function close_window(~, ~)
    clear f;
    disp('Window closed. Stopping the pipeline.');
    delete(gcf);  % Close the GUI window
end