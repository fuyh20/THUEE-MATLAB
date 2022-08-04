clear, close all;
clc;

load ../res/snow.mat;
load ../res/JpegCoeff.mat;

[dc_stream, ac_stream, img_height, img_width] = JPEG_encode(snow, QTAB, DCTAB, ACTAB);
img = JPEG_decode(dc_stream', ac_stream', img_height, img_width, QTAB, ACTAB);

CR = (img_width*img_height*8) / (length(dc_stream)+length(ac_stream));
disp(CR);
MSE = sum((double(img) - double(snow)).^2, 'all') / (img_height * img_width);
PSNR = 10 * log10(255 * 255 / MSE);
disp(PSNR);

subplot(1,2,1);
imshow(snow);
title("origin");
subplot(1,2,2);
imshow(img);
title("PSNR = "+ PSNR);