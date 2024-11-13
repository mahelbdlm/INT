% This script is the same as align_manually, but with a stream continuous video
% and allows for a manual reshaping of the image
% Based on https://dev.intelrealsense.com/docs/rs-measure
% Last modification: 12/11/2024


clear f;
close all;

%Default values

% sliderX_init = 0;
% sliderY_init = 0;
% sliderScale_init = 1;
% sliderWidth_init = 1;
% sliderHeight_init = 1;

sliderX_init = -30;
sliderY_init = -126;
sliderScale_init = 1.18;
sliderWidth_init = 0.97;
sliderHeight_init = 1.28;


sliderAlpha_init = 0.4;


% Connect with default configuration
try
    if ~exist("pipeline", "var")
        [pipeline, profile] = connectDepth(1); % Connect depth with high accuracy

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
    
        align_to = realsense.align(realsense.stream.depth);
    end
    
    % Discard the first 10 frames
    for i = 1:10
        frames = pipeline.wait_for_frames();
    end

     % Create the figure and sliders for adjustments
     fig = figure('KeyPressFcn', @(src, event) keyPressCallback(src, event));  % Pass the figure to keyPressCallback
     title('Overlaid Images with Transparency Control');
     hImage = imshowpair(zeros(480,640,3), zeros(480,640,3), 'blend', 'Scaling', 'joint');
            % Create sliders with initial values passed as arguments
            uicontrol('Style', 'text', 'Position', [20, 20, 120, 20], 'String', 'Horizontal Movement');
            sliderX = uicontrol('Style', 'slider', 'Min', -200, 'Max', 100, 'Value', sliderX_init, ...
                'Position', [150, 20, 300, 20]);
            
            uicontrol('Style', 'text', 'Position', [20, 60, 120, 20], 'String', 'Vertical Movement');
            sliderY = uicontrol('Style', 'slider', 'Min', -200, 'Max', 100, 'Value', sliderY_init, ...
                'Position', [150, 60, 300, 20]);
            
            uicontrol('Style', 'text', 'Position', [20, 100, 120, 20], 'String', 'Uniform Scale');
            sliderScale = uicontrol('Style', 'slider', 'Min', 0.5, 'Max', 2, 'Value', sliderScale_init, ...
                'Position', [150, 100, 300, 20]);
            
            uicontrol('Style', 'text', 'Position', [20, 140, 120, 20], 'String', 'Width Distortion');
            sliderWidth = uicontrol('Style', 'slider', 'Min', 0.5, 'Max', 2, 'Value', sliderWidth_init, ...
                'Position', [150, 140, 300, 20]);
            
            uicontrol('Style', 'text', 'Position', [20, 180, 120, 20], 'String', 'Height Distortion');
            sliderHeight = uicontrol('Style', 'slider', 'Min', 0.5, 'Max', 2, 'Value', sliderHeight_init, ...
                'Position', [150, 180, 300, 20]);
            
            uicontrol('Style', 'text', 'Position', [20, 220, 120, 20], 'String', 'Transparency');
            sliderAlpha = uicontrol('Style', 'slider', 'Min', 0, 'Max', 1, 'Value', sliderAlpha_init, ...
                'Position', [150, 220, 300, 20]);

            
            % Save the slider handles in the figure using guidata
            guidata(fig, struct('sliderX', sliderX, 'sliderY', sliderY, 'sliderScale', sliderScale, ...
                    'sliderWidth', sliderWidth, 'sliderHeight', sliderHeight, 'sliderAlpha', sliderAlpha, ...
                    'sliderX_init', sliderX_init, 'sliderY_init', sliderY_init, 'sliderScale_init', sliderScale_init, ...
                    'sliderWidth_init', sliderWidth_init, 'sliderHeight_init', sliderHeight_init, 'sliderAlpha_init', sliderAlpha_init));

        
            % % Define the callbacks for the sliders
            % set(sliderX, 'Callback', @(src, event) updateAlignment(sliderX, sliderY, sliderScale, sliderWidth, sliderHeight, sliderAlpha, depth_frame_colorized, color_img_resized, hImage));
            % set(sliderY, 'Callback', @(src, event) updateAlignment(sliderX, sliderY, sliderScale, sliderWidth, sliderHeight, sliderAlpha, depth_frame_colorized, color_img_resized, hImage));
            % set(sliderScale, 'Callback', @(src, event) updateAlignment(sliderX, sliderY, sliderScale, sliderWidth, sliderHeight, sliderAlpha, depth_frame_colorized, color_img_resized, hImage));
            % set(sliderWidth, 'Callback', @(src, event) updateAlignment(sliderX, sliderY, sliderScale, sliderWidth, sliderHeight, sliderAlpha, depth_frame_colorized, color_img_resized, hImage));
            % set(sliderHeight, 'Callback', @(src, event) updateAlignment(sliderX, sliderY, sliderScale, sliderWidth, sliderHeight, sliderAlpha, depth_frame_colorized, color_img_resized, hImage));
            % set(sliderAlpha, 'Callback', @(src, event) updateAlignment(sliderX, sliderY, sliderScale, sliderWidth, sliderHeight, sliderAlpha, depth_frame_colorized, color_img_resized, hImage));

            % Processing frames in a loop
            while ishandle(fig)  % Loop until the figure is closed
            % Wait for a new frame set
            frames = pipeline.wait_for_frames();
            depth = frames.get_depth_frame();
            color = frames.get_color_frame();
            
            if ~isempty(frames)
                aligned_frames = align_to.process(frames);
                depth_frame = aligned_frames.get_depth_frame();
                
                % Apply filters
                depth_frame = decimation.process(depth_frame);
                disparity_frame = depth2disparity.process(depth_frame);
                depth_frame = spatial.process(disparity_frame);
                depth_frame = temporal.process(depth_frame);
                depth_frame = disparity2depth.process(depth_frame);
                
                % Colorize depth frame
                colorized_depth = colorizer.colorize(depth_frame);
                
                % Display the colorized depth frame
                img = colorized_depth.get_data();
                height = depth.get_height();
                width = depth.get_width();
                depth_frame_colorized = permute(reshape(colorizer.colorize(depth).get_data()', [3, width, height]), [3, 2, 1]);
                
                % Treat the colorized image
                wc = color.get_width();
                hc = color.get_height();
                
                color_data = color.get_data();
                color_img_rgba = permute(reshape(color_data, [4, wc, hc]), [3, 2, 1]);
                
                % Discard the alpha channel to keep only RGB
                color_img = color_img_rgba(:, :, 1:3);
                
                color_img_resized = imresize(color_img, [480, 640]);
                
                % Initialize the display with the first frame only (only once)
                if ~exist('hImage', 'var') || ~ishandle(hImage)
                    hImage = imshowpair(color_img_resized, depth_frame_colorized, 'blend', 'Scaling', 'joint');
                else
                    % Update the overlaid image dynamically with the new frame
                    % Create the blended image with transparency control
                    blendedImage = blendImages(color_img_resized, depth_frame_colorized, get(sliderAlpha, 'Value'));
                    
                    % Update the image data in the `hImage` object
                    hImage.CData = blendedImage;
                end
                
                % Update the alignment (transform the images based on slider values)
                updateAlignment(sliderX, sliderY, sliderScale, sliderWidth, sliderHeight, sliderAlpha, depth_frame_colorized, color_img_resized, hImage);
                
                % Pause to simulate video update rate
                pause(0.2);
            end
        end
    
catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        if contains(error.message, 'connectDepth') || contains(error.message, 'dist_3d')
            fprintf(2, "The modules folder was not added to your MATLAB path.\nIt has now been added, you just need to rerun the code.\n");
            addpath('modules');
            % addpath(genpath('modules')) %Add Folder and Its Subfolders to Search Path
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

function updateAlignment(sliderX, sliderY, sliderScale, sliderWidth, sliderHeight, sliderAlpha, depth_image, rgb_image, hImage)
    % Get the values of the sliders
    dx = round(get(sliderX, 'Value'));
    dy = round(get(sliderY, 'Value'));
    scale = get(sliderScale, 'Value');
    width_scale = get(sliderWidth, 'Value');
    height_scale = get(sliderHeight, 'Value');
    alpha = get(sliderAlpha, 'Value'); % Transparency of the depth image

    % Resize the depth image with uniform scaling and distortions
    resizedDepth = imresize(depth_image, [size(depth_image, 1) * height_scale * scale, size(depth_image, 2) * width_scale * scale]);

    % Create a transformation matrix (translation)
    tform = affine2d([1 0 0; 0 1 0; dx dy 1]);

    % Apply the transformation
    alignedDepth = imwarp(resizedDepth, tform, 'OutputView', imref2d(size(rgb_image)));

    % Blend the images with manual transparency control
    % Here we adjust transparency by modifying the images pixel by pixel
    blendedImage = blendImages(rgb_image, alignedDepth, alpha);

    % Update the overlaid image
    hImage.CData = blendedImage;
end

% Function to blend images with transparency
function blendedImage = blendImages(rgb_image, depth_image, alpha)
    % We assume both images have the same size
    if size(rgb_image, 3) == 3 && size(depth_image, 3) == 1
        % Extend the depth image to 3 channels for blending
        depth_image_rgb = repmat(depth_image, [1, 1, 3]);
    else
        depth_image_rgb = depth_image;
    end

    % Blend the images with an alpha factor (transparency)
    blendedImage = (1 - alpha) * rgb_image + alpha * depth_image_rgb;

    % Ensure the values stay within the range [0, 255] (for a uint8 image)
    blendedImage = uint8(blendedImage);
end


% Function to handle key press
function keyPressCallback(src, event)
    % Access the slider handles from guidata
    figData = guidata(src);
    
    % Check if the pressed key is 's'
    if strcmp(event.Key, 's')
        % Display the values of the parameters in the console
        dx = round(get(figData.sliderX, 'Value'));
        dy = round(get(figData.sliderY, 'Value'));
        scale = get(figData.sliderScale, 'Value');
        width_scale = get(figData.sliderWidth, 'Value');
        height_scale = get(figData.sliderHeight, 'Value');
        fprintf('sliderX_init = %d;\nsliderY_init = %d;\nsliderScale_init = %.2f;\nsliderWidth_init = %.2f;\nsliderHeight_init = %.2f;\n', dx, dy, scale, width_scale, height_scale);
    
    elseif strcmp(event.Key, 'r')
            % Reset sliders to initial values
            set(figData.sliderX, 'Value', figData.sliderX_init);
            set(figData.sliderY, 'Value', figData.sliderY_init);
            set(figData.sliderScale, 'Value', figData.sliderScale_init);
            set(figData.sliderWidth, 'Value', figData.sliderWidth_init);
            set(figData.sliderHeight, 'Value', figData.sliderHeight_init);
            set(figData.sliderAlpha, 'Value', figData.sliderAlpha_init);
    end
end