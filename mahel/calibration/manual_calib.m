% Calibrate the camera to be able to measure distances from the RGB camera

% THIS CODE IS STILL IN DEVELOPMENT AND IS NOT YET FUNCTIONAL
% TEAM: DON'T ASK ME ABOUT THIS, AS I'LL BE UPDATING IT...

clear f;
clear;
close all;
targetPath = "mahel/save/test2"; % Path of the video file
% Connect with default configuration
try

    %frame = getFrames(targetPath, "mahelv3");
    frame = getFrames();
    frame = frame.init(); % Initialize the frame class

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
    end

    % Processing frames in a loop
    while (ishandle(f) && frame.isActive)
        % Wait for a new frame set
        disp("Getting frame");

        [frame,depth,color] = frame.get_frame_aligned();
        fprintf("Key shortcuts:\n    - Right arrow -> Next frame\n    - C or K key: Calculate the constant prompting the correct size\n    - R key: Reset the points\n");

        %imshow(depth, []);
        %depthColorized = permute(reshape(frame.colorizer.colorize(depthFrame).get_data()', [3, depthFrame.get_width(), depthFrame.get_height()]), [3, 2, 1]);
        imshowpair(color, depth);
        title('Select points to measure distance');

        wait_for_points = 1; %wait_for_points will be disabled by button
        while wait_for_points==1
            % Prompt user to select points
            [x, y, button] = ginput(1);
            if(button==1)
                if(size(points,1)==2)
                    points = [];  
                    imshowpair(color, depth);
                end

                u = round([x(1), y(1)]); % First point
                udistToObject = frame.getDepth(depth, u);
                %udistToObject = depthFrame.get_distance(u(1), u(2));
                                                    %Original function
                if udistToObject>0
                    upoint3D = frame.distance.deproject_pixel_to_point(u, udistToObject); %Generate the 3D point to calculate
                                                                                          % the distance between the 2 points

                    fprintf('Distance to pixel: %.2f meters\n', udistToObject);

                    % Plot points and display distance
                    hold on;
                    plot(u(1), u(2), 'ro', 'MarkerSize', 10);  % Red point for selected point
                    distance_text = sprintf('%.2f m', udistToObject);  % Format the distance as a string
                    % Place the text near the plotted point
                    text(u(1) + 10, u(2) + 10, distance_text, 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom');
                    hold off;
                    % Store points and text
                    points = [points; upoint3D];  % Store points for future use
    
                    if(size(points,1)==2)
                        dist = frame.distance.getDistance(points(1,:), points(2,:));
                        fprintf("Distance: %.3f\n", dist)
                    end
                else
                    fprintf("This point was not recognized. Try another.\n")
                end

            elseif (button == 29) % Right arrow
                % Clear the previous points and text and get new frame
                points = [];  % Reset points array
                wait_for_points=0;
            elseif (button == 99 || button == 107) % C key or k key
                prompt = {'Enter the correct distance (m):'};
                dlg_title = 'Input';
                num_lines = 1;
                default_answer = {'0'};  % Default input value
                answer = inputdlg(prompt, dlg_title, num_lines, default_answer);
                
                % Convert the answer to a number
                user_input = str2double(answer{1});
                
                % Display the entered number
                disp(['You entered: ', num2str(user_input)]);

                cte = (user_input*frame.distance.correctionConstant)/dist;
                fprintf("The constant to apply to the class is: %f", cte);
                frame.distance.correctionConstant = cte;
                
            elseif(button==114) % R key
                % Clear points
                points = [];  % Reset points array
                % imshow(depth, []);
                 imshowpair(color, depth);
            else
                %Display the number of button pressed
                disp(button);
            end
        end
    end
    if(~frame.isActive)
        fprintf("This was the last frame of the file saved");
    end

catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"

        %contains(error.message, "getFrames")

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