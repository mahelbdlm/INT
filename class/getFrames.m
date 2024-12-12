% This class manages in a simple way the camera and can easily switch
% between frames from the camera and frames from a user file.

classdef getFrames
    properties
        type
        path
        isActive
        cameraParam
        cameraPipeline
        cameraProfile
        file_color_original
        file_video
        file_index
        file_depth_original
        nbFrames
        debugMode
        saveType
        intelFilters
        colorizer
        distance
    end
    methods
        % CONSTRUCTOR
        function frame = getFrames(varargin)
            if nargin == 0
                frame.type = "camera";
            elseif nargin >= 1
                if(varargin{1}=="camera" || varargin{1}=="" || varargin{1}=="cam")
                    frame.type = "camera";
                else
                    frame.type = "local";
                    frame.path = varargin{1};
                end
            end

            if(nargin>=2 && varargin{2}~="")
                availableTypes = ["jan","mahelv2","mahelv3"];
                frame.saveType=varargin{2};
                if(~ismember(frame.saveType, availableTypes))
                    error("This saved type (%s) was not recognized. Available types are: %s",frame.saveType, join(string(availableTypes), ', '));
                end
            elseif(frame.type == "local")
                error("You must specify a saved format. Saved formats are:jan, mahelv2, mahelv3");
            end

            frame.cameraParam = cameraParams(); %from class cameraParams
            frame.isActive=1;
            frame.intelFilters=0;
            frame.file_index = 1;
        end

        function frame=enableIntelFilters(frame)
            frame.intelFilters = intelFilter();
        end

        function frame=enableDebugMode(frame)
            frame.debugMode = 1;
        end
        function nbFrames=returnNbFrames(frame)
            nbFrames = frame.nbFrames;
        end

        function frame = setCameraParams(frame, methodName, varargin)
            % Check if the method exists in the cameraParams class
            if ismethod(frame.cameraParam, methodName)
                % Dynamically call the specified method with arguments
                frame.cameraParam = frame.cameraParam.(methodName)(varargin{:});
            else
                error('Method "%s" does not exist in the cameraParams class.', methodName);
            end
        end

        function frame = setDistanceClass(frame, methodName, varargin)
            % Check if the method exists in the cameraParams class
            if ismethod(frame.distance, methodName)
                % Dynamically call the specified method with arguments
                frame.distance = frame.distance.(methodName)(varargin{:});
            else
                error('Method "%s" does not exist in the distanceClass class.', methodName);
            end
        end

        function frame = init(frame)
            if(frame.type=="camera")
                ctx =realsense.context();

                %     /* Get a list of all the connected devices. */
                %     // The returned object should be released with rs2_delete_device_list(...)
                device_list = query_devices(ctx);
                dev_count = length(device_list);
                if dev_count==0
                    error('Seems like there are no connected devices!');
                end
                fprintf("There are %d connected RealSense devices.\n", dev_count);

                %     // Get the first connected device
                %     // The returned object should be released with rs2_delete_device(...)
                dev = device_list{1};
                fprintf('%s\n',dev.get_info(realsense.camera_info.name));
                %     // Create a pipeline to configure, start and stop camera streaming
                %     // The returned object should be released with rs2_delete_pipeline(...)
                pipeline =  realsense.pipeline(ctx);

                %     // Create a config instance, used to specify hardware configuration
                %     // The retunred object should be released with rs2_delete_config(...)
                config = realsense.config();
                %
                %     // Request a specific configuration
                %     // If such configuration is not valid, it will display an error
                %     saying it wasn't able to resolve...(!)


                config.enable_stream(realsense.stream.depth,0,frame.cameraParam.cameraWidth,frame.cameraParam.cameraHeight,realsense.format.z16,frame.cameraParam.FPS);

                if frame.cameraParam.defaultSizeColor==1
                    %Default format for color
                    config.enable_stream(realsense.stream.color, realsense.format.rgba8);
                    fprintf("Default color\n");
                else
                    config.enable_stream(realsense.stream.color,0,frame.cameraParam.cameraWidth,frame.cameraParam.cameraHeight, realsense.format.rgba8,frame.cameraParam.FPS);
                end

                %
                %     // Start the pipeline streaming
                %     // The retunred object should be released with rs2_delete_pipeline_profile(...)
                profile = pipeline.start(config);

                device = profile.get_device();
                sensors = device.query_sensors();
                fprintf("Available sensors: \n");
                for i=1:length(sensors{1})
                    fprintf("  -%s\n", sensors{1}{i}.get_info(realsense.camera_info.name))
                end

                if (frame.cameraParam.depthHighAccuracy == 1 || frame.cameraParam.depthHighDensity==1)
                    % Get the depth sensor and set the preset to high accuracy
                    % Set the preset to high accuracy for the depth sensor
                    if(frame.cameraParam.depthHighAccuracy==1)
                        sensors{1}{1}.set_option(realsense.option.visual_preset, 3); %Set the depth to high accuracy (3)
                    elseif frame.cameraParam.depthHighDensity==1
                        sensors{1}{1}.set_option(realsense.option.visual_preset, 4); %4
                    end
                    %sensors{1}{1}.start();
                    % 0: Default
                    % 1: Hand tracking
                    % 2: High Density
                    % 3: High Accuracy

                    %Set the RGB sensor to fixed exposure
                    %sensors{1}{2}.set_option(realsense.option.enable_auto_exposure,0);
                    %sensors{1}{2}.set_option(realsense.option.exposure,500);

                end
                frame.cameraPipeline = pipeline;
                frame.cameraProfile = profile;

                frame.distance = distanceClass(frame.type, frame.cameraProfile);



                % Discard the first 10 frames
                for i = 1:10
                    pipeline.wait_for_frames();
                end

            else
                % Get frame from video
                path_checked=checkPath(frame.path); % Check if the user is on the right folder for the path

                if frame.saveType=="mahelv2"
                    frame.file_color_original= load(path_checked+"/video_color_original.mat").video_color_original;
                    frame.nbFrames = length(frame.file_color_original);
                    frame.file_depth_original= load(path_checked+"/video_depth_original.mat").video_depth_original;
                elseif frame.saveType=="mahelv3"
                    frame.file_color_original= load(path_checked+"/video_color.mat").video_color;
                    frame.nbFrames = length(frame.file_color_original);
                    frame.file_depth_original= load(path_checked+"/video_depth.mat").video_depth;
                    frame.distance = distanceClass(frame.type, load(path_checked+"/camera_params.mat").camera_params); % Initialize distance class

                elseif frame.saveType=="jan"
                    frame.file_video= load(path_checked+"/video1.mat").video;
                    frame.nbFrames = length(frame.file_video);
                else
                    error("This format does not exist or was not appropriately defined in the class.");

                end
                if(frame.debugMode)
                    fprintf("nbFrames: %d, size_color: %d, size_depth: %d\n", frame.nbFrames, length(frame.file_color_original.df),length(frame.file_depth_original.df))
                end
            end
            frame.colorizer = realsense.colorizer();
            frame.colorizer.set_option(realsense.option.color_scheme, 2);

        end

        function frame = set_frame_number(frame, numberFrame)
            frame.file_index = numberFrame;
        end

        function [frame, depth, color] = get_frame_from_file(frame)
            if(frame.type=="local")
                if(frame.debugMode)
                    fprintf("Index: %d\n", frame.file_index);
                end

                if frame.saveType=="mahelv2"
                    color = frame.file_color_original(frame.file_index).df;
                    depth = frame.file_depth_original(frame.file_index).df;
                elseif frame.saveType=="mahelv3"
                    color = frame.file_color_original(frame.file_index).color;
                    depth = frame.file_depth_original(frame.file_index).depth;
                elseif frame.saveType=="jan"
                    depth=frame.file_video(frame.file_index).original_depth;
                    color=frame.file_video(frame.file_index).color;
                else
                    error("This format does not exist or was not appropriately defined in the class.");
                end


                frame.file_index = frame.file_index+1;

                if(frame.file_index == frame.nbFrames)
                    frame.isActive = 0;
                    fprintf("End of video.\n");
                end
            end
        end

        function [frame,depth,color] = get_frame_original(frame)
            error("This function is deprecated and should not be used. Use instead get_frame_aligned.\n")
            if(frame.type=="camera")

                frames_camera = frame.cameraPipeline.wait_for_frames();
                depth_frame = frames_camera.get_depth_frame();
                color_frame = frames_camera.get_color_frame();

                if(class(frame.intelFilters)=="intelFilter")
                    % Apply filters
                    depth = frame.intelFilters.decimation.process(depth_frame);
                    disparity_frame = frame.intelFilters.depth2disparity.process(depth);
                    depth = frame.intelFilters.spatial.process(disparity_frame);
                    depth = frame.intelFilters.temporal.process(depth);
                    depth = frame.intelFilters.disparity2depth.process(depth);
                    depth = frame.colorizer.colorize(depth);
                    depth = permute(reshape(depth.get_data()', [3, depth.get_width(), depth.get_height()]), [3, 2, 1]);
                else
                    depth_h = depth_frame.get_height();
                    depth_w = depth_frame.get_width();
                    depth = permute(reshape(frame.colorizer.colorize(depth_frame).get_data()', [3, depth_w, depth_h]), [3, 2, 1]);
                end
                color_w=color_frame.get_width();
                color_h=color_frame.get_height();
                color_original_rgba = permute(reshape(color_frame.get_data(),[],color_w,color_h), [3, 2, 1]);
                color = color_original_rgba(:, :, 1:3);

            else
                [frame, depth, color] = get_frame_from_file();

            end
        end

        function distance = getDepth(frame, img, point)
            %img = squeeze(permute(reshape(depthFrame.get_data()', [[], depthFrame.get_width(), depthFrame.get_height()]), [3,2,1]));
            distance = double(img(point(2), point(1))) * frame.distance.depthScale;

            if distance == 0
                % Define the neighborhood boundaries (clipping at image edges)
                range = 5; % Search range
                xMin = max(1, point(1) - range);
                xMax = min(size(img, 2), point(1) + range);
                yMin = max(1, point(2) - range);
                yMax = min(size(img, 1), point(2) + range);

                % Extract the neighborhood
                neighborhood = double(img(yMin:yMax, xMin:xMax));

                % Find the maximum value in the neighborhood (ignoring zeros)
                maxValue = max(neighborhood(neighborhood > 0));

                if ~isempty(maxValue)
                    % If a valid maximum is found, calculate and return the distance
                    distance = maxValue * frame.distance.depthScale;
                else
                    % Throw an error if no valid values are found
                    error('No valid depth values found in the specified neighborhood.');
                end
            end


        end

        % function colorizedDepth = get_depth_colorized(frame, depthFrame)
        %      if(frame.type=="camera")
        %          colorizedDepth = permute(reshape(depthFrame.get_data()', [3, depthFrame.get_width(), depthFrame.get_height()]), [3, 2, 1]);
        %      else
        %      end
        % end

        function [frame,depth,color] = get_frame_aligned(frame)
            % Get frame aligned to color
            if(frame.type=="camera")

                frames_camera = frame.cameraPipeline.wait_for_frames();
                align_to_color = realsense.align(realsense.stream.color);
                aligned_color_frames = align_to_color.process(frames_camera);
                depth_frame = aligned_color_frames.get_depth_frame();
                %depthFrame = depth_frame.as('depth_frame');
                color_frame = aligned_color_frames.get_color_frame();


                % if(class(frame.intelFilters)=="intelFilter")
                %     % Apply filters
                %     depth = frame.intelFilters.decimation.process(depth_frame);
                %     disparity_frame = frame.intelFilters.depth2disparity.process(depth);
                %     depth = frame.intelFilters.spatial.process(disparity_frame);
                %     depth = frame.intelFilters.temporal.process(depth);
                %     depth = frame.intelFilters.disparity2depth.process(depth);
                %     depth = frame.colorizer.colorize(depth);
                %     depthColorized = permute(reshape(depth.get_data()', [3, depth.get_width(), depth.get_height()]), [3, 2, 1]);
                % else
                %     depth_h = depth_frame.get_height();
                %     depth_w = depth_frame.get_width();
                %     depthColorized = permute(reshape(frame.colorizer.colorize(depth_frame).get_data()', [3, depth_w, depth_h]), [3, 2, 1]);
                % end
                depth = squeeze(permute(reshape(depth_frame.get_data()', [[], depth_frame.get_width(), depth_frame.get_height()]), [3,2,1]));
                color_w=color_frame.get_width();
                color_h=color_frame.get_height();
                color_original_rgba = permute(reshape(color_frame.get_data(),[],color_w,color_h), [3, 2, 1]);
                color = color_original_rgba(:, :, 1:3);

            else
                [frame, depth, color] = frame.get_frame_from_file();

            end
        end



        function [frame,depth,color] = get_frame_at_index(frame, indexFrame)
            frame.file_index = indexFrame;
            [frame, depth, color] = get_frame_from_file(frame);
        end


        function frame = stop(frame)
            if(frame.type=="camera")
                frame.cameraPipeline.stop();
            end
        end
    end

    methods (Static)
        % function obj = createObj
        %    prompt = {'Enter the Radius'};
        %    dlgTitle = 'Radius';
        %    rad = inputdlg(prompt,dlgTitle);
        %    r = str2double(rad{:});
        %    obj = CircleArea(r);
        % end
    end
end