clear, close all;
clc;

load ../res/hall.mat;
load ../res/JpegCoeff.mat;
[dc_stream, ac_stream, img_height, img_width] = JPEG_encode(hall_gray, QTAB, DCTAB, ACTAB);
save('jpegcodes.mat', 'dc_stream', 'ac_stream', 'img_height', 'img_width');