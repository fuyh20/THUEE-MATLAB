clear, close all;
clc;

load ../res/hall.mat;
load ../res/JpegCoeff.mat;

QTAB = QTAB / 2;
[dc_stream, ac_stream, img_height, img_width] = JPEG_encode(hall_gray, QTAB, DCTAB, ACTAB);
img = JPEG_decode(dc_stream', ac_stream', img_height, img_width, QTAB, ACTAB);

CR = (img_width*img_height*8) / (length(dc_stream)+length(ac_stream));
disp(CR);
MSE = sum((double(img) - double(hall_gray)).^2, 'all') / (img_height * img_width);
PSNR = 10 * log10(255 * 255 / MSE);
disp(PSNR);

subplot(1,2,1);
imshow(hall_gray);
title("origin");
subplot(1,2,2);
imshow(img);
title("PSNR = "+ PSNR);
