clear, close all;
clc;

load ../res/hall.mat;

c1 = dct2(hall_gray(1:8, 1:8) - 128);
c2 = dct2(hall_gray(1:8, 1:8)) - dct2(zeros(8, 8) + 128);
