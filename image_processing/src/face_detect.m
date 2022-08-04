function output = face_detect(img, color_v, L, block_size, stride, threshold, k)
[h, w, ~] = size(img);
img = double(img);
hh = floor((h - block_size(1)) / stride(1) + 1);
ww = floor((w - block_size(2)) / stride(2) + 1);

output = zeros(hh * ww, 3);
for j = 0 : ww - 1
    for i = 0 : hh - 1
        block = img(i * stride(1) + 1 : i * stride(1) + block_size(1), ...
            j * stride(2) + 1 : j * stride(2) + block_size(2), :);
        blk_hist = get_color_ratio(block, L);
        distance = 1 - sum(sqrt(blk_hist .* color_v));
        output(sub2ind([hh, ww], i + 1, j + 1), :) = ...
            [i * stride(1) + 1, j * stride(2) + 1, distance];
    end
end

output = output(output(:, 3) < threshold, :);
output = topkrows(output, k, 3, 'ascend');

output = flip(output(:, 1:2), 2); 
output(:, 3) = block_size(2);
output(:, 4) = block_size(1);
i = 1;
while ( i <= size(output, 1))
    j = i + 1;
    while (j <= size(output, 1))
        if(rectint(output(i, :), output(j, :)))
            output(j, :) = [];
        else
            j = j + 1;
        end
    end
    i = i + 1;
end
end

