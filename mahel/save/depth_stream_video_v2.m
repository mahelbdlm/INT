% This code streams from the camera in both depth and rgb image and shows them in a montage. 
% This code uses the getFrames class, to rapidly switch from the camera to
% a stored file
% Last modification: 14/11/2024

clear;
close all;
%targetPath = "mahel/save_palet/test_jan"; % Path of the video file
                                               % Camera if you want to use
                                               % the camera

% Connect with default configuration
try
    frame = getFrames(); % The frames will be obtained using the camera
    %frame = frame.enableDebugMode();
    %frame = frame.setDepthHighAccuracy(); % Set the high accuracy for the camera
    %frame = frame.setDepthHighDensity(); 
    %frame = frame.setWidthAndHeight(640,480); % Set the high accuracy for the camera
    %frame = frame.setDefaultColor(); % Initialize camera with default color range
    
    frame = frame.init(); % Initialize the frame class

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
    while (ishandle(f) && frame.isActive)
        % Wait for a new frame set
        %disp("Getting frame");

        [frame,depth,color] = frame.get_frame_original();

        color_img_resized = imresize(color, [480, 640]);

        imshowpair(depth,color_img_resized,"montage");
    end
    
catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        if contains(error.message, 'connectDepth') || contains(error.message, 'getFrames')
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