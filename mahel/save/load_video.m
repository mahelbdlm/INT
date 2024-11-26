% Import video file and work with it

targetPath = "mahel/detect_missing_part/test1"; % Path of the video file
fps = 30;

try
    frame = getFrames(targetPath,"mahel"); % The frames will be obtained using the camera and mahel file format
    frame = frame.init(); % Initialize the frame class
    
    for i=1:150
        [frame,depth,color] = frame.get_frame_at_index(i); %125 to work
        imshow(color, []);
        drawnow;
    end
    
    %montage(imageArr,'Size', [round(imgindex/numberImagesHorizontal)-1, numberImagesHorizontal]);

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
%imwrite(imageArr{imgindex-2}, "palet1_color.png");