%% Load og plot signal
clear;
close all;
clc;

load('ECG_noisy_signal.mat');

s = signal_QRS;
fs = f_sample;

% Remove DC:
dc = mean(s);
s = s - dc;

% Studér EKG og dokumentér nytte-frekvensområde (båndbredde)

% Varighed af signal
N = length(s);
Tlength = N*1/fs;

S = fft(s);

% Frekvens akse:
delta_f = fs/N;
f_axis = 0:delta_f:fs-delta_f;

logX = (20*log10(abs((1/N)*S(1:0.5*fs))));

% ***** Plots ***************************************************
figure(1); clf
semilogx(logX);
ylim([-50 25])
xlabel('Frekvens [Hz]');
ylabel('Magnitude [dB]');

figure(2)
plot(s)
xlabel('Samples')
ylabel('Amplitude')
title('Sample-plot af signalet')
% Her ser vi blot signalet tegnet direkte.

%% ************* Højfrekvent - FIR - Lavpas *************
% *******************************************************
close all

f_lo = 150; % Cutoff frekvens
M_lo = 512; % Orden
f_lo_res = fs / M_lo; % Frekvensopløsning af filter

f_lo_bin = round(f_lo / f_lo_res); % Cutoff frekvens i bin

% Skab filterets overføringskarakteristik i frekvensdomænet.
% Da filtret er lavpas, sættes 1'er ind på hvert bin under
% cutoff frekvensen, og 0'er sættes ind på hvert bin
% over cutoff frekvensen.
H_lo = [ones([1 f_lo_bin]) zeros([1 M_lo/2 - f_lo_bin])];
stem(H_lo)

% Spejl filteret omkring nyquist, dvs. det sidste bin.
H_lo = [H_lo fliplr(H_lo)];
figure()
stem(H_lo)

% Brug ifft til at omregne filteret til tidsdomænet for at se
% impulsrespons
h_lo = fftshift(real(ifft(H_lo)));
figure()
plot(h_lo)
title("Impulsrespons")

hanning_w_lo = hanning(length(h_lo))';
h_lo = h_lo .* hanning_w_lo;

% Lav fft på impulsresponset for at finde den reele overførings-
% karakteristik.
N_lo_fft = fs; % Punkter i fft
f_lo_x = (0:N_lo_fft-1) * fs / N_lo_fft; % x-aksen

h_lo = abs(fft(h_lo, N_lo_fft));
figure()
plot(f_lo_x, 20*log10(h_lo))
title("Lavpas, Fc = 150 Hz, M = 512")
xlim([0 400])
ylim([-100 10])
xlabel("Frekvens [Hz]")
ylabel("Gain [dB]")

% Kør signalet gennem filteret så at sige
Y_net = conv(s, h_lo./f_lo_bin);
figure()
plot(Y_net)
hold on
plot(s)
legend(["Filtreret" "Original"])
hold off

%% ************* Lavfrekvent - FIR - Højpas *************
% *******************************************************
close all

f_lo = 0.05; % Cutoff frekvens
M_lo = 2048; % Orden
f_lo_res = fs / M_lo; % Frekvensopløsning af filter

f_lo_bin = round(f_lo / f_lo_res) % Cutoff frekvens i bin

% Skab filterets overføringskarakteristik i frekvensdomænet.
% Da filtret er lavpas, sættes 1'er ind på hvert bin under
% cutoff frekvensen, og 0'er sættes ind på hvert bin
% over cutoff frekvensen.
H_lo = [zeros([1 f_lo_bin]) ones([1 M_lo/2 - f_lo_bin])];
stem(H_lo)

% Spejl filteret omkring nyquist, dvs. det sidste bin.
H_lo = [H_lo fliplr(H_lo)];
figure()
stem(H_lo)

% Brug ifft til at omregne filteret til tidsdomænet for at se
% impulsrespons
h_lo = fftshift(real(ifft(H_lo)));
figure()
plot(h_lo)
title("Impulsrespons")

% Lav fft på impulsresponset for at finde den reele overførings-
% karakteristik.
N_lo_fft = fs; % Punkter i fft
f_lo_x = (0:N_lo_fft-1) * fs / N_lo_fft; % x-aksen

h_lo = abs(fft(h_lo, N_lo_fft));
figure()
plot(f_lo_x, 20*log10(h_lo))
title("Højpas, Fc = 0.05 Hz, M = 512")
xlim([0 400])
%ylim([-100 10])
xlabel("Frekvens [Hz]")
ylabel("Gain [dB]")

% Kør signalet gennem filteret så at sige
Y_lo = conv(s, h_lo./f_lo_bin);
figure()
plot(Y_lo)
hold on
plot(s)
legend(["Filtreret" "Original"])
hold off

%% ************* Netstøj - FIR - Båndstop *************
% *****************************************************
close all

f_net_lo = 47;
f_net_hi = 53;

f_net_lo_norm = 2 * f_net_lo / fs;
f_net_hi_norm = 2 * f_net_hi / fs;

h_net = fir1(1024, [f_net_lo_norm f_net_hi_norm], 'stop');
stem(h_net)

figure()
freqz(h_net, 1, 512, fs)

Y_net = conv(s, h_net, 'same');
N_net = length(Y_net);

figure()
subplot(2, 1, 1)
plot(Y_net)
xlim([22500 26500])
title("Sampleplot - Filtreret")
xlabel("Samples")
ylabel("Amplitude")
subplot(2, 1, 2)
plot(s)
xlim([22500 26500])
title("Sampleplot - Original")

Y_net = fft(Y_net);

figure()
subplot(2, 1, 1)
plot(f_axis, 20*log10(abs(S)/N))
title("Original")
ylabel("Amplitude [dB]")
xlabel("Frekvens [Hz]")
xlim([30 70])
subplot(2, 1, 2)
plot(f_axis, 20*log10(abs(Y_net)/N_net))
title("Filtreret")
ylabel("Amplitude [dB]")
xlabel("Frekvens [Hz]")
xlim([30 70])

%% Højfrekvent - Lavpas - IIR
close all

f_hi = 150;

f_hi_norm = 2 * f_hi / fs;

[b,a] = butter(6, f_hi_norm);

figure(1)
freqz(b, a, 512, fs);
title("Overføringskarakteristik for lavpasfilter, Fc = 150, M = 16")

d = [0 0 0 0 1 zeros(1,N/2)];
h_hi = filter(b,a,d);
figure(2)
plot(h_hi)
xlim([0 200]) %<<<---- Zoomet ind på x-aksen!!!! Fra 0 til 200!!!!!!!!!!!!!!!!!!
title("Impulsrespons for lavpasfilter")
xlabel("Samples")
ylabel("Amplitude")

Y = conv(s, h_hi);

figure(3)
subplot(4, 1, 1)
plot(Y)
title("Filtreret")
xlim([0 60000])
subplot(4, 1, 2)
plot(s)
title("Original")
subplot(4, 1, 3)
plot(Y)
xlim([30000 32000])
title("Filtreret (Zoomet ind)")
subplot(4, 1, 4)
plot(s)
xlim([30000 32000])
title("Original (Zoomet ind)")




%% Lavfrekvent - Højpas
close all

f_lo = 0.25;

f_lo_norm = 2 * f_lo / fs;

[b,a] = butter(2, f_lo_norm, 'high');

figure(1)
freqz(b, a, 10*2048, fs);
title("Overføringskarakteristik for lavpasfilter, Fc = 150, M = 16")

d = [0 0 0 0 1 zeros(1,N/2)];
h_lo = filter(b,a,d);
figure(2)
plot(h_lo)
xlim([0 20]) %<<<---- Zoomet ind på x-aksen!!!! Fra 0 til 200!!!!!!!!!!!!!!!!!!
title("Impulsrespons for lavpasfilter")
xlabel("Samples")
ylabel("Amplitude")

Y = conv(s, h_lo);

figure(3)
subplot(2, 1, 1)
plot(Y)
xlim([0 55000])
title("Filtreret")
subplot(2, 1, 2)
plot(s)
xlim([0 55000])
title("Original")

%% Lav filtrering på signalet
close all

% Fjern lavfrekvent
Y = conv(s, h_lo .* h_net .* h_hi);

figure(1)
plot(Y)


