function [structName]=save2matfast(filePath,duration,varargin)
% This code saves both the RGB and depth data in a .mat file
% Last modification: 21/11/2024

    path = filePath;
    
    video_fast=struct();
    switch nargin
        case 3
            
    end  
    
    scalingfactor=2;
    fps = 30;
    WIDTH=1280;
    HEIGHT=720;
    video_fast.fps=fps;
    % Connect with specific config
    try
        if ~exist("pipeline", "var")
            [pipeline, profile] = connectDepth(1,fps,WIDTH,HEIGHT); % Connect depth with high density and 15fps
    
            video_fast.intrinsics = profile.get_stream(realsense.stream.depth).as('video_stream_profile').get_intrinsics();

            % Initialize filters
            colorizer = realsense.colorizer();
            colorizer.set_option(realsense.option.color_scheme, 2);      
        end
        
        % Discard the first 10 frames
        for i = 1:10
            frames = pipeline.wait_for_frames();
        end

        % Processing frames in a loop
        for i = 1:fps*duration 
            % Wait for a new frame set
            fprintf("Getting frame %d/%d\n", i, fps*duration);
    
            frames = pipeline.wait_for_frames();
            
                   
            if ~isempty(frames)
                original_depth=frames.get_depth_frame();
                if i==1
                    t0=original_depth.get_timestamp();
                end
                color=frames.get_color_frame();

                % Colorize original depth frame
                colorized_original_depth=colorizer.colorize(original_depth);
    
                %Resize 2D depth frames
                img_original_depth=reshape(original_depth.get_data()',original_depth.get_width(),original_depth.get_height())';
                img_original_depth=img_original_depth(1:scalingfactor:end,1:scalingfactor:end,:);

                %Resize colorized frames
                img_colorized_depth=resize(colorized_original_depth);
                img_color=resize(color);
                                
                video_fast(i).original_depth=img_original_depth;
                video_fast(i).colorized_depth=img_colorized_depth;
                video_fast(i).color=img_color;
                video_fast(i).t=original_depth.get_timestamp-t0; % in ms
                
            end
        end
    
        pipeline.stop();
    
        testNum = 1;
        while exist(path+"/video_fast"+testNum+".mat", 'file')
            testNum = testNum+1;
        end
    
        if ~exist(path,"dir")
            mkdir(path)
        end
    
        structName=path+"/video_fast"+testNum;
        fprintf("Saving content to "+structName+".mat"+"...");
    
        save(structName+".mat","video_fast");
       
        fprintf("Content successfully saved\n");
        
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
    
   function frame_out=resize(frame_in)
        img = frame_in.get_data();
        height = frame_in.get_height();
        width = frame_in.get_width();
        img = permute(reshape(img', [], width, height), [3, 2, 1]);
        img=img(1:scalingfactor:end,1:scalingfactor:end,:);
        frame_out=img(:,:,1:3);
    end
end