% DL algorithm and double rectangle detection

if(~canUseGPU())
    errorHandler("Your computer must have an NVIDIA GPU in order to execute the DL algorithms.");
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
        [frame,depth,color] = frame.get_frame_at_index(88); %28

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
        error("This image does not have two distincts parts of the pallet visible. Please try another image.");
    end



    % nbParts = 1;

    %
    figure(10);imshow(color);
    for k=1:nbParts
        fprintf("k: %d\n", k);
        invertedImage = ~maskedCropped_layer1(k).img;


        filledImage = imfill(invertedImage, 'holes');

        regions = regionprops(filledImage, 'BoundingBox', 'ConvexHull', 'Area');


        [~, largestIdx] = max([regions.Area]);
        rectangleRegion = regions(largestIdx);


        figure;
        imshow(maskedCropped_layer1(k).img); hold on;


        bbox = round(rectangleRegion.BoundingBox);
        rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);

        % hull = rectangleRegion.ConvexHull;
        % plot(hull(:,1), hull(:,2), 'g-', 'LineWidth', 2);

        title('Detected Rectangle');
        hold off;

        figure(10); hold on;
        point1 = [bbox(1)+maskedCropped_layer1(k).x bbox(2)+maskedCropped_layer1(k).y];
        point2 = [bbox(1)+bbox(3)+maskedCropped_layer1(k).x bbox(2)+bbox(4)+maskedCropped_layer1(k).y];

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

catch errorHandler
    % Error handling
    if errorHandler.identifier == "MATLAB:UndefinedFunction"
        fprintf(2, "The modules/class folder was not added to your matlab path.\nIt has now been added and you need to re-run the code.\n");
        addpath('modules');
        addpath('class');
        rethrow(errorHandler);
    elseif errorHandler.identifier == "MATLAB:ginput:FigureDeletionPause"
        fprintf(2, "Figure was closed before selecting points\n");
        clear f;
    else
        clear f;
        fprintf("Unknown error:\n");
        rethrow(errorHandler);
    end
end

% Callback function to stop the pipeline and close the window
function close_window(~, ~)
clear f;
disp('Window closed');
delete(gcf);  % Close the GUI window
end