function [filter_arr] = butterworth(D, cutoff_freq, filter_order)
    %BUTTERWORTH Generate Butterworth filter array

    filter_arr = 1 / (1 + (D / cutoff_freq)^(2 * filter_order))

end
