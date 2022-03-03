function [freq] = fourier_spectrum(imgIn)
    % transform image to freq spectrum
    im = im2double(imgIn);
    f = fft2(im);
    freq = fftshift(f);
    
    disp(size(freq));
end
