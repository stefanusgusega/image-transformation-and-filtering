function [freqOut] = notch_filter(freqIn, arr_x, arr_x1, arr_y, arr_y1)
    % arr_noise_x = [x1, x2, ..., xi, ]
    % arr_noise_x1 = [x1', x2', ..., xi']
    % arr_noise_y = [y1, y2, ..., yi]
    % arr_noise_y1 = [y1', y2', ..., yi']

    %if ~(((size(arr_x) == size(arr_x1)) && (size(arr_x) == size(arr_y))) && (size(arr_y) == size(arr_y1)))
    %    throw(MException('ArrayError:differentSize', 'Array of coordinates should have the same length.'))
    %end
    freqOut = freqIn;
    [M, N] = size(arr_x);

    for i=1:(N)
        for xi=arr_x(i):arr_x1(i)
            for yi=arr_y(i):arr_y1(i)
                freqOut(xi,yi) = 0;
            end
        end
    end

end