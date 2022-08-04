clear, close all;
clc;

wave = audioread("../res/fmt.wav");
len = length(wave);
time = floor([0.097, 0.266, 1.767, 2.234, 2.705, 3.146, 3.606, ...
              4.506, 4.521, 5.030, 5.749, 5.978, 7.015, 7.709, ...
              7.924, 8.028, 8.490, 8.959, 9.455, 9.852, 10.125, ...
              10.356, 10.565, 10.822, 11.292, 11.741, 12.284, ...
              12.742, 13.269, 13.758, 14.315, 14.939, 15.432]/16.384*len);
fs = len/16.384;
freq = zeros(length(time), 7);
amp = zeros(length(time), 7);
for i = 1:length(time)
    if i == 1
        wave_tmp = wave(1:time(i)-1);
    else 
        wave_tmp = wave(time(i-1):time(i)-1);
    end
    
    wave_tmp = repmat(wave_tmp, 1000, 1);
    [freq(i,:), amp(i,:)] = analysis_component(wave_tmp, fs);
end