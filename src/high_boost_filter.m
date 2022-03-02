function [imgOut] = high_boost_filter(imgIn, amplification_coef, filter_name, cutoff_freq, filter_order)
    %High Boost Filter. This function is to make an image brighter by doing amplification on original image and then substract with lowpass filter
    im = im2double(imgIn);

    % Get the Fourier spectrum of the image
    fourier_spectrum = fourier_spectrum(im)

    switch filter_name
        case 'butterworth'
            pf = pass_filter(imgIn, 'low', filter_name, cutoff_freq, filter_order);
        otherwise
            pf = pass_filter(imgIn, 'low', filter_name, cutoff_freq);
    end

    filter_with_amp = amplification_coef - pf;

    imgOut = filter_with_amp .* fourier_spectrum;

end
