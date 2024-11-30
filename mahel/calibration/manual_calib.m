% Calibrate the camera to be able to measure distances from the RGB camera

% THIS CODE IS STILL IN DEVELOPMENT AND IS NOT YET FUNCTIONAL
% TEAM: DON'T ASK ME ABOUT THIS, AS I'LL BE UPDATING IT...

clear f;
clear;
close all;

% Connect with default configuration
try

    frame = getFrames();
    frame = frame.init(); % Initialize the frame class
    intrinsics = frame.get_intrinsics(); % Get the camera intrinsics for 3D distance calculation

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
        distance_num = [];
    end

    % Processing frames in a loop
    while ishandle(f)
        % Wait for a new frame set
        disp("Getting frame");

        [frame,depthFrame,depth,color] = frame.get_frame_aligned();
        imshow(depth, []);
        title('Select points to measure distance');

        % Get the depth stream and intrinsics
        %depthStream = profile.get_stream(realsense.stream.depth);
        %if isempty(depthStream)
        %    error('Depth stream not available in this profile!');
        %end
        %depthProfile = depthStream.as('video_stream_profile');
        %intrinsics = depthProfile.get_intrinsics();

        wait_for_points = 1; %wait_for_points will be disabled by button
        while wait_for_points==1
            % Prompt user to select points
            [x, y, button] = ginput(1);
            if(button==1)
                if(size(points,1)==2)
                    points = [];  
                    distance_num = [];
                    imshow(depth, []);
                end

                u = round([x(1), y(1)]); % First point
                upixel = round(u / 2);
                udist = depthFrame.get_distance(upixel(1), upixel(2));
                fprintf('Distance to pixel: %.2f meters\n', udist);

                % Plot points and display distance
                hold on;
                plot(u(1), u(2), 'ro', 'MarkerSize', 10);  % Red point for selected point
                distance_text = sprintf('%.2f m', udist);  % Format the distance as a string
                % Place the text near the plotted point
                text(u(1) + 10, u(2) + 10, distance_text, 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom');
                hold off;

                % Store points and text
                points = [points; u];  % Store points for future use
                distance_num = [distance_num; udist];

                if(size(points,1)==2)
                    dist = frame.dist_3d(intrinsics, points, distance_num(1,:), points(2,:), distance_num(2,:));
                    fprintf("Distance: %.2f\n", dist)
                end
                

                %dist = frame.dist_3d(intrinsics, depthFrame, u, v)

            elseif (button == 29) % Right arrow
                % Clear the previous points and text and get new frame
                points = [];  % Reset points array
                distance_num = [];  % Reset distance text array
                wait_for_points=0;
            elseif(button==114)
                % Clear points
                points = [];  % Reset points array
                distance_num = [];  % Reset distance text array
                imshow(depth, []);
            else
                %Display the number of button pressed
                disp(button);
            end
        end
    end

catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        fprintf(2, "The modules/class folder was not added to your matlab path.\nIt has now been added and you need to re-run the code.\n");
        addpath('modules');
        addpath('class');
        rethrow(error);
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