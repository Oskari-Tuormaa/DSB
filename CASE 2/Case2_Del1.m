%% Case 2
load('Opgave2_audiofil.mat');

fs = 25600; % fs found in opgavebeskrivelsen
x = raw_input; % Rename variable to fit convention
y = x(1:fs*10); %Isolate first 10 seconds
dc = mean(y); % Find DC-offset
y = y - dc; % Remove DC-offset to clean up signal
N = length(y);

figure(5)
plot((0:N-1) / fs, y);
title('Opgave2\_audiofil.mat')
xlabel('Time [s]')
ylabel('Amplitude [V]')
grid on

Y = fft(y);

%% Plotting signals
% Log over log
figure(1)
stem(20*log10(abs(Y)), 'BaseValue', -160, 'Marker', 'none');
title('DFT of Opgave2\_audiofil.mat [Log/Log]');
xlabel('Frekvens [Hz]');
ylabel('Amplitude [dBV]');
set(gca, 'xscal', 'log');
ylim([50, 100]);
xlim([30, fs/2]);
grid on

% Lin over log
figure(2)
stem(abs(Y), 'Marker', 'none');
title('DFT of Opgave2\_audiofil.mat [Lin/Log]');
set(gca, 'xscal', 'log');
xlabel('Frekvens [Hz]');
ylabel('Amplitude [V]');
%ylim([0, 1]);
xlim([30, fs/2]);
grid on

% Log over lin
figure(3)
stem(20*log10(abs(Y)), 'BaseValue', -160, 'Marker', 'none');
title('DFT of Opgave2\_audiofil.mat [Log/Lin]');
xlabel('Frekvens [Hz]');
ylabel('Amplitude [dBV]');
ylim([50, 100]);
xlim([30, fs/2]);
grid on

% Lin over lin
figure(4)
stem(abs(Y), 'Marker', 'none');
title('DFT of Opgave2\_audiofil.mat [Lin/Lin]');
xlabel('Frekvens [Hz]');
ylabel('Amplitude [V]');
%ylim([0, 1]);
xlim([30, fs/2]);
grid on

%%
% Show DC value in command window
dc
% Calculate ac_mean by removing DC offset and calculating RMS.
ac_mean = rms(y)
% Calculate energy by summing square of input signal.
% Also check that Parseval was right.
energy = sum(abs(y).^2)
energy = sum(abs(Y).^2)/N

%%
f_res = fs/fs;
% Calculate the bin in which 40 Hz is represented
cutoff_bin = 40/f_res

% Split data in two parts around cutoff_bin
Y_lo = Y(1:40);
Y_hi = Y(40:end);

% Calculate lo and hi frequency energy
energy_lo = sum(abs(Y_lo).^2)/N
energy_hi = sum(abs(Y_hi).^2)/N

% Calculate the energy ratio
energy_ratio = energy_lo / energy_hi

save results1
