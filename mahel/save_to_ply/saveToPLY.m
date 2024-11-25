function saveToPLY(path,X,Y,Z)
    % Number of points
    num_points = length(X);
    
    % Open a file to write PLY data
    fileID = fopen(path+'pointcloud.ply', 'w');
    
    % Write PLY header
    fprintf(fileID, 'ply\n');
    fprintf(fileID, 'format ascii 1.0\n');
    fprintf(fileID, 'element vertex %d\n', num_points);
    fprintf(fileID, 'property float x\n');
    fprintf(fileID, 'property float y\n');
    fprintf(fileID, 'property float z\n');
    fprintf(fileID, 'end_header\n');
    
    % Write vertex data
    for i = 1:num_points
        fprintf(fileID, '%f %f %f\n', X(i), Y(i), Z(i));
    end
    
    % Close the file
    fclose(fileID);
end