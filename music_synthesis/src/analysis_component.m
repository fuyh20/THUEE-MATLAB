function [freq, amplitude] = analysis_component(wave, fs)
    freq = zeros(1, 7);
    amplitude = zeros(1, 7);
    n = 2^nextpow2(length(wave));
    X = fft(wave, n) / length(wave);
    f = fs/2 * linspace(0, 1, n/2+1);
    X = 2 * abs(X(1:n/2+1));
    %plot(f, X);
    err = floor(n/fs);
    for i = 2:length(X)-1
        if (X(i) > 0.02) && (X(i) > X(i-1)) && (X(i) > X(i+1))
            freq(1) = f(i); amplitude(1) = 1;
            break;
        end
    end
    
    if freq(1) == 0
    for i = 2:length(X)-1
        if (X(i) > 0.015) && (X(i) > X(i-1)) && (X(i) > X(i+1))
            freq(1) = f(i); amplitude(1) = 1;
            break;
        end
    end
    end

    for j = 2:7
        for k = j*(i-err):j*(i+err)
            if (k < length(X)) && (X(k) > 0.05*X(i)) && (X(k) > X(k-1)) && (X(k) > X(k+1))
                amplitude(j) = X(k)/X(i);
                freq(j) = f(k);
                break
            end
        end
    end
end