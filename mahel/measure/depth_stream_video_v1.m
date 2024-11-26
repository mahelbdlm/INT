% This code streams from the camera in both depth and rgb image and shows them in a montage. 
% It allows a better visualization of both what the depth camera sees and what the rgb camera sees.
% Note that the RGB data is reshaped to correspond to the sizes of the depth image, and would in reality be much more detailed.
% Last modification: 11/11/2024

clear f;
close all;

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
        figWidth = 800;
        figHeight = 600;
        
        % Calculate the position for centering
        figX = (screenSize(3) - figWidth) / 2;
        figY = (screenSize(4) - figHeight) / 2;
        
        % Create the centered figure
        f = figure('Name', 'RealSense Depth Measurement', 'NumberTitle', 'off', ...
                   'Position', [figX, figY, figWidth, figHeight], 'CloseRequestFcn', @close_window);

        % Variables to store points and distance text
        points = [];
        distance_texts = [];
    end

    % Processing frames in a loop
    while ishandle(f)
        % Wait for a new frame set
        disp("Getting frame");

        frames = pipeline.wait_for_frames();
        depth = frames.get_depth_frame();
        
        color=frames.get_color_frame();
        
        
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
            
            %Treat the colorized image
            wc=color.get_width();
            hc=color.get_height();
            
            color_data=color.get_data();
            % Reshape color data as RGBA (4 channels) format
            color_img_rgba = permute(reshape(color_data, [4, wc, hc]), [3, 2, 1]);
            
            % Discard the alpha channel to keep only RGB
            color_img = color_img_rgba(:, :, 1:3);
            
            % Display the RGB image (debug)
            %imshow(color_img);
            %color_img_resized = imresize(color_img, [480, 640]);

            imshowpair(depth_frame_colorized,color_img,"montage");
            
        end
        pause(0.1);
    end
    
catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        if contains(error.message, 'connectDepth') || contains(error.message, 'dist_3d')
            fprintf(2, "The modules folder was not added to your matlab path.\nIt has now been added, you just need to rerun the code.\n");
            addpath('modules');
            %addpath(genpath('modules')) %Add Folder and Its Subfolders to Search Path
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
    disp('Window closed');
    delete(gcf);  % Close the GUI window
end