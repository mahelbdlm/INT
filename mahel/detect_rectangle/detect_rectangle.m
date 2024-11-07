% Work in progress


% Connect and configure RealSense camera
pipeline = connectDepth();
pointcloud = realsense.pointcloud();
colorizer = realsense.colorizer();

% Capture frames and retrieve depth frame
fs = pipeline.wait_for_frames();
depth = fs.get_depth_frame();
colorizedDepth = colorizer.colorize(depth); % Colorized depth for visualization

% Get image dimensions
height = depth.get_height();
width = depth.get_width();

% Convert depth frame to a MATLAB-compatible matrix
depth_data = double(reshape(depth.get_data(), [width, height]))';

% Set distance threshold values for rectangle detection (adjust as needed)
min_depth = 0.3; % minimum distance in meters
max_depth = 0.6; % maximum distance in meters

% Segment the rectangle based on depth range
depth_mask = depth_data > min_depth & depth_data < max_depth;

% Optional: display the masked depth image
figure;
imshow(depth_mask);
title('Segmented Rectangle Region');

% Apply edge detection to find the rectangle's boundaries
edges = edge(depth_mask, 'Canny');

% Find bounding box around the detected rectangle
stats = regionprops(edges, 'BoundingBox');
rectangle_bbox = stats(1).BoundingBox;

% Display the detected bounding box on the depth image
figure;
imshow(depth_mask);
hold on;
rectangle('Position', rectangle_bbox, 'EdgeColor', 'r', 'LineWidth', 2);
title('Detected Rectangle');

% Calculate the real-world dimensions using depth data
% Average depth within the bounding box to get an approximate distance
average_depth = mean(depth_data(depth_mask));

% Calculate dimensions in meters
pixel_width = rectangle_bbox(3);
pixel_height = rectangle_bbox(4);

% Camera intrinsics (these should be obtained from the RealSense camera calibration)
focal_length = 600; % Example focal length in pixels (adjust based on calibration)
pixel_size = 0.0005; % Example pixel size in meters (adjust based on camera specs)

% Calculate real-world dimensions
real_width = pixel_width * pixel_size * average_depth / focal_length;
real_height = pixel_height * pixel_size * average_depth / focal_length;

fprintf('Rectangle width: %.2f meters\n', real_width);
fprintf('Rectangle height: %.2f meters\n', real_height);

% Cleanup
pipeline.stop();
