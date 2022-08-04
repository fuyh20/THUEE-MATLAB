clear, close all;
clc;

load face_v.mat;
img = imread("../res/faces.jpg");
block_size = [50, 40];
stride = [5, 5];

img_rotate = imrotate(img, 90);
img_resize = imresize(img, [size(img, 1), size(img, 2) * 2]);
img_adjust = imadjust(img,[.2 .3 0; .6 .7 1],[]);

rect_img_rotate = face_detect(img_rotate, v_3, 3, [40, 50], stride, 0.5, 100);
rect_img_resize = face_detect(img_resize, v_3, 3, [50, 80], stride, 0.5, 100);
rect_img_adjust = face_detect(img_adjust, v_3, 3, block_size, stride, 0.5, 100);
img_rotate = insertShape(img_rotate, 'Rectangle', rect_img_rotate, 'Color', 'red');
img_resize = insertShape(img_resize, 'Rectangle', rect_img_resize, 'Color', 'red');
img_adjust = insertShape(img_adjust, 'Rectangle', rect_img_adjust, 'Color', 'red');

figure(1);
imshow(img_rotate);
figure(2);
imshow(img_resize);
figure(3);
imshow(img_adjust);