clear, close all;
clc;
%乐曲的基本信息
base = 3; %音色
meter = 0.5; %拍子
fs = 8000; %采样频率
harmonic_amplitude = [0.05442, 0.07929, 0.5217, 0.05985, 0.0028, 0.0060, 0.0195, 0.0067, 0.0073]; %谐波强度
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
    for i = 1:length(harmonic_amplitude)
        harmonic_wave = harmonic_wave + ...
            harmonic_amplitude(i)*sin(2*i*pi*tunes(content(tune_num,1)) * t);
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