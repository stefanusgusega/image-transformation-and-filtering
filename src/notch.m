function [imgOut] = notch(imgIn, noise_type)
    %LPF lowpass filter function
    [M, N, D] = size(imgIn);

    % Check dimension
    if ~(D == 1)
        throw(MException('ImageError:sizeNotOne', 'The input image should be 1D array. Current: %dD array.', D))
    end

    if ~(noise_type)
        noise_type = 'z';
    end

    %figure, imshow(imgIn);

    % Mengubah gambar ke ranah frekuensi
    im = im2double(imgIn);
    f = fft2(im);
    freqIn = fftshift(f);

    switch noise_type
        case 'a'
            arr_x  = [177, 177, 177, 197, 197, 197,  70, 325,  49, 304];
            arr_x1 = [187, 187, 187, 207, 207, 207,  80, 335,  59, 314];
            arr_y  = [ 49, 177, 304,  70, 197, 325, 197, 197, 177, 177];
            arr_y1 = [ 59, 187, 314,  80, 207, 335, 207, 207, 187, 187];

        case 'b'
            arr_x  = [ 27,  85, 150, 355, 410, 480, 155, 355, 155, 355,  30,  95, 155, 350, 420, 480, 150, 355, 150, 355];
            arr_x1 = [ 37, 105, 170, 365, 430, 500, 170, 365, 170, 365,  50, 115, 175, 370, 440, 510, 170, 375, 170, 375];
            arr_y  = [120, 120, 120, 130, 130, 130,   1,   1,  55,  55, 385, 385, 385, 385, 385, 385, 455, 455, 520, 520];
            arr_y1 = [140, 140, 140, 140, 140, 140,  10,  10,  70,  70, 405, 405, 405, 405, 405, 405, 475, 475, 525, 525];
        
        case 'c'
            arr_y  = [ 26,  42,  58,  74,  90, 106, 122, 153, 170, 185, 202, 218, 234, 250];
            arr_y1 = [ 31,  47,  63,  79,  94, 111, 126, 157, 174, 191, 206, 222, 238, 254];
            arr_x  = [252, 236, 218, 203, 187, 171, 155, 122, 107,  91,  75,  59,  43,  27];
            arr_x1 = [254, 238, 224, 207, 191, 175, 159, 126, 111,  95,  79,  63,  47,  31];

        case 'z'
            % ambil dari input user
            
    end

    % set semua pixel pada range menjadi 0
    freqOut = notch_filter(freqIn, arr_x, arr_x1, arr_y, arr_y1);
    
    %display_spectrum(freqIn);
    %display_spectrum(freqOut);

    % kembali ke ranah spasial
    imgOut = real(ifft2(ifftshift(freqOut)));
    %figure, imshow(imgOut,[]);
end