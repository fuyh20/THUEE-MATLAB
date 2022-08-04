clear, close all;
clc;

load ../res/hall.mat;

mat = hall_gray(1:8, 1:8) - 128;
c1 = dct2(mat);
c2 = my_dct2(mat);