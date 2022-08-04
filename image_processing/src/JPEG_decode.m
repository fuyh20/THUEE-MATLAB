function [img] = JPEG_decode(dc_stream, ac_stream, height, width, QTAB, ACTAB)
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
