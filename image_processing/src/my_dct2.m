function C = my_dct2(P)
    N = size(P,1);
    D = (zeros([N - 1, N]) + [1 : 1 : N-1]') .* [1 : 2 : 2*N-1];
    D = sqrt(2 / N) * [zeros(1, N) + sqrt(1/2); cos(D * pi / (2*N))];
    C = D * double(P) * D';
end

