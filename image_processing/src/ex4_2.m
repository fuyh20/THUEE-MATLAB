clear, close all;
clc;

load face_v.mat;
img = imread("../res/faces.jpg");
block_size = [50, 40];
stride = [5, 5];

img3 = img;
img4 = img;
img5 = img;
rect_img3 = face_detect(img3, v_3, 3, block_size, stride, 0.5, 100);
rect_img4 = face_detect(img4, v_4, 4, block_size, stride, 0.4, 100);
rect_img5 = face_detect(img5, v_5, 5, block_size, stride, 0.6, 100);
img3 = insertShape(img3, 'Rectangle', rect_img3, 'Color', 'red');
img4 = insertShape(img4, 'Rectangle', rect_img4, 'Color', 'red');
img5 = insertShape(img5, 'Rectangle', rect_img5, 'Color', 'red');

figure(3);
imshow(img3);
figure(4);
imshow(img4);
figure(5);
imshow(img5);