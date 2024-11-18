% Measure real-world depth data and allow pixel selection for distance measurement
% Last modification: 09/11/2024 18:05
% This code is now deprecated and will be updated at https://github.com/mahelbdlm/INT/blob/main/jan/select_2_pixels.m 

%clear;

% Connect with default configuration
try
    if ~exist("pipeline", "var")
        [pipeline, profile] = connectDepth(1); % Connect depth with high accuracy

        % Initialize filters
        colorizer = realsense.colorizer();
        colorizer.set_option(realsense.option.color_scheme, 2);
    
        decimation = realsense.decimation_filter();
        decimation.set_option(realsense.option.filter_magnitude, 2);
    
        depth2disparity = realsense.disparity_transform(true); % Depth to disparity
        disparity2depth = realsense.disparity_transform(false); % Disparity to depth
    
        spatial = realsense.spatial_filter();
        spatial.set_option(realsense.option.holes_fill, 5); % Fill all zero pixels
    
        temporal = realsense.temporal_filter();
    
        align_to = realsense.align(realsense.stream.depth);
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
            aligned_frames = align_to.process(frames);
            depth_frame = aligned_frames.get_depth_frame();
    
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
            height = depth.get_height();
            width = depth.get_width();
            depth_frame_colorized = permute(reshape(colorizer.colorize(depth).get_data()', [3, width, height]), [3, 2, 1]);
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
            [x, y] = ginput(2);
            u = round([x(1), y(1)]); % First point
            v = round([x(2), y(2)]); % Second point
            
            % Get frame dimensions
            frame_width = depth.get_width();
            frame_height = depth.get_height();
            
            % Ensure points are within valid range
            if u(1) < 1 || u(1) > frame_width || u(2) < 1 || u(2) > frame_height || ...
               v(1) < 1 || v(1) > frame_width || v(2) < 1 || v(2) > frame_height
                error('Selected points are out of the valid range of the depth frame.');
            end
            hold on;
                % Plot points at (u(1), u(2)) and (v(1), v(2)) on the image
                plot(u(1), u(2), 'ro', 'MarkerSize', 10);  % Red point for u
                plot(v(1), v(2), 'bo', 'MarkerSize', 10);  % Blue point for v
            hold off;
            % Calculate 3D distance between selected points
            distance_3d = dist_3d(intrinsics, depth_frame, u, v);
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
        if contains(error.message, 'connectDepth') || contains(error.message, 'dist_3d')
            fprintf(2, "You must add the modules folder to the MATLAB path\n  => Right-click on module folder -> add to path -> Selected folder\n");
        else
            rethrow(error);
        end
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
