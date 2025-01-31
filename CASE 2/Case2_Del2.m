%%
load('results1.mat', 'y', 'fs', 'N', 'dc');

% Generate hanning window
han = hann(N);
% Transpose hanning window
han = han';
% Multiply signal with hanning window
y_han = y .* han;

x_akse = (0:N-1) / fs;

figure(6)
plot(x_akse, y_han, x_akse, han * max(y))
legend('y * Hanning', 'max(y) * Hanning')
xlabel('Tid [s]')
ylabel('Amplitude [V]')
title('Signal ganget Hanning Vindue')
grid on

Y_han = fft(y_han);

figure(7)
stem(abs(Y_han), 'Marker', 'none');
title('DFT af signal ganget med Hanning vindue [Lin/Log]');
set(gca, 'xscal', 'log');
xlabel('Frekvens [Hz]');
ylabel('Amplitude [V]');
xlim([30, fs/2]);
grid on

%%
% Show DC value in command window
mean(y_han)
% Calculate ac_mean by removing DC offset and calculating RMS.
ac_mean = rms(y_han)
% Calculate energy by summing square of input signal.
% Also check that Parseval was right.
energy = sum(abs(y_han).^2)
energy = sum(abs(Y_han).^2)/N

%%
% Use raw_smooth to smooth out function
Y_han_smooth_raw = raw_smooth(Y_han, 21);

figure(8)
plot(20*log10(abs(Y_han_smooth_raw)), 'Marker', 'none');
title('Udglattet signal i frekvens dom�net [Log/Lin]');
xlabel('Frekvens [Hz]');
ylabel('Amplitude [dBV]');
xlim([30, fs/2]);
ylim([0, 100])
grid on

figure(9)
plot(20*log10(abs(Y_han)), 'Marker', 'none');
title('Signal i frekvens dom�net [Log/Lin]');
xlabel('Frekvens [Hz]');
ylabel('Amplitude [dBV]');
xlim([30, fs/2]);
ylim([0, 100])
grid on

figure(10)
plot(20*log10(abs(Y_han_smooth_raw)), 'Marker', 'none');
hold on
plot(20*log10(abs(Y_han)))
hold off
title('Udglattet signal i frekvens dom�net [Log/Lin]');
xlabel('Frekvens [Hz]');
ylabel('Amplitude [dBV]');
legend('Smoothed', 'Original')
xlim([4100, 4200]);
grid on

% Lin over log
figure(11)
stem(abs(Y_han_smooth_raw), 'Marker', 'none');
title('DFT of Y\_han\_smooth\_raw [Lin/Log]');
set(gca, 'xscal', 'log');
xlabel('Frekvens [Hz]');
ylabel('Amplitude [V]');
%ylim([0, 1]);
xlim([30, fs/2]);
grid on
