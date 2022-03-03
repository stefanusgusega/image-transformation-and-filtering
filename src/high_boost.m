function [filter] = high_boost(p, q, amplification_coef, cutoff_freq, filter_name, filter_order)
    %HIGH_BOOST Generate high boost filter matrix
    switch filter_name
        case 'butterworth'
            lpf = generate_pass_filter(P, Q, cutoff_freq, filter_name, filter_order);
        otherwise
            lpf = generate_pass_filter(P, Q, cutoff_freq, filter_name);
    end

    filter = amplification_coef - lpf;

end
