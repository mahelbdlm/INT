% This function configurates the realsense camera
% INPUT: Variable number of inputs (see readme for more info)
% OUTPUT: output.pipeline and output.profile

function [pipeline, profile]=connectDepth(varargin)
    switch nargin
        case 0
            %default values
            highDensity    = 0;
            WIDTH          = 640   ;           %// Defines the number of columns for each frame or zero for auto resolve//
            HEIGHT          =480  ;            %// Defines the number of lines for each frame or zero for auto resolve  //
            FPS            = 30   ;            %// Defines the rate of frames per second
        case 1
            highDensity    = varargin{1};
            FPS            = 30   ;  
            WIDTH          = 640   ;           %// Defines the number of columns for each frame or zero for auto resolve//
            HEIGHT          =480  ;            %// Defines the number of lines for each frame or zero for auto resolve  //
        case 2
            highDensity    = varargin{1};
            FPS=varargin{2};
            WIDTH          = 640   ;           %// Defines the number of columns for each frame or zero for auto resolve//
            HEIGHT          =480  ;            %// Defines the number of lines for each frame or zero for auto resolve  //
        case 4
            highDensity    = varargin{1};
            FPS=varargin{2};
            WIDTH=varargin{3};
            HEIGHT=varargin{4};
        case others
            error('Arguments(none, fps, fps width height)...');
    end
            
%     // Create a context object. This object owns the handles to all connected realsense devices.
%     // The returned object should be released with rs2_delete_context(...)
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
    config.enable_stream(realsense.stream.depth,0,WIDTH,HEIGHT,realsense.format.z16,FPS);

    config.enable_stream(realsense.stream.color,0,WIDTH,HEIGHT, realsense.format.rgba8,FPS);
% 
%     // Start the pipeline streaming
%     // The retunred object should be released with rs2_delete_pipeline_profile(...)
    profile = pipeline.start(config);

    if highDensity == 1
        % Get the depth sensor and set the preset to high accuracy
        device = profile.get_device();
        sensors = device.query_sensors();
        %name = sensors{1}{2}.get_info(realsense.camera_info.name);
        fprintf("Available sensors: \n");
        for i=1:length(sensors{1})
            fprintf("  -%s\n", sensors{1}{i}.get_info(realsense.camera_info.name))
        end
        
        % Set the preset to high accuracy for the depth sensor
        sensors{1}{1}.set_option(realsense.option.visual_preset, 4); %Set the depth to high accuracy (3)

        %Set the RGB sensor to fixed exposure
        %sensors{1}{2}.set_option(realsense.option.enable_auto_exposure,0);
        %sensors{1}{2}.set_option(realsense.option.exposure,500);
    end
end
