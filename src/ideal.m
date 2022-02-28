function [filter_arr] = ideal(D, cutoff_freq)
    %IDEAL Generate Ideal filter array

    filter_arr = double(D <= cutoff_freq);

end