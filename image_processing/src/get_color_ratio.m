function output = get_color_ratio(img, L)
bins = 0:2^(3*L);
img = floor(double(img) / 2^(8-L));
pixel = img(:, :, 1) * 2^(2*L) + img(:, :, 2) * 2^L + img(:, :, 3);
pixel = reshape(pixel, 1, []);
output = histcounts(pixel, bins) * 3 / numel(img);
end
