% @author: Mahel
% Very much based on Jan's detectEdge script
% Last modification: 23/11/2024


%THIS CODE IS STILL IN DEVELOPPMENT. IT IS NOT 100% FUNCTIONAL AND IS USED
%TO RUN SOME TESTS


clear;
close all;
plotSubLines = 0;
plotRectangle = 1;
% Camera if you want to use
% the camera

% Connect with default configuration
try
    color = imread("mahel/detect_missing_part/ideal_img/palet_ideal.jpg");

    grayImg = rgb2gray(color);
    bwImg = imbinarize(grayImg,"adaptive","ForegroundPolarity","dark");
    bwFilled = bwImg;


    smoothedImage = imgaussfilt(grayImg, 4); % Adjust sigma as needed
    edges = edge(smoothedImage, 'canny');


    [H,T,R]=hough(edges);

    P  = houghpeaks(H,10,'threshold',ceil(0.5*max(H(:))));
    %numPeaks (after H): Maximum number of peaks to detect
    %ceil(xx*max...): Minimum value to be considered a peak

    lines = houghlines(edges,T,R,P,'FillGap',50,'MinLength',3);
    %fillGap: Distance between 2 lines to be considered a single line
    % minLength: minimum length for the line to be accepted

    if plotSubLines
        figure, imshow(edges), hold on
        max_len = 0;
        for k = 1:length(lines)
            xy = [lines(k).point1; lines(k).point2];
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

            % Plot beginnings and ends of lines
            plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
            plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

            % Determine the endpoints of the longest line segment
            len = norm(lines(k).point1 - lines(k).point2);
            if ( len > max_len)
                max_len = len;
                xy_long = xy;
            end
        end
        % highlight the longest line segment
        plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');

        xy = [lines(1).point1; lines(2).point1];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');

        xy = [lines(1).point2; lines(2).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
    end

    if plotRectangle
        figure, imshow(edges), hold on
        % Reorganize the corners in a cyclic order to form a rectangle
        rectangleCorners = [lines(1).point1; lines(1).point2; lines(2).point2; lines(2).point1; lines(1).point1];
        % Plot the rectangle
        plot(rectangleCorners(:,1), rectangleCorners(:,2), 'r-', 'LineWidth', 2);
        % Highlight the corners
        scatter(rectangleCorners(:,1), rectangleCorners(:,2), 50, 'red', 'filled');
        title('Detected Rectangle');
        hold off;
    end

catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        fprintf(2, "The modules/class folder was not added to your matlab path.\nIt has now been added and the code execution was restarted.\n");
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