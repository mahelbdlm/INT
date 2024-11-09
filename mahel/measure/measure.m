% Measure real world depth data
% Based on https://dev.intelrealsense.com/docs/rs-measure
% Last modification: 09/11/2024 15:30
%clear;
debug_mode = 0;
%Connect with default configuration

try
    if ~exist("pipeline","var")

        [pipeline, profile]=connectDepth(1); %Connect depth with high accuracy

        % Initialize filters
        colorizer = realsense.colorizer();
        colorizer.set_option(realsense.option.color_scheme, 2);
    
        % Decimation filter to reduce data
        decimation = realsense.decimation_filter();
        decimation.set_option(realsense.option.filter_magnitude, 2);
    
        % Transformations from and to Disparity domain
        depth2disparity = realsense.disparity_transform(true); % Depth to disparity
        disparity2depth = realsense.disparity_transform(false); % Disparity to depth
    
        % Spatial filter with edge-preserving and hole-filling
        spatial = realsense.spatial_filter();
        spatial.set_option(realsense.option.holes_fill, 5); % Fill all zero pixels
    
        % Temporal filter to reduce noise
        temporal = realsense.temporal_filter();
    
        % Align depth stream to color stream (or another specified stream)
        align_to = realsense.align(realsense.stream.depth);
    end
    for i = 1:10 % Discard the first 10 frames
        % Wait for a new frame set
        frames = pipeline.wait_for_frames();
    end

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

    % Processing frames in a loop (example)
    while ishandle(f)
        % Wait for a new frame set
        frames = pipeline.wait_for_frames();
        depth = frames.get_depth_frame();
        % Ensure frames are valid before processing
        if ~isempty(frames)
             % Align depth frame to other streams
            aligned_frames = align_to.process(frames);
    
            % Extract depth frame
            depth_frame = aligned_frames.get_depth_frame();
    
            % Apply decimation filter
            depth_frame = decimation.process(depth_frame);
    
            % Convert depth to disparity
            disparity_frame = depth2disparity.process(depth_frame);
    
            % Apply spatial and temporal filtering
            depth_frame = spatial.process(disparity_frame);
            depth_frame = temporal.process(depth_frame);
    
            % Convert back to depth if needed
            depth_frame = disparity2depth.process(depth_frame);
    
            % Colorize depth frame
            colorized_depth = colorizer.colorize(depth_frame);

            % Get the depth stream from the profile
            depthStream = profile.get_stream(realsense.stream.depth);

            
            % Ensure depth stream is available
           if ~isempty(depthStream)
                % Cast the stream to video_stream_profile
                depthProfile = depthStream.as('video_stream_profile');
                
                % Get the intrinsic parameters for the depth stream
                intrinsics = depthProfile.get_intrinsics();
                
                % Display the intrinsics
                if debug_mode==1
                    disp(intrinsics);
                end

                 % Process 3D distance between two pixels
                 % Range: [0, 0] to [640/2, 480/2] so [320, 240]
                %u = [200, 200]; % Example pixel coordinates
                %v = [50, 239]; % Example pixel coordinates

                u = [207, 311]; % Example pixel coordinates
                v = [416, 311]; % Example pixel coordinates
                
                distance_3d = dist_3d(intrinsics, depth_frame, u, v);
                fprintf("Distance: %f\n", distance_3d);
                
                % Display the colorized frame (optional)
                %imshow(colorized_frame);
        
                % Display colorized depth
                img = colorized_depth.get_data();
                height = depth.get_height();
                width=depth.get_width();

                % % %Query the distance from the camera to the object in the center of the image
                depth_frame_colorized=permute(reshape(colorizer.colorize(depth).get_data()',[3,width,height]),[3 2 1]);
                imshow(depth_frame_colorized,[]);
                hold on;
                
                % Plot points at (u(1), u(2)) and (v(1), v(2)) on the image
                plot(u(1), u(2), 'ro', 'MarkerSize', 10);  % Red point for u
                plot(v(1), v(2), 'bo', 'MarkerSize', 10);  % Blue point for v
                hold off;
            else
                error('Depth stream not available in this profile!');
           end
        else
            error('No frames captured.');
        end
        pause(0.1);
    end
    
    % Stop streaming
    %pipeline.stop();
    %clear pipeline;
    %realsense.librealsense_mex('rs2::colorizer', 'new');
catch error
    clear f;
    if error.identifier=="MATLAB:UndefinedFunction"
       if contains(error.message, 'connectDepth') || contains(error.message, 'dist_3d')
        fprintf(2,"You must add the modules folder to the matlab path \n  =>Right click on module folder -> add to path -> Selected folder\n");
        else
            rethrow(error);
       end
    else
        rethrow(error);
    end
end

function close_window(~, ~)
    clear f;
    disp('Window closed.');
    delete(gcf);  % Close the GUI window
end