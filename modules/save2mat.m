% @author: Jan
function [structName]=save2mat(filePath,duration,varargin)
% This code saves both the RGB and depth data in a .mat file
% Last modification: 21/11/2024

    path = filePath;
    
    intel_filters=false;
    medfilt=false;
    video=struct();
    switch nargin
        case 4
            if(strcmpi(varargin{1},"medfilt"))
                intel_filters=false;
                medfilt=true;
            end
    end  
    
    fps = 30; %Default with connectDepth
    video.fps=fps;
    % Connect with default configuration
    try
        if ~exist("pipeline", "var")
            [pipeline, ~] = connectDepth(1);
    
            % Initialize filters
            colorizer = realsense.colorizer();
            colorizer.set_option(realsense.option.color_scheme, 2);
        
            if intel_filters
                decimationfactor=2;
                decimation = realsense.decimation_filter();
                decimation.set_option(realsense.option.filter_magnitude,decimationfactor);
            
                depth2disparity = realsense.disparity_transform(true); % Depth to disparity
                disparity2depth = realsense.disparity_transform(false); % Disparity to depth
            
                spatial = realsense.spatial_filter();
                spatial.set_option(realsense.option.holes_fill, 5); % Fill all zero pixels
            
                temporal = realsense.temporal_filter();
            end
        
            align_to = realsense.align(realsense.stream.color);
        end
        
        % Discard the first 10 frames
        for i = 1:10
            frames = pipeline.wait_for_frames();
        end
      
        % Processing frames in a loop
        for i = 1:fps*duration %5 sec
            % Wait for a new frame set
            fprintf("Getting frame %d/%d\n", i, fps*duration);
    
            frames = pipeline.wait_for_frames();
                   
            if ~isempty(frames)
                aligned_frames = align_to.process(frames);
                original_depth=frames.get_depth_frame();
                if i==1
                    t0=original_depth.get_timestamp();
                end
            
                aligned_depth = aligned_frames.get_depth_frame();
                color= frames.get_color_frame();
        
                if intel_filters
                    %Apply filters to  aligned_depth_frames
                    filtered_aligned_depth_frame=depth_filters(aligned_depth,decimation,depth2disparity,spatial,temporal,disparity2depth);
                
                elseif medfilt
                    filtered_aligned_depth_frame=aligned_depth;
                end
                % Colorize original depth frame and aligned depth frame
                colorized_original_depth=colorizer.colorize(original_depth);
                colorized_aligned_depth=colorizer.colorize(filtered_aligned_depth_frame);
    
                %Resize 2D depth frames
                img_original_depth=reshape(original_depth.get_data()',original_depth.get_width(),original_depth.get_height())';
                img_aligned_depth=reshape(aligned_depth.get_data()',aligned_depth.get_width(),aligned_depth.get_height())';
    
                %Resize all colorized frames
                width_ref=color.get_width();
                img_colorized_depth=resize(colorized_original_depth,width_ref);
                img_aligned_colorized_depth=resize(colorized_aligned_depth,width_ref);
                img_color=resize(color,width_ref);
                
                if medfilt
                    img_original_depth=medfilter(img_original_depth);
                    img_aligned_depth=medfilter(img_aligned_depth);       
                    img_colorized_depth=medfilter(img_colorized_depth);
                    img_aligned_colorized_depth=medfilter(img_colorized_depth);
                    img_color=medfilter(img_color);
                end
                video(i).original_depth=img_original_depth;
                video(i).aligned_depth=img_aligned_depth;
                video(i).colorized_depth=img_colorized_depth;
                video(i).aligned_colorized_depth=img_aligned_colorized_depth;
                video(i).color=img_color;
                video(i).t=original_depth.get_timestamp-t0; % in ms
                
            end
            %pause(0.1);
        end
    
        pipeline.stop();
    
        testNum = 1;
        while exist(path+"/video"+testNum+".mat", 'file')
            testNum = testNum+1;
        end
    
        if ~exist(path,"dir")
            mkdir(path)
        end
    
        structName=path+"/video"+testNum;
        fprintf("Saving content to "+structName+".mat"+"...");
    
        save(structName+".mat","video");
       
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
    
    function filtered_depth_frames=depth_filters(depth_frames,decimation,depth2disparity,spatial,temporal,disparity2depth)
        % Apply filters to depth frames
        depth_frames = decimation.process(depth_frames);
        disparity_frames = depth2disparity.process(depth_frames);
        depth_frames = spatial.process(disparity_frames);
        depth_frames = temporal.process(depth_frames);
        filtered_depth_frames = disparity2depth.process(depth_frames);
    end
    function frame_out=resize(frame_in,width_ref)
        img = frame_in.get_data();
        height = frame_in.get_height();
        width = frame_in.get_width();
        img = permute(reshape(img', [], width, height), [3, 2, 1]);
        img=img(:,:,1:3);
        scale=width_ref/width;
        frame_out=imresize(img,scale);
    end
    function [I]=medfilter(img)
        imgclosed=imclose(img,strel('disk',5));
        I=medfilt2(imgclosed,[20 20],'symmetric');
    end
end