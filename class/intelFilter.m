classdef intelFilter
    %FILTERS Summary of this class goes here
    %   Detailed explanation goes here

    properties
        decimation
        depth2disparity
        disparity2depth
        spatial
        temporal
        align_to
    end

    methods
        function intelFilter = intelFilter()
            %FILTERS Construct an instance of this class
            %   Detailed explanation goes here
            intelFilter.decimation = realsense.decimation_filter();
            intelFilter.decimation.set_option(realsense.option.filter_magnitude, 2);

            intelFilter.depth2disparity = realsense.disparity_transform(true); % Depth to disparity
            intelFilter.disparity2depth = realsense.disparity_transform(false); % Disparity to depth

            intelFilter.spatial = realsense.spatial_filter();
            intelFilter.spatial.set_option(realsense.option.holes_fill, 5); % Fill all zero pixels

            intelFilter.temporal = realsense.temporal_filter();

            intelFilter.align_to = realsense.align(realsense.stream.depth);
        end
    end
end

