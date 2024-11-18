% This code saves both the RGB and depth data in a .mat file
% Last modification: 12/11/2024
clear;
close all;

targetPath = "mahel/detect_missing_part/"; %Target path (respect to INT folder)
folderName = "missing_splinter";
nbFrames = 150; % Number of frames to save

plotResult = 0;

save_video_depth_original      = 1;
save_video_depth_alignto_depth = 1;
save_video_depth_alignto_color = 1;
save_video_color_original      = 1;
save_video_color_alignto_depth = 1;
save_video_color_alignto_color = 1;

saveFiles = 1; % 1 to save files, 0 to discard the saving process




video_depth_original=struct();
video_depth_alignto_depth=struct();
video_depth_alignto_color=struct();
video_color_original=struct();
video_color_alignto_depth=struct();
video_color_alignto_color=struct();


try
    % Calculate the path based on the current folder
    path = checkPath(targetPath);
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
    
   
    % Processing frames in a loop
    for i = 1:nbFrames
        % Wait for a new frame set
        fprintf("Getting frame %d/%d\n", i, nbFrames);

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

            if save_video_depth_original==1
            %Treat depth frame original
            depth_h = depth_frame.get_height();
            depth_w = depth_frame.get_width();
            depth_frame_original = permute(reshape(colorizer.colorize(depth_frame).get_data()', [3, depth_w, depth_h]), [3, 2, 1]);
            video_depth_original.df(i) = depth_frame_original;
            end

            if save_video_depth_alignto_depth==1
            %Treat depth frame from align_to depth
            depth_aligned_depth_h = depth_align_depth.get_height();
            depth_aligned_depth_w = depth_align_depth.get_width();
            depth_frame_aligned_depth = permute(reshape(colorizer.colorize(depth_align_depth).get_data()', [3, depth_aligned_depth_w, depth_aligned_depth_h]), [3, 2, 1]);
            video_depth_alignto_depth.df(i) = depth_frame_aligned_depth;
            end

            if save_video_depth_alignto_color==1
            %Treat depth frame from align_to color
            depth_aligned_color_h = depth_align_color.get_height();
            depth_aligned_color_w = depth_align_color.get_width();
            depth_frame_aligned_color = permute(reshape(colorizer.colorize(depth_align_color).get_data()', [3, depth_aligned_color_w, depth_aligned_color_h]), [3, 2, 1]);
            video_depth_alignto_color.df(i) = depth_frame_aligned_color;
            end

            if save_video_color_original==1
            %Treat the colorized image
            color_w=color_frame.get_width();
            color_h=color_frame.get_height();
            color_original_rgba = permute(reshape(color_frame.get_data(),[],color_w,color_h), [3, 2, 1]);
            color_original_rgb = color_original_rgba(:, :, 1:3);
            video_color_original.df(i) = color_original_rgb;
            end

            if save_video_color_alignto_depth==1
             %Treat the colorized image aligned depth
            color_aligned_depth_w=color_align_depth.get_width();
            color_aligned_depth_h=color_align_depth.get_height();
            color_aligned_depth_rgba = permute(reshape(color_align_depth.get_data(),[],color_aligned_depth_w,color_aligned_depth_h), [3, 2, 1]);
            color_aligned_depth_rgb = color_aligned_depth_rgba(:, :, 1:3);
            video_color_alignto_depth.df(i) = color_aligned_depth_rgb;
            end

            if save_video_color_alignto_color==1
             %Treat the colorized image aligned color
            color_aligned_color_w=color_align_color.get_width();
            color_aligned_color_h=color_align_color.get_height();
            color_aligned_color_rgba = permute(reshape(color_align_color.get_data(),[],color_aligned_color_w,color_aligned_color_h), [3, 2, 1]);
            color_aligned_color_rgb = color_aligned_depth_rgba(:, :, 1:3);
            video_color_alignto_color.df(i) = color_aligned_color_rgb;
            end
           
            if plotResult==1
            subplot(2, 3, 1);
            imshow(depth_frame_original,[]);
            title('Depth Frame Original');
            drawnow;
            subplot(2, 3, 2);
            imshow(depth_frame_aligned_depth,[]);
            title('Depth Aligned Depth');
            drawnow;
            subplot(2, 3, 3); 
            imshow(depth_frame_aligned_color,[]);
            title('Depth Aligned Color');
            drawnow;
            subplot(2, 3, 4); 
            imshow(color_original_rgb);
            title('Color original');
            drawnow;
            subplot(2, 3, 5); 
            imshow(color_aligned_depth_rgb);
            title('Color aligned depth');
            drawnow;
            subplot(2, 3, 6); 
            imshow(color_aligned_color_rgb,[]);
            title('Color aligned color');
            drawnow;
            end
            %imshowpair(depth_frame_original,color_img_rgb,"montage");
            
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
    
        fprintf("Saving content to "+path+folderName+testNum+"...\n");

        if save_video_depth_original==1
            save(path+folderName+testNum+'/video_depth_original.mat',"video_depth_original");
        end

        if save_video_depth_alignto_depth==1
            save(path+folderName+testNum+'/video_depth_alignto_depth.mat',"video_depth_alignto_depth");
        end

        if save_video_depth_alignto_color==1
            save(path+folderName+testNum+'/video_depth_alignto_color.mat',"video_depth_alignto_color");
        end

        if save_video_color_original==1
            save(path+folderName+testNum+'/video_color_original.mat',"video_color_original");
        end

        if save_video_color_alignto_depth==1
            save(path+folderName+testNum+'/video_color_alignto_depth.mat',"video_color_alignto_depth");
        end      
        
        if save_video_color_alignto_color==1
            save(path+folderName+testNum+'/video_color_alignto_color.mat',"video_color_alignto_color");
        end

        fprintf("Content successfully saved\n");
    end
catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        if contains(error.message, 'connectDepth') || contains(error.message, 'dist_3d') || contains(error.message, 'checkPath')
            fprintf(2, "The modules folder was not added to your matlab path.\nIt has now been added, you just need to rerun the code.\n");
            addpath('modules');
            %addpath(genpath('modules')) %Add Folder and Its Subfolders to Search Path
        else
            fprintf("Unknown error:\n");
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