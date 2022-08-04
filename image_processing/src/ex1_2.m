clear, close all;
clc;

load ../res/hall.mat
[row, col, ~] = size(hall_color);
row_idx = repmat((1:row)', 1, col);
col_idx = repmat(1:col, row, 1);

% (1)
img_circle = hall_color;
radius = min(row/2, col/2);
dist = distance(row_idx , col_idx, (row+1)/2, (col+1)/2);
circle = (dist < radius^2) & (dist > 0.97 * radius^2);
img_circle(circle) = 255;
circle = ~circle;
img_circle(:,:,2:3) = img_circle(:,:,2:3).*uint8(circle);
subplot(1,2,1)
imshow(img_circle);

% (2)
img_chessboard = hall_color;
mask = mod(row_idx + col_idx, 2);
img_chessboard = img_chessboard.*uint8(mask);
subplot(1,2,2)
imshow(img_chessboard);

function y = distance(x1, y1, x2, y2)
    y = (x1 - x2).^2 + (y1 - y2).^2;
end