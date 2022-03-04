function [freq] = fourier_spectrum(imgIn)
    % convert image from spatial to freq
    im = im2double(imgIn);
    f = fft2(im);
    freq = fftshift(f);
end