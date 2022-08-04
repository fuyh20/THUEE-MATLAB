clear, close all;
clc;

load jpegcodes.mat;
CR = (img_width*img_height*8) / (length(dc_stream)+length(ac_stream));
disp(CR)