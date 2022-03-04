function [dispf] = display_spectrum(freq)
    % Tampilkan magnitute spektrum Fourier, mengembalikan hasil fft +
    % spectrum untuk di-display
    
    dispf = freq;
    dispf = abs(dispf); % Get the magnitude
    dispf = log(1 + dispf); % Use log

    %figure, imagesc(F2); colormap("gray");
    %title('magnitude spectrum');
end