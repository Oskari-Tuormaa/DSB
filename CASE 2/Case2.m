%% Case 2
load('Opgave2_audiofil.mat', 'raw_input');
fs = 25600;
raw_input = raw_input ./ max(raw_input);
%soundsc(y, Fs);

figure(5)
plot((0:length(raw_input)-1) / fs, raw_input);
xlim([0, 10])
title('Opgave2\_audiofil.mat')
xlabel('Time [s]')
ylabel('Amplitude')

xk = fft(raw_input(1:10*fs));
xk = 2 * xk ./ length(xk);

%%
figure(1)
stem(20*log10(abs(xk)), 'BaseValue', -160, 'Marker', 'none');
title('DFT of Opgave2\_audiofil.mat');
xlabel('Logarithmic [Hz]');
ylabel('Logarithmic [dB]');
set(gca, 'xscal', 'log');
ylim([-120, -60]);
xlim([30, Fs/2]);
grid on

figure(2)
stem(abs(xk), 'Marker', 'none');
title('DFT of Opgave2\_audiofil.mat');
set(gca, 'xscal', 'log');
xlabel('Logarithmic [Hz]');
ylabel('Linear');
%ylim([0, 1]);
xlim([30, Fs/2]);
grid on

figure(3)
stem(20*log10(abs(xk)), 'BaseValue', -160, 'Marker', 'none');
title('DFT of Opgave2\_audiofil.mat');
xlabel('Linear [Hz]');
ylabel('Logarithmic [dB]');
ylim([-120, -60]);
xlim([30, Fs/2]);
grid on

figure(4)
stem(abs(xk), 'Marker', 'none');
title('DFT of Opgave2\_audiofil.mat');
xlabel('Linear [Hz]');
ylabel('Linear');
%ylim([0, 1]);
xlim([30, Fs/2]);
grid on

%%
dc_mean = xk(1) / 2
ac_mean = rms(raw_input-dc_mean)
energi = sum(raw_input.^2)

%%
s = ifft([zeros(1, 40), xk(40:length(xk)-1)]);
figure(7)
plot((0:length(s)-1) / fs, abs(s));
xlim([5, 5.5])

