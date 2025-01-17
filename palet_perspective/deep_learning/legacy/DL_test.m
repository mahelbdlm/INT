% @author: Mahel
% Very much based on Jan's detectEdge script
% Last modification: 23/11/2024

%THIS CODE IS STILL IN DEVELOPPMENT. IT IS NOT 100% FUNCTIONAL AND IS USED
%TO RUN SOME TESTS
imagesv1Exist=0;




clear;
close all;
targetPath = "mahel/video_stable/europeo6"; % Path of the video file
% Camera if you want to use
% the camera

% Connect with default configuration
try


    frame = getFrames(targetPath,"mahelv3"); % The frames will be obtained using the camera and mahel file format
    frame = frame.init(); % Initialize the frame class
    [frame,depth,color] = frame.get_frame_at_index(10);
    
    % imshow(color);
    % return;


    grayImg = rgb2gray(color); % For color image
    % [originalHeight, originalWidth, ~] = size(grayImg);
    % grayImg = imcrop(grayImg,[0 180 originalWidth 140]);

    tic;
    [BW,maskedImage] = segmentImage_DL_FULL(grayImg);
    
    return;

    edges = edge(rgb2gray(maskedImageV2), 'canny');

    % grayImgRight = imcrop(maskedImage,[340.5 349.5 235 86]);
    % edgesRight = edge(maskedImageV2, 'canny');


    % S = regionprops(maskedImage,'BoundingBox','Area');
    % [MaxArea,MaxIndex] = max(vertcat(S.Area));
    % Length = S(MaxIndex).BoundingBox(3);
    % Height = S(MaxIndex).BoundingBox(4);
    % % Cropping the image
    % % Get all rows and columns where the image is nonzero
    % [nonZeroRows,nonZeroColumns] = find(maskedImage);
    % % Get the cropping parameters
    % topRow = min(nonZeroRows(:));
    % bottomRow = max(nonZeroRows(:));
    % leftColumn = min(nonZeroColumns(:));
    % rightColumn = max(nonZeroColumns(:));
    % % Extract a cropped image from the original.
    % maskedImage = maskedImage(topRow:bottomRow, leftColumn:rightColumn);
    % BW = BW(topRow:bottomRow, leftColumn:rightColumn);
    % grayImg = grayImg(topRow:bottomRow, leftColumn:rightColumn);
    % [originalHeight, originalWidth, ~] = size(maskedImage);
    % % Display the original gray scale image.
    % % figure
    % % imshowpair(maskedImage, BW, "montage");

    elapsedTime = toc;

    disp(['Elapsed Time: ', num2str(elapsedTime), ' seconds']);

    %imwrite(BW, "mahel/deep_learning/BW.jpg");
    %imwrite(maskedImage, "mahel/deep_learning/masked.jpg");


    edges = edge(maskedImage, 'canny');

    [H,T,R]=hough(edges);

    P  = houghpeaks(H,3,'threshold',ceil(0.5*max(H(:))));
    %numPeaks (after H): Maximum number of peaks to detect
    %ceil(xx*max...): Minimum value to be considered a peak
    % The larger the line, the higher the peak. By filtering to a high
    % value, we select the largest lines

    linesEdges = houghlines(edges,T,R,P,'FillGap',20,'MinLength',3);
    %fillGap: Distance between 2 lines to be considered a single line
    % minLength: minimum length for the line to be accepted

    figure(1);
    lineLengths = distanceHoughLines(edges, linesEdges);

    % subplot(2,1,1);
    % lineLengths = distanceHoughLines(edges, linesEdges);
    % subplot(2,1,2);
    % distanceHoughLines(grayImg, linesEdges);

    numLines = length(lineLengths);
    similarPairs = [];
    for i = 1:numLines
        for j = i+1:numLines
            if abs(lineLengths(i) - lineLengths(j)) <= 50; %Max length diff is 5
                similarPairs = [similarPairs; i, j];
            end
        end
    end

    dist_u1 = frame.getDepth(depth, linesEdges(similarPairs(1)).point1);
    dist_v1 = frame.getDepth(depth, linesEdges(similarPairs(1)).point2);

    dist_u2 = frame.getDepth(depth, linesEdges(similarPairs(2)).point1);
    dist_v2 = frame.getDepth(depth, linesEdges(similarPairs(2)).point2);

    point_3D_u1 = frame.distance.deproject_pixel_to_point(linesEdges(similarPairs(1)).point1, dist_u1);
    point_3D_v1 = frame.distance.deproject_pixel_to_point(linesEdges(similarPairs(1)).point2, dist_v1);

    point_3D_u2 = frame.distance.deproject_pixel_to_point(linesEdges(similarPairs(2)).point1, dist_u2);
    point_3D_v2 = frame.distance.deproject_pixel_to_point(linesEdges(similarPairs(2)).point2, dist_v2);

    dist_1 = frame.distance.getDistance(point_3D_u1, point_3D_v1);
    dist_2 = frame.distance.getDistance(point_3D_u2, point_3D_v2);
    fprintf("Distance: %.3f or %.3f\n", dist_1, dist_2);
    return;


    % lineLengthsBigPicture = showHoughLines(edges, linesEdges);

    if false
        subplot(3,1,2);
        cornersEigen = detectMinEigenFeatures(grayImg);
        imshow(grayImg); hold on;
        plot(cornersEigen.selectStrongest(50));

        cornersHarris = detectHarrisFeatures(grayImg);
        subplot(3,1,3);
        imshow(grayImg); hold on;
        plot(cornersHarris.selectStrongest(50));
    end

    [edgesHeight, edgesWidth, ~] = size(edges);
    edgesLeft = imcrop(edges,[0 0 originalWidth/2 edgesWidth]);
    subplot(3,2,3);
    imshow(edgesLeft);
    subplot(3,2,4);

    [Hl,Tl,Rl]=hough(edgesLeft);
    Pl  = houghpeaks(Hl,50,'threshold',ceil(0.5*max(Hl(:))));
    linesEdges_l = houghlines(edgesLeft,Tl,Rl,Pl,'FillGap',50,'MinLength',3);
    lineLengths = showHoughLines(edgesLeft, linesEdges_l);

    numLines = length(lineLengths);
    similarPairs = [];
    for i = 1:numLines
        for j = i+1:numLines
            if abs(lineLengths(i) - lineLengths(j)) <= 5 %Max length diff is 5
                similarPairs = [similarPairs; i, j];
            end
        end
    end
    if(length(similarPairs)==2)
        % Save the square to detect dimensions using depth
        l1_px1 = linesEdges_l(similarPairs(1)).point1;
        l1_px2 = linesEdges_l(similarPairs(1)).point2;

        l2_px1 = linesEdges_l(similarPairs(2)).point1;
        l2_px2 = linesEdges_l(similarPairs(2)).point2;
    else
        error("More than 2 lines of the same distance were detected");
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