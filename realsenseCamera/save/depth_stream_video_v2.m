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
    frame = frame.setCameraParams("setDepthHighDensity");
    %frame = frame.setDefaultColor();
    %frame = frame.enableIntelFilters();
    
    %frame = frame.setOptimalSize();
    
    frame = frame.init(); % Initialize the frame class

    % Initialize filters
    

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

        [frame,depth,color] = frame.get_frame_aligned();

        imshowpair(depth,color,"montage");
    end
    
catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        fprintf(2, "The modules/class folder was not added to your matlab path.\nIt has now been added and the code execution was restarted.\n");
        addpath('modules');
        addpath('class');
        rethrow(error);
        %run(mfilename+".m");
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