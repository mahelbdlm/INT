function [lineLengths] = distanceHoughLines(image, lines)
    % Display the image
    imshow(image), hold on;
    
    % Initialize the array to store line lengths
    lineLengths = zeros(1, length(lines));
    max_len = 0;
    
    for k = 1:length(lines)
        % Get the endpoints of the line
        xy = [lines(k).point1; lines(k).point2];
    
        % Plot the line
        plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
    
        % Plot beginnings and ends of lines
        plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
        plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'red');
    
        % Calculate and store the length of the line
        len = norm(lines(k).point1 - lines(k).point2);
        lineLengths(k) = len;
    
        % Determine the endpoints of the longest line segment
        if (len > max_len)
            max_len = len;
            xy_long = xy;
        end
    end