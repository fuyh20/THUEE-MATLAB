clear, close all;
clc;
%乐曲的基本信息
base = 3; %音色
meter = 0.5; %拍子
fs = 8000; %采样频率
harmonic_amplitude = [1, 0.3071, 0.07074, 0.05729, 0.07538,	0, 0;
                      1, 0.3071, 0.07074, 0.05729, 0.07538,	0, 0;
                      1, 0.0788, 0.15203, 0, 0, 0.1422,	0;
                      1, 0, 0, 0.1270, 0.1786, 0, 0;
                      1, 0.3222, 0, 0.05368, 0.08507, 0.08801, 0;
                      1, 0.3222, 0, 0.05368, 0.08507, 0.08801, 0;
                      1, 0.0569, 0.05953, 0.05032, 0.1000, 0.06168, 0.05279;
                      1, 0, 0, 0.1270, 0.1786, 0, 0]; %谐波强度
%乐谱内容
content = [mediant(5), 1; mediant(5), 0.5; mediant(6), 0.5; mediant(2), 2;... 
           mediant(1), 1; mediant(1), 0.5; bass(6), 0.5; mediant(2), 2];
ratios = 2^(1/12) .^ [-4, -2, 0, 2, 3, 5, 7]';

%每个音色具体频率
tunes = zeros([7, 3]);
tunes(base, :) = 220 .* (2.^[0, 1, 2]');
tunes = repmat(tunes(base, :), [7 1]) .* ratios;

%合成音乐
time = fs * content(:, 2) * meter;
song = zeros(1, sum(time));
n = 1;
for tune_num = 1:size(content,1)
    t = linspace(0, content(tune_num, 2) * meter - 1/fs, time(tune_num));
    env = zeros(1, time(tune_num));
    env(:) = exp(1:(-1/time(tune_num)):1/fs);
    
    harmonic_wave = zeros(1, length(t));
    for i = 1:size(harmonic_amplitude, 2)
        harmonic_wave = harmonic_wave + ...
            harmonic_amplitude(tune_num, i)*sin(2*i*pi*tunes(content(tune_num,1)) * t);
    end

    song(n:n+time(tune_num)-1) = harmonic_wave .* env;
    n = n+time(tune_num);
end

sound(song, fs);
plot(song);

function y = bass(x)
    y = x;
end

function y = mediant(x)
    y = x+7;
end

function y = treble(x)
    y = x+14;
end