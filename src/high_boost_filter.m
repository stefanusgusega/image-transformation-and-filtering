function [imgOut] = high_boost_filter(imgIn, amplification_coef, filter_name, cutoff_freq, filter_order)
    %High Boost Filter. This function is to make an image brighter by doing amplification on original image and then substract with lowpass filter
    im = im2double(imgIn);

    switch filter_name
        case 'butterworth'
            pf = pass_filter(imgIn, 'low', filter_name, cutoff_freq, filter_order);
        otherwise
            pf = pass_filter(imgIn, 'low', filter_name, cutoff_freq);
    end

    imgOut = amplification_coef .* im - pf;

end
