function [f,F2] = fourier_spectrum(imgIn)
    % Tampilkan magnitute spektrum Fourier, mengembalikan hasil fft +
    % spectrum untuk didisplay
    im = im2double(imgIn);
    f = fft2(im);
    f = fftshift(f);

    F2 = f;
    F2 = abs(F2); % Get the magnitude
    F2 = log(1+F2); % Use log
    figure, imshow(F2,[]);
    title('magnitude spectrum');
end