clear, close all;
clc;

load ../res/hall.mat;
load ../res/JpegCoeff.mat;

img = double(hall_gray) - 128;
[img_height, img_width] = size(img);
c = blockproc(img, [8, 8], @(block_struct) zig_zag(round(dct2(block_struct.data) ./ QTAB)));
[h, w] = size(c);
c_res = zeros([64, h / 64 * w]);
for i = 1:h/64
    c_res(:, (i - 1) * w + 1 : i * w) = c((i - 1) * 64 + 1 : i * 64, 1 : w);
end
code1 = randi([0, 1], size(c_res, 1), size(c_res, 2));
code2 = randi([0, 1], 1, size(c_res, 2));
c_hide1 = double(bitset(int64(round(c_res)), 1, code1));
c_hide2 = c_res;
[~, min_idx] = min(zig_zag(QTAB));
c_hide2(min_idx, :) = double(bitset(int64(round(c_res(min_idx, :))), 1, code2));
code3 = code2;
code3_transfrom = code3;
code3_transfrom(code3 == 0) = -1;
c_hide3 = zeros(size(c_res));
for i = 1:size(c_res, 2)
    seq = c_res(:, i);
    if seq == 0
        c_hide3(:, i) = [code3_transfrom(i); c_res(2:end, i)];
    else
        not_zero = flipud(seq ~= 0);
        seq = flipud(seq);
        [~, idx] = max(not_zero);
        if idx == 1
            seq(1) = code3_transfrom(i);
        else
            seq(idx-1) = code3_transfrom(i);
        end
        c_hide3(:, i) = flipud(seq);
    end
end

[dc_stream1, ac_stream1] = encode(c_hide1, DCTAB, ACTAB);
[dc_stream2, ac_stream2] = encode(c_hide2, DCTAB, ACTAB);
[dc_stream3, ac_stream3] = encode(c_hide3, DCTAB, ACTAB);

[img1, coef1] = decode(dc_stream1', ac_stream1', img_height, img_width, QTAB, ACTAB);
[img2, coef2] = decode(dc_stream2', ac_stream2', img_height, img_width, QTAB, ACTAB);
[img3, coef3] = decode(dc_stream3', ac_stream3', img_height, img_width, QTAB, ACTAB);

decode1 = [];
decode2 = [];
decode3 = [];
h_code = size(c_hide1,1);
h_coef = size(coef1, 1);
w_coef = size(coef1, 2);

for i = 1:h_coef/h_code
    decode1 = [decode1, coef1(h_code*(i-1)+1:h_code*i, 1:w_coef)];
    decode2 = [decode2, coef2(h_code*(i-1)+1:h_code*i, 1:w_coef)];
    decode3 = [decode3, coef3(h_code*(i-1)+1:h_code*i, 1:w_coef)];
end

decode1 = double(bitget(int64(round(decode1)), 1));
decode2 = double(bitget(int64(round(decode2(min_idx, :))), 1));
decode3_bak = decode3;
decode3 = uint8(zeros([1, size(decode3_bak, 2)]));
for i = 1:size(decode3_bak, 2)
    this_seq = flipud(decode3_bak(:, i));
    is_zero = this_seq ~= 0;
    [~, idx] = max(is_zero);
    if this_seq(idx) == 1
        decode3(i) = 1;
    elseif this_seq(idx) == -1
        decode3(i) = 0;
    end
end

psnr1 = PSNR(img1, hall_gray);
psnr2 = PSNR(img2, hall_gray);
psnr3 = PSNR(img3, hall_gray);

cr1 = CR(img1, dc_stream1, ac_stream1);
cr2 = CR(img2, dc_stream2, ac_stream2);
cr3 = CR(img3, dc_stream3, ac_stream3);

acc = [sum(code1 == decode1, 'all') / (size(code1, 1) * size(code1, 2)), ...
       sum(code2 == decode2, 'all') / (size(code2, 1) * size(code2, 2)), ...
       sum(code3 == decode3, 'all') / (size(code3, 1) * size(code3, 2))];
disp(acc);

subplot(2,3,2);
imshow(hall_gray);
title("origin");
subplot(2,3,4);
imshow(img1);
title({"embed1 " + "PSNR: " + psnr1; "CR: " + cr1});
subplot(2,3,5);
imshow(img2);
title({"embed2 " + "PSNR: " + psnr2; "CR: " + cr2});
subplot(2,3,6);
imshow(img3);
title({"embed3 " + "PSNR: " + psnr3; "CR: " + cr3});




function [dc_stream, ac_stream] = encode(res, DCTAB, ACTAB)
cD = res(1, :)';
cD = [cD(1); -diff(cD)];
category = ceil(log2(abs(cD) + 1));
dc_stream = cell2mat(arrayfun(@(i) ...
    [DCTAB(category(i)+1, 2:DCTAB(category(i)+1, 1)+1), my_dec2bin(cD(i))]', ...
    (1:length(cD))', 'UniformOutput', false));
ac_stream = [];
ZRL = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1];
EOB = [1, 0, 1, 0];
ac = res(2:end, :);
Size = ceil(log2(abs(ac) + 1));
for i = 1:size(ac, 2)
    ac_tmp = ac(:, i);
    Size_tmp = Size(:, i);
    last_not_zero_idx = 0;
    not_zero = ac_tmp ~= 0;
    while sum(not_zero) ~= 0
        [~, new_idx] = max(not_zero);
        Run = new_idx - last_not_zero_idx - 1;
        num_of_ZRL = floor(Run / 16);
        Run = mod(Run, 16);
        this_tab_row = Run*10 + Size_tmp(new_idx);
        ac_stream = [ac_stream, repmat(ZRL, num_of_ZRL, 1), ACTAB(this_tab_row, 4:ACTAB(this_tab_row, 3)+ 3), my_dec2bin(ac_tmp(new_idx))];
        not_zero(new_idx) = 0;
        last_not_zero_idx = new_idx;
    end
    ac_stream = [ac_stream, EOB];
end
ac_stream = ac_stream';
end


function y = my_dec2bin(x)
if x ~= 0
    y = double(dec2bin(abs(x))) - '0';
    if x < 0
        y = ~y;
    end
else
    y = [];
end
end

function [img, coef] = decode(dc_stream, ac_stream, height, width, QTAB, ACTAB)
zigzag_inv = reshape([1, 2, 6, 7, 15, 16, 28, 29;
    3, 5, 8, 14, 17, 27, 30, 43;
    4, 9, 13, 18, 26, 31, 42, 44;
    10, 12, 19, 25, 32, 41, 45, 54;
    11, 20, 24, 33, 40, 46, 53, 55;
    21, 23, 34, 39, 47, 52, 56, 61;
    22, 35, 38, 48, 51, 57, 60, 62;
    36, 37, 49, 50, 58, 59, 63, 64], 1, 64);
blocksize = ceil([height, width] / 8);
blocks = blocksize(1) * blocksize(2);
DC_coeff = zeros(1, blocks);
AC_coeff = zeros(63, blocks);

cnt = 1;
while(cnt <= blocks)
    if(all(dc_stream(1:2) == [0 0]))
        dc_stream(1:2) = [];
    else
        zero_ind = find(dc_stream==0, 1);
        if(zero_ind < 4)
            huffman_code = dc_stream(1:3);
            dc_stream(1:3) = [];
            zero_ind = bin2dec(strjoin(string(huffman_code), '')) - 1;
        else
            dc_stream(1:zero_ind) = [];
            zero_ind = zero_ind + 2;
        end
        mag = bin_vec2dec(dc_stream(1:zero_ind));
        DC_coeff(cnt) = mag;
        dc_stream(1:zero_ind) = [];
    end
    cnt = cnt + 1;
end

for i = 2:blocks
    DC_coeff(i) = DC_coeff(i - 1) - DC_coeff(i);
end

ZRL = [1 1 1 1 1 1 1 1 0 0 1];
EOB = [1 0 1 0];
ACTAB_code = ACTAB(:, 4:19);

huffman = zeros(1, 16);
cnt = 1;
ind = 1;
while cnt <= blocks
    if (length(ac_stream) > 11) && (all(ac_stream(1:11) == ZRL))
        ind = ind + 16;
        ac_stream(1:11) = [];
    elseif(all(ac_stream(1:4) == EOB))
        ind = 1;
        cnt = cnt + 1;
        ac_stream(1:4) = [];
    else
        huffman(:) = 0;
        for i = 1:16
            huffman(i) = ac_stream(i);
            idx = find(ismember(ACTAB_code, huffman, 'rows'), 1);
            if(~isempty(idx) && ACTAB(idx, 3) == i)
                ac_stream(1:i) = [];
                break;
            end
        end
        temp = num2cell(ACTAB(idx, 1:2));
        [c_run, c_size] = deal(temp{:});
        ind = ind + c_run;
        AC_coeff(ind, cnt) = bin_vec2dec(ac_stream(1:c_size));
        ac_stream(1:c_size) = [];
        ind = ind + 1;
    end
end

coef = [DC_coeff; AC_coeff];

inv_zigzag = @(block_struct) ...
    idct2(reshape(block_struct.data(zigzag_inv), [8 8]) .* QTAB);
coef = reshape( ...
    permute( ...
    reshape(coef, 64, blocksize(2), []), ...
    [2 1 3]), ...
    blocksize(2), [])';
inv_img = blockproc(coef, [64, 1], inv_zigzag);
img = uint8(inv_img(1:height, 1:width) + 128);

end

function dec_int = bin_vec2dec(bin_vec)
bin_str = strjoin(string(bin_vec), '');
if (bin_vec(1) == 1)
    dec_int = bin2dec(bin_str);
else
    dec_int = bin2dec(bin_str);
    dec_int = 1 + dec_int - 2^strlength(bin_str);
end
end

function y = PSNR(img, origin)
MSE = sum((double(img) - double(origin)).^2, 'all') / (size(img, 1) * size(img, 2));
y = 10 * log10(255 * 255 / MSE);
end

function y = CR(img, dc_stream, ac_stream)
y = (size(img, 1) * size(img, 2) * 8) / (length(dc_stream)+length(ac_stream));
end
