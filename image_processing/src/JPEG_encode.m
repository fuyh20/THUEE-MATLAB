function [dc_stream, ac_stream, img_height, img_width] =JPEG_encode(img, QTAB, DCTAB, ACTAB)
img_height = size(img, 1);
img_width = size(img, 2);

c = blockproc(double(img)-128, [8 8], ...
    @(block_struct) zig_zag(round(dct2(block_struct.data)./QTAB)));
[row, col] = size(c);
res = zeros([64, row/64*col]);
for i = 1:row/64
    res(:, (i-1)*col+1:i*col) = c((i-1)*64+1:i*64, 1:col);
end

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
