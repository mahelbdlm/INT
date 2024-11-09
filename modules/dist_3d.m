% Last updated: 09/11/2024 18:05

% Function to compute Euclidean distance between two 3D points
function dist = dist_3d(intrinsics, frame, u, v)
   % Convert pixels to 3D points
    upixel = round(u/2);
    vpixel = round(v/2);

    % Convert the frame to depth frame
    depthFrame3D = frame.as('depth_frame');

    % Query the frame for distances at the pixel coordinates
    udist = depthFrame3D.get_distance(upixel(1), upixel(2));
    vdist = depthFrame3D.get_distance(vpixel(1), vpixel(2));

    % Deproject from pixel to 3D space using the intrinsic parameters
    % Using the deprojection formula
    upoint = [(upixel(1) - intrinsics.ppx) * udist / intrinsics.fx, ...
              (upixel(2) - intrinsics.ppy) * udist / intrinsics.fy, ...
              udist];  % [X, Y, Z]

    vpoint = [(vpixel(1) - intrinsics.ppx) * vdist / intrinsics.fx, ...
              (vpixel(2) - intrinsics.ppy) * vdist / intrinsics.fy, ...
              vdist];  % [X, Y, Z]

    % Calculate Euclidean distance between two points
    dist = sqrt(sum((upoint - vpoint).^2));
end