function [imgOut] = notch_filter(imgIn, arr_x, arr_x1, arr_y, arr_y1)
    % arr_noise_x = [x1, x2, ..., xi, ]
    % arr_noise_x1 = [x1', x2', ..., xi']
    % arr_noise_y = [y1, y2, ..., yi]
    % arr_noise_y1 = [y1', y2', ..., yi']
    %if ~(size(arr_x) == size(arr_x1) == size(arr_y) == size(arr_y1))
    %    throw(MException('ImageError:sizeNotOne', 'The input image should be 1D array. Current: %dD array.', D))
    %end
    for i=1:(size(arr_noise_x)-2)

end