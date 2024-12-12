% DL algorithm and double rectangle detection

if(~canUseGPU())
    fprintf("Your computer must have an NVIDIA GPU in order to execute the DL algorithms on GPUs.");
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
        [frame,depth,color] = frame.get_frame_at_index(87); %28
    
    
        grayImg = rgb2gray(color); % For color image
        % [originalHeight, originalWidth, ~] = size(grayImg);
        % grayImg = imcrop(grayImg,[0 180 originalWidth 140]);
    
        [BW,maskedImage] = segmentImage_87(color);
    
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
        %edges = bwmorph(maskedCropped_layer1(k).img,'remove');
        edges = ~maskedCropped_layer1(k).img;
        perimEdges = 2*(size(edges,1)+size(edges,2));
        % info = regionprops(edges,'Boundingbox') ;
        info = regionprops(edges, 'BoundingBox', 'Extent', 'Area', 'Orientation', 'ConvexHull');

        figure(k+1);
        imshow(edges)
        hold on
        i=1;
        for n = 1 : length(info)
             BB = round(info(n).BoundingBox);
             perim = 2*(BB(3)+BB(4));
    
             % fprintf("P2: %d\n", perim);
             if(perim>perimEdges*0.4 && perim < perimEdges*0.8)
                %[BB(1),BB(2),BB(3),BB(4)] x, y, width, height
                figure(k+1);
                rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor','r','LineWidth',2);
                
                hull = info(n).ConvexHull;
                plot(hull(:,1), hull(:,2), 'r-', 'LineWidth', 2); % Plot convex hull
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

catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        fprintf(2, "The modules/class folder was not added to your matlab path.\nIt has now been added and you need to re-run the code.\n");
        addpath('modules');
        addpath('class');
        addpath('mahel/deep_learning');
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