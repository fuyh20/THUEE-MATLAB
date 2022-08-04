clear, close all;
clc;

load ../res/Guitar.MAT;

%subplot(1,2,1);
%plot(realwave);
%subplot(1,2,2);
%plot(wave2proc);
wav = reshape(resample(realwave, 250, 243), [25, 10]);
tmp = sum(wav, 2) / 10;
wav = repmat(tmp, [10, 1]);
wav = resample(wav, 243, 250);

plot(wave2proc);
hold on;
plot(wav);
