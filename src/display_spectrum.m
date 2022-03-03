function [F2] = display_spectrum(freq)
    % Tampilkan magnitute spektrum Fourier, mengembalikan hasil fft +
    % spectrum untuk didisplay
    
    F2 = freq;
    F2 = abs(F2); % Get the magnitude
    F2 = log(1 + F2); % Use log

    figure, imagesc(F2); colormap("gray");
    title('magnitude spectrum');
end