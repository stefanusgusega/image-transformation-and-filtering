function [f,F2] = fourier_spectrum(imgIn)
    % Tampilkan magnitute spektrum Fourier, mengembalikan hasil fft +
    % spectrum untuk didisplay
    [M, N, D] = size(imgIn);

    % Check dimension
    if ~(D == 1)
        throw(MException('ImageError:sizeNotOne', 'The input image should be 1D array. Current: %dD array.', D))
    end

    im = im2double(imgIn);
    f = fft2(im);
    f = fftshift(f);
    disp(size(f));

    F2 = f;
    F2 = abs(F2); % Get the magnitude
    F2 = log(1+F2); % Use log

    %disp(size(F2));
    %disp(min(F2,[],'all'));
    %disp(max(F2,[],'all'));
    figure, imagesc(F2); colormap("gray");
    title('magnitude spectrum');
end