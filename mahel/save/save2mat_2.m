% This code saves both the RGB and depth data in a .mat file
% Last modification: 12/11/2024
clear;
close all;

path = "mahel/save/";
folderName = "palet_con_rodillos_t2";

saveFiles = 0;

video_depth_original=struct();
video_depth_filtered=struct();
video_color_original=struct();
video_color_aligned=struct();

fps = 30; %Default with connectDepth
% Connect with default configuration
try
    if ~exist("pipeline", "var")
        [pipeline, profile] = connectDepth(); % Connect depth with high accuracy

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
    
        align_to_depth = realsense.align(realsense.stream.depth);
        align_to_color = realsense.align(realsense.stream.color);
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
    for i = 1:fps*5 %5 sec
        % Wait for a new frame set
        fprintf("Getting frame %d/%d\n", i, fps*5);

        frames = pipeline.wait_for_frames();

        depth_frame = frames.get_depth_frame();
        color_frame = frames.get_color_frame();
        
        
        if ~isempty(frames)
            aligned_depth_frames = align_to_depth.process(frames);
            aligned_color_frames = align_to_color.process(frames);
            
            depth_align_depth = aligned_depth_frames.get_depth_frame();
            color_align_depth = aligned_depth_frames.get_color_frame();
            
            depth_align_color = aligned_color_frames.get_depth_frame();
            color_align_color = aligned_color_frames.get_color_frame();
    
            % Apply filters
            %depth_frame = decimation.process(depth_frame);
            %disparity_frame = depth2disparity.process(depth_frame);
            %depth_frame = spatial.process(disparity_frame);
            %depth_frame = temporal.process(depth_frame);
            %depth_frame = disparity2depth.process(depth_frame);
    
            % Colorize depth frame
            %colorized_depth = colorizer.colorize(depth_frame);
            
            % Display the colorized depth frame
            %img = colorized_depth.get_data();
            %height = depth.get_height();
            %width = depth.get_width();
            %depth_frame_colorized = permute(reshape(colorizer.colorize(depth).get_data()', [3, width, height]), [3, 2, 1]);
            
            %color_data_aligned=color_frame_aligned.get_data();


            %Treat depth frame original
            depth_h = depth_frame.get_height();
            depth_w = depth_frame.get_width();
            depth_frame_original = permute(reshape(colorizer.colorize(depth_frame).get_data()', [3, depth_w, depth_h]), [3, 2, 1]);

            %Treat depth frame aligned
            depth_aligned_h = depth_frame.get_height();
            depth_aligned_w = depth_frame.get_width();
            depth_frame_original = permute(reshape(colorizer.colorize(depth_frame).get_data()', [3, depth_w, depth_h]), [3, 2, 1]);


            %Treat the colorized image
            color_w=color_frame.get_width();
            color_h=color_frame.get_height();
            color_img_rgba = permute(reshape(color_frame.get_data(),[],color_w,color_h), [3, 2, 1]);
            color_img_rgb = color_img_rgba(:, :, 1:3);
            

            imshowpair(depth_frame_original,color_img_rgb,"montage");

            if saveFiles == 1
            video_depth_original(i).df=reshape(depth.get_data(),[width,height]);
            video_depth_filtered(i).df=depth_frame_colorized;
            video_color_original(i).df=color_img;
            video_color_aligned(i).df=color_img;
            end
            
        end
        %pause(0.1);
    end

    pipeline.stop();

    if saveFiles == 1
        testNum = 1;
        while exist(path+folderName+testNum, 'dir')
            testNum = testNum+1;
        end
    
        mkdir(path+folderName+testNum);
    
        fprintf("Saving content to "+path+folderName+testNum+"...");
    
        save(path+folderName+testNum+'/video_depth_original.mat',"video_depth_original");
        save(path+folderName+testNum+'/video_depth_filtered.mat',"video_depth_filtered");
        save(path+folderName+testNum+'/video_color_original.mat',"video_color_original");
        save(path+folderName+testNum+'/video_color_aligned.mat',"video_color_aligned");
    
        fprintf("Content successfully saved\n");
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