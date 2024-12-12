classdef distanceClass
    %GETDISTANCE Summary of this class goes here
    % This class manages all things related to distance using the depth
    % camera. 
    % It introduces a code to convert the depth point to a 3D point in
    % order to measure the distance in the 2D plane.
    % It also introduces a constant called correctionConstant that was
    % determined using a calibration algorithm and a ruler. Applying this
    % correction factor (assuming the error is constant) makes the measure
    % of sizes more precise.
    
    properties
        intrinsics
        correctionConstant
        depthScale
    end
    
    methods
        function distanceClass = distanceClass(type, arg2)
            distanceClass.correctionConstant = 0.649936; 
                                            % Last value: 0.640920

            if type=="camera"
                % In this case, arg2 is the camera profile
                distanceClass.intrinsics = arg2.get_stream(realsense.stream.depth).as('video_stream_profile').get_intrinsics();
                distanceClass.depthScale = arg2.get_device().first('depth_sensor').get_depth_scale();
            else %From local file
                % In this case, arg2 is the intrinsics from the file
                distanceClass.intrinsics = arg2;
                distanceClass.depthScale = arg2.depth_scale;

            end

            % Model: 
            % 0 = NONE
            % 1 = MODIFIED_BROWN_CONRADY
            % 2 = INVERSE_BROWN_CONRADY
            % 3 = FTHETA
            % 4 = BROWN_CONRADY
            % 5 = KANNALA_BRANDT4
        end
        
        % function pixel = rs2_project_point_to_pixel(distanceClass, point)
        %     % Extract intrinsics parameters
        %     fx = distanceClass.intrinsics.fx;
        %     fy = distanceClass.intrinsics.fy;
        %     ppx = distanceClass.intrinsics.ppx;
        %     ppy = distanceClass.intrinsics.ppy;
        %     coeffs = distanceClass.intrinsics.coeffs; % Distortion coefficients
        %     model = distanceClass.intrinsics.model;
        % 
        %     % Normalize point
        %     x = point(1) / point(3);
        %     y = point(2) / point(3);
        % 
        %     if model == 1 % RS2_DISTORTION_MODIFIED_BROWN_CONRADY
        %         r2 = x^2 + y^2;
        %         f = 1 + coeffs(1)*r2 + coeffs(2)*r2^2 + coeffs(5)*r2^3;
        %         x = x * f;
        %         y = y * f;
        %         dx = x + 2 * coeffs(3) * x * y + coeffs(4) * (r2 + 2 * x^2);
        %         dy = y + 2 * coeffs(4) * x * y + coeffs(3) * (r2 + 2 * y^2);
        %         x = dx;
        %         y = dy;
        %     elseif model == 3 % RS2_DISTORTION_FTHETA
        %         r = sqrt(x^2 + y^2);
        %         rd = (1.0 / coeffs(1)) * atan(2 * r * tan(coeffs(1) / 2.0));
        %         x = x * rd / r;
        %         y = y * rd / r;
        %     end
        % 
        %     % Compute pixel coordinates
        %     pixel = [x * fx + ppx, y * fy + ppy];
        % end

        function distanceClass = set_correction_constant(distanceClass, correction_constant)
           distanceClass.correctionConstant = correction_constant;
        end

        function distance = getDistance(distanceClass, upoint_3D, vpoint_3D)
            % INPUT: upoint_3D, vpoint_3D
            % OUTPUT: the distance between the two 3D points
            if (length(upoint_3D)~=3 || length(vpoint_3D)~=3)
                error("The points must be 3D points. You can use deproject_pixel to convert the points to 3D.");
            end
            distance = distanceClass.correctionConstant*sqrt((upoint_3D(1) - vpoint_3D(1))^2 + (upoint_3D(2) - vpoint_3D(2))^2 + (upoint_3D(3) - vpoint_3D(3))^2);
        end

        function point = deproject_pixel_to_point(distanceClass, pixel, depthDistance)
            % Extract intrinsics parameters
            fx = distanceClass.intrinsics.fx;
            fy = distanceClass.intrinsics.fy;
            ppx = distanceClass.intrinsics.ppx;
            ppy = distanceClass.intrinsics.ppy;
            coeffs = distanceClass.intrinsics.coeffs; % Distortion coefficients
            model = distanceClass.intrinsics.model;

            if(model == 1 || model==3)
                error("This function does not support the current distortion model of the camera.\n")
            end
        
            % Normalize pixel
            x = (pixel(1) - ppx) / fx;
            y = (pixel(2) - ppy) / fy;
        
            if model == 2 % RS2_DISTORTION_INVERSE_BROWN_CONRADY
                r2 = x^2 + y^2;
                f = 1 + coeffs(1)*r2 + coeffs(2)*r2^2 + coeffs(5)*r2^3;
                ux = x * f + 2 * coeffs(3) * x * y + coeffs(4) * (r2 + 2 * x^2);
                uy = y * f + 2 * coeffs(4) * x * y + coeffs(3) * (r2 + 2 * y^2);
                x = ux;
                y = uy;
            end
        
            % Compute 3D point
            point = [depthDistance * x, depthDistance * y, depthDistance];
        end

        % function to_point = rs2_transform_point_to_point(distanceClass, from_point, extrin)
        %     % Extract extrinsic parameters
        %     rotation = reshape(extrin.rotation, [3, 3]);
        %     translation = extrin.translation;
        % 
        %     % Transform the point
        %     to_point = rotation * from_point(:) + translation(:);
        % end
        % 
        % function fov = rs2_fov(intrin)
        %     % Extract intrinsics parameters
        %     fx = distanceClass.intrinsics.fx;
        %     fy = distanceClass.intrinsics.fy;
        %     width = distanceClass.intrinsics.width;
        %     height = distanceClass.intrinsics.height;
        %     ppx = distanceClass.intrinsics.ppx;
        %     ppy = distanceClass.intrinsics.ppy;
        % 
        %     % Compute FOV
        %     fov_x = atan2d(ppx + 0.5, fx) + atan2d(width - (ppx + 0.5), fx);
        %     fov_y = atan2d(ppy + 0.5, fy) + atan2d(height - (ppy + 0.5), fy);
        %     fov = [fov_x, fov_y];
        % end


    end
end

