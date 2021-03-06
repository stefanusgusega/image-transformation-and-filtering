function [imgOut] = pass_filter(imgIn, pass_type, filter_name, cutoff_freq, filter_order)
    %Pass Filter function
    [M, N, D] = size(imgIn);

    % Checking the inputs
    % Check dimension
    if ~(D == 1)
        throw(MException('ImageError:sizeNotOne', 'The input image should be 1D array. Current: %dD array.', D))
    end

    % Check pass type
    if ~(ismember(pass_type, {'high' 'low'}))
        throw(MException('PassTypeError:invalidPassType', "Pass type defined: 'high' or 'low'. %s not defined.", pass_type))
    end

    % Check filter name
    if ~(ismember(filter_name, {'ideal' 'butterworth' 'gaussian'}))
        throw(MException('FilterNameError:invalidFilterName', "Filter name defined: 'ideal', 'butterworth' or 'gaussian'. %s not defined.", filter_name))
    end
    
    % Step 1: set padding parameter P & Q. Umumnya P = 2M, Q = 2N
    P = 2 * M;
    Q = 2 * N;
 
    % Step 2 & 3: fourier transform with padded image
    im = im2double(imgIn);
    ft = fft2(im, P, Q);
 
    % Step 4: generate filter 

    % filter type
    switch filter_name
        case 'butterworth'

            if (~exist('filter_order', 'var'))
                throw(MException('FilterOrder:variableUndefined', 'You should define filter order if using Butterworth filter.'))
            end

            filter_arr = generate_pass_filter(P, Q, cutoff_freq, filter_name, filter_order);

        otherwise
            filter_arr = generate_pass_filter(P, Q, cutoff_freq, filter_name);
    end

    % high or low pass
    if (pass_type == "high")
        filter_arr = 1 - filter_arr;
    end

    % Step 5: Perkalian filter dengan image yang sudah berbentuk frekuensi 
    pf_freq = filter_arr .* ft;

    % Step 6: inverse transform bagian real dari hasil penapisan ke ranah spasial
    pf_real = real(ifft2(pf_freq));

    % Step 7: potong bagian selain padding
    imgOut = pf_real(1:M, 1:N);

end
