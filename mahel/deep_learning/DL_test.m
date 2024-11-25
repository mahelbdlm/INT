% Very much based on Jan's detectEdge script
% Last modification: 23/11/2024

%THIS CODE IS STILL IN DEVELOPPMENT. IT IS NOT 100% FUNCTIONAL AND IS USED
%TO RUN SOME TESTS





clear;
close all;
targetPath = "mahel/detect_missing_part/missing_splinter1"; % Path of the video file
% Camera if you want to use
% the camera

% Connect with default configuration
try
    frame = getFrames(targetPath,"mahel"); % The frames will be obtained using the camera and mahel file format
    frame = frame.init(); % Initialize the frame class
    [frame,depth,color] = frame.get_frame_at_index(125); %125 to work

    grayImg = rgb2gray(color); % For color image


    [BW,maskedImage] = segmentImage_v2(grayImg);

    edges = edge(BW, 'canny');

    [H,T,R]=hough(edges);

    P  = houghpeaks(H,50,'threshold',ceil(0.5*max(H(:))));
    %numPeaks (after H): Maximum number of peaks to detect
    %ceil(xx*max...): Minimum value to be considered a peak
    % The larger the line, the higher the peak. By filtering to a high
    % value, we select the largest lines

    lines = houghlines(edges,T,R,P,'FillGap',150,'MinLength',3);
    %fillGap: Distance between 2 lines to be considered a single line
    % minLength: minimum length for the line to be accepted


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




catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        if contains(error.message, 'connectDepth') || contains(error.message, 'getFrames')
            fprintf(2, "The modules folder was not added to your matlab path.\nIt has now been added and the code execution was restarted.\n");
            addpath('modules');
            run(mfilename+".m");
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

% Callback function to stop the pipeline and close the window
function close_window(~, ~)
clear f;
disp('Window closed');
delete(gcf);  % Close the GUI window
end