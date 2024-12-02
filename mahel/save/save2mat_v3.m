% This code is deprecated and should not be used.



% This code saves both the RGB and depth data in a .mat file
% Last modification: 21/11/2024
clear;
close all;

targetPath = "mahel/save/"; %Target path (respect to INT folder)
folderName = "europeo";
nbFrames = 150; % Number of frames to save
distanceGroundPalet = 0.14; %14 cm

showpair=1;

saveFiles = 1; % 1 to save files, 0 to discard the saving process



camera_params = struct();
video_depth=struct();
video_color=struct();


try
    % Calculate the path based on the current folder
    path = checkPath(targetPath);

    frame = getFrames();
    frame = frame.init();
    camera_params = frame.get_intrinsics(); % Get the camera intrinsics for 3D distance calculation
    camera_params.depth_scale = frame.distance.depthScale; % Get the depth scale from the camera
    camera_params.version = "mahelv3";
    camera_params.align_to_color=1;

    % Processing frames in a loop
    for i = 1:nbFrames
        % Wait for a new frame set
        fprintf("Getting frame %d/%d\n", i, nbFrames);

        [frame,depthFrame,depth,color] = frame.get_frame_aligned();

        if i==1
            t0=depthFrame.get_timestamp();
        end

        video_depth(i).depth = depth;
        video_depth(i).t=depthFrame.get_timestamp()-t0;

        video_color(i).color = color;
        video_color(i).t=depthFrame.get_timestamp()-t0;


        if showpair==1
            depthColorized = permute(reshape(frame.colorizer.colorize(depthFrame).get_data()', [3, depthFrame.get_width(), depthFrame.get_height()]), [3, 2, 1]);
            imshowpair(color, depthColorized);
        end
    end

    frame.stop();

    if saveFiles == 1
        testNum = 1;
        while exist(path+folderName+testNum, 'dir')
            testNum = testNum+1;
        end

        mkdir(path+folderName+testNum);

        fprintf("Saving content to "+path+folderName+testNum+"...\n");

        save(path+folderName+testNum+'/camera_params.mat',"camera_params");


        save(path+folderName+testNum+'/video_depth.mat',"video_depth");

        save(path+folderName+testNum+'/video_color.mat',"video_color");

        fprintf("Content successfully saved\n");
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
disp('Window closed');
delete(gcf);  % Close the GUI window
end

%  color = load("mahel/video_stable/europeo1/video_color.mat");
%  video_color = struct();
%  video_color = color.video_color(1:150);
%  save('mahel/video_stable/europeo1/video_color2.mat',"video_color");