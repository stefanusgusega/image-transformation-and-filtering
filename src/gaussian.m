function [filter_arr] = gaussian(D, cutoff_freq)
    %GAUSSIAN Generate Gaussian filter array

    filter_arr = exp(-(D.^2)./(2*(cutoff_freq^2)));

end
