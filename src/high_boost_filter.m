function [imgOut] = high_boost_filter(imgIn, amplification_coef, filter_name, filter_order, cutoff_freq)
    %High Boost Filter. This function is to make an image brighter by doing amplification on original image and then substract with lowpass filter
    imgOut = amplification_coef .* imgIn - pass_filter(imgIn, 'low', filter_name, filter_order, cutoff_freq)

end
