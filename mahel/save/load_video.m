% Import video file and work with it

targetPath = "mahel/save/palet_con_rodillos4"; %Target path (respect to INT folder)
fps = 30;

try
    path = checkPath(targetPath);
    vid_color= load(path+"/video_color_original.mat").video_color_original;
    vid_depth= load(path+"/video_depth_original.mat").video_depth_original;
    
    imageArr=[];
    imgindex=1;
    numberImagesHorizontal = 4;
    for i=1:length(vid_color)
        imshow(vid_color(i).df);
        drawnow;
        pause(1/fps);
    end
    
    %montage(imageArr,'Size', [round(imgindex/numberImagesHorizontal)-1, numberImagesHorizontal]);

catch error
    % Error handling
    if error.identifier == "MATLAB:UndefinedFunction"
        if contains(error.message, 'checkPath')
            fprintf(2, "The modules folder was not added to your matlab path.\nIt has now been added, you just need to rerun the code.\n");
            addpath('modules');
            %addpath(genpath('modules')) %Add Folder and Its Subfolders to Search Path
        else
            fprintf("Unknown error:\n");
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
%imwrite(imageArr{imgindex-2}, "palet1_color.png");