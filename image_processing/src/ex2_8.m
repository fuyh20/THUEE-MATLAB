clear, close all;
clc;

load ../res/hall.mat;
load ../res/JpegCoeff.mat;

c = blockproc(double(hall_gray)-128, [8 8], ...
    @(block_struct) zig_zag(round(dct2(block_struct.data)./QTAB)));
[row, col] = size(c);
res = zeros([64, row/64*col]);
for i = 1:row/64
    res(:, (i-1)*col+1:i*col) = c((i-1)*64+1:i*64, 1:col);
end