clear, close all;
clc;
%乐曲的基本信息
base = 5; %音色
meter = 1; %拍子
fs = 8000; %采样频率
harmonic_amplitude = [1, 0.2, 0.3]; %谐波强度
%乐谱内容
content = [treble(3), 2; treble(2), 2; treble(1), 2; mediant(7), 2;
           mediant(6), 2; mediant(5), 2; mediant(6), 2; mediant(7), 2;
           treble(1), 2; mediant(7), 2; mediant(6), 2; mediant(5), 2; 
           mediant(4), 2; mediant(3), 2; mediant(4), 2; mediant(2), 2; 
           treble(1), 0.5; mediant(7), 0.5; treble(1), 0.5; mediant(1), 0.5;
           bass(7), 0.5; mediant(5), 0.5; mediant(2), 0.5; mediant(3), 0.5;
           mediant(1), 0.5; treble(1), 0.5; mediant(7), 0.5; mediant(6), 0.5;
           mediant(7), 0.5; treble(3), 0.5; treble(5), 0.5; treble(6), 0.5;
           treble(4), 0.5; treble(3), 0.5; treble(2), 0.5; treble(4), 0.5;
           treble(4), 0.5; treble(3), 0.5; treble(1), 0.5; mediant(7), 0.5;
           mediant(6), 0.5; mediant(5), 0.5; mediant(4), 0.5; mediant(3), 0.5;
           mediant(2), 0.5; mediant(4), 0.5; mediant(3), 0.5; mediant(2), 0.5;
           mediant(1), 0.5; mediant(2), 0.5; mediant(3), 0.5; mediant(4), 0.5;
           mediant(5), 0.5; mediant(2), 0.5; mediant(5), 0.5; mediant(4), 0.5;
           mediant(3), 0.5; mediant(6), 0.5; mediant(5), 0.5; mediant(4), 0.5;
           mediant(5), 0.5; mediant(4), 0.5; mediant(3), 0.5; mediant(2), 0.5;
           mediant(1), 0.5; bass(6), 0.5; mediant(6), 0.5; mediant(7), 0.5;
           treble(1), 0.5; mediant(7), 0.5; mediant(6), 0.5; mediant(5), 0.5;
           mediant(4), 0.5; mediant(3), 0.5; mediant(2), 0.5; mediant(6), 0.5;
           mediant(5), 0.5; mediant(6), 0.5; mediant(5), 0.5; mediant(4), 0.5;
           mediant(3), 1; treble(3), 1; treble(2), 2;
           treble(1), 2; treble(2), 2;
           treble(1), 1; treble(3), 1; treble(2), 1; treble(4), 1;
           treble(5), 0.5; treble(3), 0.25; treble(4), 0.25; treble(5), 0.5; treble(3), 0.25; treble(4), 0.25;
           treble(5), 0.25; mediant(5), 0.25; mediant(6), 0.25; mediant(7), 0.25;
           treble(1), 0.25; treble(2), 0.25; treble(3), 0.25; treble(4), 0.25;
           treble(3), 0.5; treble(1), 0.25; treble(2), 0.25; treble(3), 0.5; treble(3), 0.25; treble(4), 0.25;
           mediant(5), 0.25; mediant(6), 0.25; mediant(5), 0.25; mediant(4), 0.25;
           mediant(5), 0.25; mediant(3), 0.25; mediant(5), 0.25; mediant(4), 0.25;
           mediant(4), 0.5; mediant(6), 0.25; mediant(5), 0.25; mediant(4), 0.5; mediant(3), 0.25; mediant(2), 0.25;
           mediant(3), 0.25; mediant(2), 0.25; mediant(1), 0.25; mediant(2), 0.25;
           mediant(3), 0.25; mediant(4), 0.25; mediant(5), 0.25; mediant(6), 0.25;
           mediant(4), 0.5; mediant(6), 0.25; mediant(5), 0.25; mediant(6), 0.5; mediant(7), 0.25; treble(1), 0.25;
           mediant(5), 0.25; mediant(6), 0.25; mediant(7), 0.25; treble(1), 0.25;
           treble(2), 0.25; treble(3), 0.25; treble(4), 0.25; treble(5), 0.25;
           treble(3), 0.5; treble(1), 0.25; treble(2), 0.25; treble(3), 0.5; treble(2), 0.25; treble(1), 0.25;
           treble(2), 0.25; mediant(7), 0.25; treble(1), 0.25; treble(2), 0.25;
           treble(3), 0.25; treble(2), 0.25; treble(1), 0.25; mediant(7), 0.25;
           treble(1), 0.5; mediant(6), 0.25; mediant(7), 0.25; treble(1), 0.5; mediant(1), 0.25; mediant(2), 0.25;
           mediant(3), 0.25; mediant(4), 0.25; mediant(3), 0.25; mediant(2), 0.25;
           mediant(3), 0.25; treble(1), 0.25; mediant(7), 0.25; treble(1), 0.25;
           mediant(6), 0.5; treble(1), 0.25; mediant(7), 0.25; mediant(6), 0.5; mediant(5), 0.25; mediant(4), 0.25;
           mediant(5), 0.25; mediant(4), 0.25; mediant(3), 0.25; mediant(4), 0.25;
           mediant(5), 0.25; mediant(6), 0.25; mediant(7), 0.25; mediant(1), 0.25;
           mediant(6), 0.5; treble(1), 0.25; mediant(7), 0.25; treble(1), 0.5; mediant(7), 0.25; mediant(6), 0.25;
           mediant(7), 0.25; treble(1), 0.25; treble(2), 0.25; treble(1), 0.25;
           mediant(7), 0.25; treble(1), 0.25; mediant(6), 0.25; mediant(7), 0.25];
ratios = 2^(1/12) .^ [-7, -5, -3, -2, 0, 2, 4]';

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
    env = exp(linspace(1, 1/fs, time(tune_num)));
    
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