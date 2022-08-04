clear, close all;
clc;

load ../res/hall.mat;
sample = hall_gray(57:64, 73:80) - 128;

subplot(1,4,1);
imshow(sample);
title("origin");

c1 = dct2(sample)';
transpose_image = uint8(idct2(c1)) + 128;
subplot(1,4,2);
imshow(transpose_image);
title("transpose");

c2 = rot90(dct2(sample));
rot90_image = uint8(idct2(c2)) + 128;
subplot(1,4,3);
imshow(rot90_image);
title("rot90");

c3 = rot90(dct2(sample), 2);
rot180_image = uint8(idct2(c3)) + 128;
subplot(1,4,4);
imshow(rot180_image);
title("rot180");

