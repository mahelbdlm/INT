% Very much based on Jan's detectEdge script
% Last modification: 23/11/2024

%THIS CODE IS STILL IN DEVELOPPMENT. IT IS NOT 100% FUNCTIONAL AND IS USED
%TO RUN SOME TESTS

clear;
close all;
targetPath = "mahel/save/test_time_25-Nov-2024"; % Path of the video file
% Camera if you want to use
% the camera

% Connect with default configuration
try

    frame = getFrames(targetPath,"jan"); % The frames will be obtained using the camera and mahel file format
    frame = frame.init(); % Initialize the frame class
    [frame,depth,color] = frame.get_frame_at_index(10); %125 to work

    grayImg = rgb2gray(color); % For color image


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
disp('Window closed');
delete(gcf);  % Close the GUI window
end