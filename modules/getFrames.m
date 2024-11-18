% This function gets color/depth frames from the camera or a file
% based on the parameters defined by the user
% INPUT: Desired path
% OUTPUT: output.pipeline and output.profile
% Last modification: 14/11/2024

classdef getFrames
    properties
        type
        path
        isActive
        depthHighAccuracy
        userDefinedWidth
        userDefinedHeight
        userDefinedFPS
        cameraPipeline
        cameraProfile
        file_color_original
        file_index
        file_depth_original
        nbFrames
        debugMode
    end
    methods
        % CONSTRUCTOR
        function frame = getFrames(cameraOrPath)
            if nargin == 0
                frame.type = "camera";
            elseif nargin == 1
                if(cameraOrPath=="camera" || cameraOrPath=="" || cameraOrPath=="cam")
                    frame.type = "camera";
                else
                    frame.type = "local";
                    frame.path = cameraOrPath;
                end
            end
            frame.depthHighAccuracy = 0;
            frame.userDefinedWidth = 640;
            frame.userDefinedHeight = 480;
            frame.userDefinedFPS = 30;
            frame.isActive=1;
        end

        function frame=setDepthHighAccuracy(frame)
            frame.depthHighAccuracy = 1;
        end

        function frame=setWidthAndHeight(frame, w, h)
            frame.userDefinedWidth = w;
            frame.userDefinedHeight = h;
        end

        function frame=setFPS(frame, fps)
            frame.userDefinedFPS = fps;
        end

        function frame=enableDebugMode(frame)
            frame.debugMode = 1;
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


                config.enable_stream(realsense.stream.depth,0,frame.userDefinedWidth,frame.userDefinedHeight,realsense.format.z16,frame.userDefinedFPS);

                config.enable_stream(realsense.stream.color, realsense.format.rgba8);
                %
                %     // Start the pipeline streaming
                %     // The retunred object should be released with rs2_delete_pipeline_profile(...)
                profile = pipeline.start(config);

                if frame.depthHighAccuracy == 1
                    % Get the depth sensor and set the preset to high accuracy
                    device = profile.get_device();
                    sensors = device.query_sensors();
                    %name = sensors{1}{2}.get_info(realsense.camera_info.name);
                    fprintf("Available sensors: \n");
                    for i=1:length(sensors{1})
                        fprintf("  -%s\n", sensors{1}{i}.get_info(realsense.camera_info.name))
                    end

                    % Set the preset to high accuracy for the depth sensor
                    sensors{1}{1}.set_option(realsense.option.visual_preset, 3); %Set the depth to high accuracy (3)
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

                % Discard the first 10 frames
                for i = 1:10
                    pipeline.wait_for_frames();
                end
            else
                % Get frame from video
                path_checked=checkPath(frame.path); % Check if the user is on the right folder for the path
                frame.file_color_original= load(path_checked+"/video_color_original.mat").video_color_original;
                frame.file_index = 1;
                frame.nbFrames = 1;
                frame.file_depth_original= load(path_checked+"/video_depth_original.mat").video_depth_original;

                if(frame.debugMode)
                    fprintf("nbFrames: %d, size_color: %d, size_depth: %d\n", frame.nbFrames, length(frame.file_color_original.df),length(frame.file_depth_original.df))
                end
            end

        end

        function [frame,depth,color] = get_frame_original(frame)
            if(frame.type=="camera")
                colorizer = realsense.colorizer();
                colorizer.set_option(realsense.option.color_scheme, 2);

                frames_camera = frame.cameraPipeline.wait_for_frames();
                depth_frame = frames_camera.get_depth_frame();
                color_frame = frames_camera.get_color_frame();

                depth_h = depth_frame.get_height();
                depth_w = depth_frame.get_width();
                depth = permute(reshape(colorizer.colorize(depth_frame).get_data()', [3, depth_w, depth_h]), [3, 2, 1]);

                color_w=color_frame.get_width();
                color_h=color_frame.get_height();
                color_original_rgba = permute(reshape(color_frame.get_data(),[],color_w,color_h), [3, 2, 1]);
                color = color_original_rgba(:, :, 1:3);

            else
                % Get frame from file
                if(frame.debugMode)
                    fprintf("Index: %d\n", frame.file_index);
                end

                depth = frame.file_color_original(frame.file_index).df;
                color = frame.file_depth_original(frame.file_index).df;

                frame.file_index = frame.file_index+1;

                if(frame.file_index == frame.nbFrames)
                    frame.isActive = 0;
                    fprintf("End of video.\n");
                end

            end

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