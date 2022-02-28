function [imgOut] = LPF(imgIn, filter_name, filter_order)
    %LPF lowpass filter function
    [M,N,D] = size(imgIn);
    
    % Step 1
    P = 2 * M;
    Q = 2 * N;

    % Step 2 & 3 : fourier transform with padded image
    im = im2double(imgIn);
    ft = fft2(im, P, Q);
    
    % Step 4
    cutoff_freq = 0.05 * P;
    
    switch filter_name
        case 'butterworth'
            if (~exist('filter_order','var'))
                throw(MException('FilterOrder:variableUndefined', 'You should define filter order if using Butterworth filter.'))
            end
            filter_arr = generate_filter(P, Q, cutoff_freq, filter_name, filter_order);

        otherwise
            filter_arr = generate_filter(P, Q, cutoff_freq, filter_name);
    end

    % Step 5
    lpf_freq = filter_arr.*ft;

    % Step 6: inverse transform bagian real dari hasil lpf ke ranah semula
    lpf_real = real(ifft2(lpf_freq));

    % Step 7: potong bagian selain padding
    imgOut = lpf_real(1:M, 1:N);

end