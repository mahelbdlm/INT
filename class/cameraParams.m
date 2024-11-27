classdef cameraParams
    %USERPARAMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        depthHighAccuracy
        cameraWidth
        cameraHeight
        FPS
        defaultSizeColor
        depthHighDensity
    end
    
    methods
        function cameraParams = cameraParams()
            cameraParams.depthHighAccuracy = 0;
            cameraParams.cameraWidth = 640;
            cameraParams.cameraHeight = 480;
            cameraParams.FPS = 30;
            cameraParams.defaultSizeColor=0;
            cameraParams.depthHighDensity = 1;
        end
        
        function cameraParams=setOptimalSize(cameraParams)
            cameraParams.cameraWidth = 848;
            cameraParams.cameraHeight = 480;
            cameraParams.FPS = 30;
        end

        function cameraParams=setDepthHighAccuracy(cameraParams)
            cameraParams.depthHighAccuracy = 1;
            cameraParams.depthHighDensity = 0;
        end

        function cameraParams=setDepthHighDensity(cameraParams)
            cameraParams.depthHighDensity = 1;
            cameraParams.depthHighAccuracy = 0;
        end

        function cameraParams=setWidthAndHeight(cameraParams, w, h)
            cameraParams.cameraWidth = w;
            cameraParams.cameraHeight = h;
        end

        function cameraParams=setFPS(cameraParams, fps)
            cameraParams.FPS = fps;
        end

        function cameraParams=setDefaultSizeColor(cameraParams)
            cameraParams.defaultSizeColor = 1;
        end
    end
end

