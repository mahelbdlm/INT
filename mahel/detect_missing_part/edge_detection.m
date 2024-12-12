%THIS CODE IS STILL IN DEVELOPPMENT. IT IS NOT 100% FUNCTIONAL AND IS USED
%TO RUN SOME TESTS





clear;
close all;
targetPath = "mahel/detect_missing_part/missing_splinter1"; % Path of the video file
%targetPath = "mahel/palet_side/americano1"; % Path of the video file
plotAllResults = 1;
% Camera if you want to use
% the camera

% Connect with default configuration
try
    frame = getFrames(targetPath,"mahelv2"); % The frames will be obtained using the camera and mahel file format
    frame = frame.init(); % Initialize the frame class
    [frame,depth,color] = frame.get_frame_at_index(120);

    [originalHeight, originalWidth, ~] = size(color);
    imgCropped = imcrop(color,[0 180 originalWidth 140]);
    %[0.5 184.5 640 125]

    %imgclosed=imclose(depth(:,:,1),strel('disk',5));
    %grayImg=medfilt2(imgclosed,[20 20],'symmetric');

    grayImg = rgb2gray(imgCropped); % For color image
    bwImg = imbinarize(grayImg, 'adaptive', 'Sensitivity', 0.5);
    %bwImg = imbinarize(grayImg,"adaptive","ForegroundPolarity","dark");

    bwFilled = imfill(bwImg, 'holes');
    edges = edge(bwImg, 'canny');
    %edges = edge(bwFilled, 'canny');


    %%% To do:
    smoothedImage = imgaussfilt(grayImg, 4); % Adjust sigma as needed
    edges = edge(smoothedImage, 'canny');


    % se = strel('line', 5, 0); % Structuring element for morphological operations
    % edges = imdilate(edges, se); % Dilate the edge image
    % edges = imerode(edges, se);  % Erode to restore original shape
    %
    % smoothedImage = imgaussfilt(grayImg, 2); % Adjust sigma as needed
    % edges = edge(smoothedImage, 'canny');
    %%%


    [H,T,R]=hough(edges);

    P  = houghpeaks(H,50,'threshold',ceil(0.7*max(H(:))));
    %numPeaks (after H): Maximum number of peaks to detect
    %ceil(xx*max...): Minimum value to be considered a peak
    % The larger the line, the higher the peak. By filtering to a high
    % value, we select the largest lines

    lines = houghlines(edges,T,R,P,'FillGap',150,'MinLength',3);
    %fillGap: Distance between 2 lines to be considered a single line
    % minLength: minimum length for the line to be accepted

    screenSize = get(0, 'ScreenSize');
    % Define the figure dimensions
    figWidth = 800;
    figHeight = 900;

    % Calculate the position for centering
    figX = (screenSize(3) - figWidth) / 2;
    figY = (screenSize(4) - figHeight) / 2;

    % Create the centered figure
    f = figure('Name', 'RealSense Depth Measurement', 'NumberTitle', 'off', ...
        'Position', [figX, figY, figWidth, figHeight]);
    if plotAllResults
        nbRow = 5;
        subplot(nbRow, 1, 1);
        imshow(imgCropped);
        subplot(nbRow, 1, 2);
        imshow(grayImg);
        subplot(nbRow, 1, 3);
        imshow(bwImg);
        subplot(nbRow, 1, 4);
        imshow(edges);
        subplot(nbRow, 1, 5);
    end

    imshow(edges), hold on
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

    % xy = [lines(1).point1; lines(2).point1];
    % plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
    %
    % xy = [lines(1).point2; lines(2).point2];
    % plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
    return;
    figure(2);
    subplot(2,1,1);
    cornersEigen = detectMinEigenFeatures(grayImg);
    imshow(grayImg); hold on;
    plot(cornersEigen.selectStrongest(50));

    cornersHarris = detectHarrisFeatures(grayImg);
    subplot(2,1,2);
    imshow(grayImg); hold on;
    plot(cornersHarris.selectStrongest(50));
    return;





    [H,T,R]=hough(edges);
    P  = houghpeaks(H,1,'threshold',ceil(0.3*max(H(:))));
    lines = houghlines(bwFilled,T,R,P,'FillGap',5,'MinLength',7);

    imshow(color,[]),hold on
    xy = [lines(1).point1; lines(1).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    % plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    hold off;


    I=imrotate(color,90+lines(1).theta);

    % Select the first line for cropping
    selectedLine = lines(1);
    x1 = selectedLine.point1(1); % x-coordinate of point 1
    y1 = selectedLine.point1(2); % y-coordinate of point 1
    x2 = selectedLine.point2(1); % x-coordinate of point 2
    y2 = selectedLine.point2(2); % y-coordinate of point 2;

    % Calculate bounding box around the line
    padding = 20; % Add padding around the line
    xMin = max(1, min(x1, x2) - padding);
    xMax = min(size(color, 2), max(x1, x2) + padding);
    yMin = max(1, min(y1, y2) - padding);
    yMax = min(size(color, 1), max(y1, y2) + padding);

    % Crop the image
    croppedImg = color(yMin:yMax, xMin:xMax, :);
    figure(2);
    imshow(croppedImg);
    return;



    if mod(lines(1).theta,90)-45<0
        hcrop=find(I(:,3)>0,1);
        wcrop=length(I(1,:))-find(I(3,end:-1:1)>0,1);
    end
    if mod(lines(1).theta,90)-45>0
        hcrop=find(I(end:-1:1,3)>0,1);
        wcrop=length(I(1,:))-find(I(3,:)>0,1);
    end
    return;
    I=I(hcrop:end-hcrop,end-wcrop:wcrop);
    Iscaled=uint8(255*double(I)./double(max(I(:))));
    rgbI=repmat(Iscaled,1,1,3);
    wpos=zeros(1,3*100);wneg=wpos;w=1;p=1;
    upcorner=-1.*ones(1,200);botcorner=upcorner;c=1;
    position=zeros(100,2);
    index=1:5:length(I(1,:));
    for i=1:5:length(I(1,:))
        window=double(I(:,i));
        x=gradient(window);
        xm=medfilt1(x,10);
        xmpos=xm.*(xm>0);
        xmneg=xm.*(xm<0);
        maxpos=(islocalmax(xmpos,'MinSeparation',50,'MinProminence',0.4*max(xmpos),'MaxNumExtrema',3));
        maxneg=(islocalmin(xmneg,'MinSeparation',50,'MinProminence',abs(0.4*min(xmneg)),'MaxNumExtrema',3));
        maxposf=find(maxpos);maxnegf=find(maxneg);
        if isempty(maxposf)
            maxposf=1;
        end
        if isempty(maxnegf)
            maxnegf=1;
        end
        wpos(w:w+length(maxposf)-1)=maxposf;
        wneg(w:w+length(maxnegf)-1)=maxnegf;

        upcorner(c)=wneg(w);
        botcorner(c)=wpos(w+length(maxnegf)-1);

        l=length(maxposf)+length(maxnegf);
        position(p:p+l-1,:)=[ ones(l,1)*i [maxposf;maxnegf]];
        w=w+length(maxposf);
        p=p+l;
        c=c+1;
        %     plot(maxpos);hold on
        %     plot(maxneg);
    end

    return;
    upcorner=upcorner(upcorner>=0);
    botcorner=botcorner(botcorner>=0);
    index=index(1:min(length(upcorner),length(botcorner)));
    maskup=abs(upcorner-median(upcorner))<0.35*median(upcorner);
    maskbot=abs(botcorner-median(botcorner))<0.35*median(botcorner);
    validupcorner=upcorner.*maskup+0.*(~maskup);
    validbotcorner=botcorner.*maskbot+0.*(~maskbot);
    validindex=index(and(validbotcorner>0,validupcorner>0));

    validupcorner=validupcorner(and(maskup,maskbot));
    validbotcorner=validbotcorner(and(maskup,maskbot));

    % up=insertMarker(rgbI,[index' botcorner'],"circle","Size",1,"Color","green");
    % upgreen=up(:,:,2);
    % upgreen=upgreen==max(upgreen);
    % upgreen=imclose(upgreen,strel('disk',10));
    % upgreenedge=edge(upgreen,'canny');
    % figure(10), imshow(up,[]), hold on
    % [H,T,R]=hough(upgreenedge);
    % P  = houghpeaks(H,1);
    % lines = houghlines(upgreenedge,T,R,P);
    % xy = [lines(1).point1; lines(1).point2];
    % plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    % % plot beginnings and ends of lines
    % plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    % plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    % hold off;

    figure(1)
    imshow(insertMarker(rgbI,[index' upcorner'],"Size",10,"Color","green"),[])
    figure(2)
    imshow(insertMarker(rgbI,[index' botcorner'],"Size",10,"Color","green"),[])
    figure(3)
    imshow(insertMarker(rgbI,[validindex' validupcorner'],"Size",10,"Color","green"),[])
    figure(4)
    imshow(insertMarker(rgbI,[validindex' validbotcorner'],"Size",10,"Color","green"),[])
    hold off;
    widthPalet=-1*ones(1,100);j=1;
    for i=1:length(validindex)

        widthPalet(j)=measure({validindex(i),validupcorner(i)},{validindex(i),validbotcorner(i)},I);
        j=j+1;
    end
    widthP=median(widthPalet(widthPalet>=0));
    fprintf('Palet width= %.2f cm\n',widthP*100)


    %color_img_resized = imresize(color, [480, 640]);
    % % Convert to grayscale
    % grayImg = rgb2gray(color_img_resized);
    %
    % % Thresholding to create binary image
    % bwImg = imbinarize(grayImg, 'adaptive', 'Sensitivity', 0.5);
    %
    % % Fill holes to make regions solid
    % bwFilled = imfill(bwImg, 'holes');
    %
    % % Detect edges using Canny method
    % edges = edge(bwFilled, 'canny');
    %
    % % Find contours
    % [B, L] = bwboundaries(bwFilled, 'noholes');
    %
    % % Analyze the largest contour
    % stats = regionprops(L, 'Area', 'BoundingBox');
    % [~, idx] = max([stats.Area]);
    %
    % % Extract bounding box for the largest area
    % boundingBox = stats(idx).BoundingBox;
    %
    % % Calculate expected pallet area (assuming a rectangular shape)
    % expectedArea = boundingBox(3) * boundingBox(4);
    %
    % % Actual area of the detected region
    % detectedArea = stats(idx).Area;
    %
    % % Display result
    % figure;
    % imshow(color_img_resized);
    % hold on;
    % rectangle('Position', boundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
    % title(['Pallet Status: ', ifelse(isComplete, 'Complete', 'Incomplete')]);
    % hold off;



    %imwrite(depth,"mahel\detect_missing_part\img\img4.jpeg");

    %imshowpair(depth,color_img_resized,"montage");

    %while (ishandle(f) && frame.isActive)
    % Wait for a new frame set
    %end

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