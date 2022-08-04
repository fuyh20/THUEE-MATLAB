clear, close all;
clc;

root = '../res/Faces/';
img_list = ls(fullfile(root, '*.bmp'));
img_num = length(img_list);

v_3 = zeros(1, 2^9); v_4 = zeros(1, 2^12); v_5 = zeros(1, 2^15);
for i = 1:img_num
    img = imread(fullfile(root, img_list(i, :)));
    v_3 = v_3 + get_color_ratio(img, 3);
    v_4 = v_4 + get_color_ratio(img, 4);
    v_5 = v_5 + get_color_ratio(img, 5);
end
v_3 = v_3/img_num; v_4 = v_4/img_num; v_5 = v_5/img_num;

subplot(3,1,1);
plot(v_3);
title("L = 3");
ylabel('频率');
subplot(3,1,2);
plot(v_4);
title("L = 4");
ylabel('频率');
subplot(3,1,3);
plot(v_5);
title("L = 5");
ylabel('频率');

save('face_v.mat', 'v_3', 'v_4', 'v_5');