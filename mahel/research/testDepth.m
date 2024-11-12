    % Make Pipeline object to manage streaming
    pipe = realsense.pipeline();
    % Make Colorizer object to prettify depth output
    colorizer = realsense.colorizer();

    % Start streaming on an arbitrary camera with default settings
    profile = pipe.start();

    % Get streaming device's name
    dev = profile.get_device();
    name = dev.get_info(realsense.camera_info.name);

    % Get frames. We discard the first couple to allow
    % the camera time to settle
    for i = 1:5
        fs = pipe.wait_for_frames();
    end
    
    % Stop streaming
    pipe.stop();

    % Select depth frame
    depth = fs.get_depth_frame();

    % Get actual distance data from the depth frame
    distanceData = depth.get_data(); % Retrieve the raw depth data
    % Convert distance data into a matrix for easier handling
    % The depth frame is usually in millimeters, so distanceData will be a vector
    depthWidth = depth.get_width();
    depthHeight = depth.get_height();
    distanceMatrix = reshape(distanceData, [depthWidth, depthHeight]); % Reshape to [width, height]
    
    save('video_depth_2.mat',"distanceMatrix");

    % Colorize depth frame
    color = colorizer.colorize(depth);

    % Get actual data and convert into a format imshow can use
    % (Color data arrives as [R, G, B, R, G, B, ...] vector)
    data = color.get_data();
    img = permute(reshape(data',[3,color.get_width(),color.get_height()]),[3 2 1]);

    % Display image
    imshow(img);
    title(sprintf("Colorized depth frame from %s", name));

    % Display the distance at a specific pixel (for example, at (x,y) = (100, 100))
    x = 100; % X coordinate (column)
    y = 100; % Y coordinate (row)
    distanceValue = distanceMatrix(x, y); % Get distance value in mm
    fprintf('Distance at (%d, %d): %.2f mm\n', x, y, distanceValue);