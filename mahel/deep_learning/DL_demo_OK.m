% DL algorithm and double rectangle detection

if(~canUseGPU())
    error("Your computer must have an NVIDIA GPU in order to execute the DL algorithms.");
end

% clear;
close all;
targetPath = "mahel/video_stable/europeo6"; % Path of the video file
% Camera if you want to use
% the camera

% Connect with default configuration
% tic;
try

    if ~exist("maskedImage", "var")
        tic;
        frame = getFrames(targetPath,"mahelv3"); % The frames will be obtained using the camera and mahel file format
        frame = frame.init(); % Initialize the frame class
        [frame,depth,color] = frame.get_frame_at_index(28);
        
        % imshow(color);
        % return;
    
    
        grayImg = rgb2gray(color); % For color image
        % [originalHeight, originalWidth, ~] = size(grayImg);
        % grayImg = imcrop(grayImg,[0 180 originalWidth 140]);
    
        [BW,maskedImage] = segmentImage_GPU_v1(color);
    
        % grayImgRight = imcrop(maskedImage,[340.5 349.5 235 86]);
        % edgesRight = edge(maskedImageV2, 'canny');

        elapsedTime = toc;

        disp(['Elapsed Time: ', num2str(elapsedTime), ' seconds']);
    end

    % S = regionprops(maskedImage,'BoundingBox','Area');

    maskedCropped_layer1 = struct();
    info = regionprops(BW,'Boundingbox') ;
    figure(1);
    imshow(BW)
    hold on
    i=1;
    for k = 1 : length(info)
         BB = round(info(k).BoundingBox);
         perim = 2*(BB(3)+BB(4));

         %fprintf("P: %d\n", perim);

         if(perim>500)
             %[BB(1),BB(2),BB(3),BB(4)] x, y, width, height
             rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor','r','LineWidth',2);
             maskedCropped_layer1(i).img = imcrop(BW,BB);
             maskedCropped_layer1(i).x = BB(1);
             maskedCropped_layer1(i).y = BB(2);
             maskedCropped_layer1(i).w = BB(3);
             maskedCropped_layer1(i).h = BB(4);
             i=i+1;
         end
    end


    nbParts = length(maskedCropped_layer1);
    if(nbParts~=2)
        error("An error occured... More than 2 bounding boxes have been found.\n");
    end



    % nbParts = 1;

    % 
    figure(10);imshow(color);
    for k=1:nbParts
        fprintf("k: %d\n", k);
        edges = bwmorph(maskedCropped_layer1(k).img,'remove');
        % info = regionprops(edges,'Boundingbox') ;
        info = regionprops(edges, 'BoundingBox', 'Extent', 'Area', 'Orientation', 'ConvexHull');

        figure(k+1);
        imshow(edges)
        hold on
        i=1;
        for n = 1 : length(info)
             BB = round(info(n).BoundingBox);
             perim = 2*(BB(3)+BB(4));
    
             fprintf("P2: %d\n", perim);
    
             if(perim>300 && perim < 600)
                %[BB(1),BB(2),BB(3),BB(4)] x, y, width, height
                figure(k+1);
                rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor','r','LineWidth',2);
                % maskedCropped_layer1(i).img = imcrop(BW,BB);
                % maskedCropped_layer1(i).x = BB(1);
                % maskedCropped_layer1(i).y = BB(2);
                % maskedCropped_layer1(i).w = BB(3);
                % maskedCropped_layer1(i).h = BB(4);
                i=i+1;

                figure(10); hold on;
                point1 = [BB(1)+maskedCropped_layer1(k).x BB(2)+maskedCropped_layer1(k).y];
                point2 = [BB(1)+BB(3)+maskedCropped_layer1(k).x BB(2)+BB(4)+maskedCropped_layer1(k).y];

                dist1 = frame.getDepth(depth, point1);
                dist2 = frame.getDepth(depth, point2);
    
                % Plot the line
                plot([point1(1) point2(1)], [point1(2) point2(2)], 'LineWidth', 2, 'Color', 'green');
    
                % Plot the point 1 with text
                plot(point1(1), point1(2), 'ro', 'MarkerSize', 10);  % Red point for selected point
                distance_text = sprintf('%.2f m', dist1);  % Format the distance as a string
                text(point1(1) + 10, point1(2) + 10, distance_text, 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom');
    
                % Plot the point 1 with text
                plot(point2(1), point2(2), 'ro', 'MarkerSize', 10);  % Red point for selected point
                distance_text = sprintf('%.2f m', dist2);  % Format the distance as a string
                text(point2(1) + 10, point2(2) + 10, distance_text, 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom');
    
                point_3D_1 = frame.distance.deproject_pixel_to_point(point1, dist1);
                point_3D_2 = frame.distance.deproject_pixel_to_point(point2, dist2);
    
                dist = frame.distance.getDistance(point_3D_1, point_3D_2);
                fprintf("Distance: %.3f\n", dist);

             end
        end
    end


    return;

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

    % elapsedTime = toc;

    % disp(['Elapsed Time: ', num2str(elapsedTime), ' seconds']);

    %imwrite(BW, "mahel/deep_learning/BW.jpg");
    %imwrite(maskedImage, "mahel/deep_learning/masked.jpg");


    edges = edge(BW, 'canny');

    [H,T,R]=hough(edges);

    P  = houghpeaks(H,3,'threshold',ceil(0.5*max(H(:))));
    %numPeaks (after H): Maximum number of peaks to detect
    %ceil(xx*max...): Minimum value to be considered a peak
    % The larger the line, the higher the peak. By filtering to a high
    % value, we select the largest lines

    linesEdges = houghlines(edges,T,R,P,'FillGap',40,'MinLength',3);
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