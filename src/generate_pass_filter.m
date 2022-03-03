function [filter_arr] = generate_pass_filter(p, q, cutoff_freq, name, filter_order)
    %GENERATE_PASS_FILTER Generate filter for low pass and high pass only

    % Setup range of variables
    u = 0:(p - 1);
    v = 0:(q - 1);

    % Compute the indices for use in meshgrids
    idx = find(u > p / 2);
    u(idx) = u(idx) - p;
    idy = find(v > q / 2);
    v(idy) = v(idy) - q;

    % Compute the meshgrid arrays
    [V, U] = meshgrid(v, u);
    D = sqrt(U.^2 + V.^2);

    % Calculate the filter
    switch name
        case 'ideal'
            filter_arr = ideal(D, cutoff_freq);
        case 'butterworth'
            filter_arr = butterworth(D, cutoff_freq, filter_order);
        case 'gaussian'
            filter_arr = gaussian(D, cutoff_freq);
    end

end
