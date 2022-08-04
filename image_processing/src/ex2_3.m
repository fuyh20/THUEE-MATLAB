clear, close all;
clc;

load ../res/hall.mat;
subplot(1,3,1);
imshow(hall_gray);
title("original image");

clear_right_handle = @(block_struct) clear_right(block_struct.data);
clear_left_handle =  @(block_struct) clear_left(block_struct.data);
c1 = blockproc(double(hall_gray)-128, [8 8], clear_right_handle);
c2 = blockproc(double(hall_gray)-128, [8 8], clear_left_handle);

clear_right_image = uint8(blockproc(c1, [8 8], @(block_struct) idct2(block_struct.data) + 128));
clear_left_image = uint8(blockproc(c2, [8 8], @(block_struct) idct2(block_struct.data) + 128));

subplot(1,3,2);
imshow(clear_right_image);
title("clear right image");
subplot(1,3,3);
imshow(clear_left_image);
title("clear left image");
function C = clear_right(P)
    C = dct2(P);
    C(:,5:8) = 0;
end

function C = clear_left(P)
    C = dct2(P);
    C(:,1:4) = 0;
end