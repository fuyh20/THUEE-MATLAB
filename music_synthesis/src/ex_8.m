clear, close all;
clc;

load ../res/Guitar.MAT
fs = 8000;
T = 1/fs;

subplot(3, 1, 1);
L = round(length(wave2proc)/10);
X1 = fft(wave2proc(1:L));
P2 = abs(X1/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;
plot(f, P1);

subplot(3, 1, 2);
L = length(wave2proc);
X2 = fft(wave2proc);
P2 = abs(X2/L);
P1 = P2(1:round(L/2+1));
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:round(L/2))/L;
plot(f, P1);

subplot(3, 1, 3);
wave2proc = repmat(wave2proc, 20, 1);
L = length(wave2proc);
X3 = fft(wave2proc);
P2 = abs(X3/L);
P1 = P2(1:round(L/2+1));
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:round(L/2))/L;
plot(f, P1);