clear, close all;
clc;

load ../res/hall.mat;
load ../res/JpegCoeff.mat;
test_time = 100;
correct = 0;
img = double(hall_gray);
max_length = numel(img);

for i = 1:test_time
    seq = randi([0, 1], 1, randi(max_length));
    secret = [seq, zeros(1, max_length - length(seq))];
    encode_data = reshape(bitand(img, zeros(size(img))), 1, []) + secret;
    encode_data = reshape(encode_data, size(img));
    [dc_stream, ac_stream, img_height, img_width] = JPEG_encode(encode_data, QTAB, DCTAB, ACTAB);
    decode_data = JPEG_decode(dc_stream', ac_stream', img_height, img_width, QTAB, ACTAB);
    secret_decode = reshape(decode_data, 1, []);
    secret_decode = mod(secret_decode(1:length(seq)), 2);
    correct = correct + sum(secret_decode == seq) / length(seq);
end
disp(correct / 100);