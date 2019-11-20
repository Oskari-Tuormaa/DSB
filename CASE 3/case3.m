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

%% ************* Højfrekvent - FIR - Lavpas *************
% *******************************************************
close all

f_hi = 150; % Cutoff frekvens
M_hi = 512; % Orden
f_hi_res = fs / M_hi; % Frekvensopløsning af filter

f_hi_bin = round(f_hi / f_hi_res); % Cutoff frekvens i bin

% Skab filterets overføringskarakteristik i frekvensdomænet.
% Da filtret er lavpas, sættes 1'er ind på hvert bin under
% cutoff frekvensen, og 0'er sættes ind på hvert bin
% over cutoff frekvensen.
H_hi = [ones([1 f_hi_bin]) zeros([1 M_hi/2 - f_hi_bin])];

% Spejl filteret omkring nyquist, dvs. det sidste bin.
H_hi = [H_hi fliplr(H_hi)];

% Brug ifft til at omregne filteret til tidsdomænet for at se
% impulsrespons
h_hi = fftshift(real(ifft(H_hi)));
figure()
plot(h_hi)
title("Impulsrespons")
xlim([0 length(h_hi)])
xlabel("Samples")
ylabel("Amplitude")

hanning_w_hi = hanning(length(h_hi))';
h_hi = h_hi .* hanning_w_hi;

% Lav fft på impulsresponset for at finde den reele overførings-
% karakteristik.
N_hi_fft = fs; % Punkter i fft
f_hi_x = (0:N_hi_fft-1) * fs / N_hi_fft; % x-aksen

h_hi = abs(fft(h_hi, N_hi_fft));
figure()
plot(f_hi_x, 20*log10(h_hi))
title("Lavpas, Fc = 150 Hz, M = 512")
xlim([0 400])
ylim([-100 10])
xlabel("Frekvens [Hz]")
ylabel("Gain [dB]")

% Kør signalet gennem filteret så at sige
Y_hi = conv(s, h_hi./f_hi_bin);
figure()
subplot(2, 1, 1)
plot(Y_hi)
title("Sampleplot af signal foldet med FIR Lavpas")
xlim([0 length(s)])
xlabel("Samples")
ylabel("Amplitude")
hold on
plot(s)
legend(["Filtreret" "Original"])
hold off
subplot(2, 1, 2)
plot(Y_hi)
title("Sampleplot af signal foldet med FIR Lavpas (Zoomet ind)")
xlim([0 length(s)])
xlabel("Samples")
ylabel("Amplitude")
hold on
plot(s)
legend(["Filtreret" "Original"])
hold off

%% ************* Lavfrekvent - FIR - Højpas *************
% *******************************************************
close all

f_lo = 1; % Cutoff frekvens
M_lo = 2048; % Orden
f_lo_res = fs / M_lo; % Frekvensopløsning af filter

f_lo_bin = round(f_lo / f_lo_res) % Cutoff frekvens i bin

% Skab filterets overføringskarakteristik i frekvensdomænet.
% Da filtret er lavpas, sættes 1'er ind på hvert bin under
% cutoff frekvensen, og 0'er sættes ind på hvert bin
% over cutoff frekvensen.
H_lo = [zeros([1 f_lo_bin]) ones([1 M_lo/2 - f_lo_bin])];

% Spejl filteret omkring nyquist, dvs. det sidste bin.
H_lo = [H_lo fliplr(H_lo)];

% Brug ifft til at omregne filteret til tidsdomænet for at se
% impulsrespons
h_lo = fftshift(real(ifft(H_lo)));
figure()
plot(h_lo)
title("Impulsrespons")
xlabel("Samples")
ylabel("Amplitude")

% Lav fft på impulsresponset for at finde den reele overførings-
% karakteristik.
N_lo_fft = fs; % Punkter i fft
f_lo_x = (0:N_lo_fft-1) * fs / N_lo_fft; % x-aksen

h_lo = abs(fft(h_lo, N_lo_fft));
figure()
plot(f_lo_x, 20*log10(h_lo))
title("Højpas, Fc = 0.25 Hz, M = 2048")
xlim([0 400])
%ylim([-100 10])
xlabel("Frekvens [Hz]")
ylabel("Gain [dB]")

% Kør signalet gennem filteret så at sige
Y_lo = conv(s, h_lo./(M_lo-f_lo_bin));
figure()
subplot(2, 1, 1)
plot(Y_lo)
xlabel("Samples")
ylabel("Amplitude")
title("Sampleplot af signal foldet med FIR højpas")
hold on
plot(s)
legend(["Filtreret" "Original"])
hold off
subplot(2, 1, 2)
plot(Y_lo)
xlabel("Samples")
ylabel("Amplitude")
title("Sampleplot af signal foldet med FIR højpas (Zoomet ind)")
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
subplot(2, 1, 1)
plot(h_net)
title("Impulsrespons")
xlabel("Samples")
ylabel("Amplitude")
xlim([0 length(h_net)])
subplot(2, 1, 2)
plot(h_net)
title("Impulsrespons (Zoomet ind)")
xlabel("Samples")
ylabel("Amplitude")
xlim([0 length(h_net)])

figure()
freqz(h_net, 1, 512, fs)
title("Frekvenskarakteristik")

Y_net = conv(s, h_net, 'same');
N_net = length(Y_net);

figure()
subplot(4, 1, 1)
plot(s)
title("Sampleplot - Original")
xlabel("Samples")
ylabel("Amplitude")
subplot(4, 1, 2)
plot(Y_net)
title("Sampleplot - Filtreret")
xlabel("Samples")
ylabel("Amplitude")
subplot(4, 1, 3)
plot(s)
xlim([22500 26500])
title("Sampleplot - Original (Zoomet ind)")
xlabel("Samples")
ylabel("Amplitude")
subplot(4, 1, 4)
plot(Y_net)
xlim([22500 26500])
title("Sampleplot - Filtreret (Zoomet ind)")
xlabel("Samples")
ylabel("Amplitude")

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
ylim([-120 10])
title("Overføringskarakteristik for lavpasfilter, Fc = 150 Hz, M = 6")

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
plot(s)
title("Original")
xlabel("Samples")
ylabel("Amplitude")
subplot(4, 1, 2)
plot(Y)
title("Filtreret")
xlabel("Samples")
ylabel("Amplitude")
xlim([0 60000])
subplot(4, 1, 3)
plot(s)
xlim([30000 32000])
title("Original (Zoomet ind)")
xlabel("Samples")
ylabel("Amplitude")
subplot(4, 1, 4)
plot(Y)
xlim([30000 32000])
title("Filtreret (Zoomet ind)")
xlabel("Samples")
ylabel("Amplitude")




%% Lavfrekvent - Højpas
close all

f_lo = 0.25;

f_lo_norm = 2 * f_lo / fs;

[b,a] = butter(2, f_lo_norm, 'high');

figure(1)
freqz(b, a, 10*2048, fs);
title("Overføringskarakteristik for højpasfilter, Fc = 0.25 Hz, M = 16")

d = [0 0 0 0 1 zeros(1,N/2)];
h_lo = filter(b,a,d);
figure(2)
plot(h_lo)
xlim([0 20]) %<<<---- Zoomet ind på x-aksen!!!! Fra 0 til 200!!!!!!!!!!!!!!!!!!
title("Impulsrespons for højpasfilter")
xlabel("Samples")
ylabel("Amplitude")

Y = conv(s, h_lo);

figure(3)
subplot(4, 1, 1)
plot(s)
xlim([0 55000])
title("Original")
xlabel("Samples")
ylabel("Amplitude")
subplot(4, 1, 2)
plot(Y)
xlim([0 55000])
title("Filtreret")
xlabel("Samples")
ylabel("Amplitude")
subplot(4, 1, 3)
plot(s)
xlim([20000 24000])
title("Original (Zoomet ind)")
xlabel("Samples")
ylabel("Amplitude")
subplot(4, 1, 4)
plot(Y)
xlim([20000 24000])
title("Filtreret (Zoomet ind)")
xlabel("Samples")
ylabel("Amplitude")

%% Lav filtrering på signalet
close all

Y_0 = signal_QRS;

% Fjern DC
Y_1 = Y_0 - mean(Y_0);

% Fjern lavfrekvent
Y_2 = conv(Y_1, h_lo);
Y_2 = Y_2(1:length(s));

% Fjern netstøj
Y_3 = conv(Y_2, h_net);
Y_3 = Y_3(1:length(s));

% Fjern højfrekvent
Y_4 = conv(Y_3, h_hi);
Y_4 = Y_4(1:length(s));


figure()
subplot(2, 1, 1)
plot(Y_0)
title("Sampleplot      Original")
xlabel("Samples")
ylabel("Amplitude")
subplot(2, 1, 2)
semilogx(f_axis, abs(fft(Y_0))/N)
xlim([0 fs/2])
ylim([0 4])
title("Frekvensrespons      Original")
xlabel("Frekvens [Hz]")
ylabel("Amplitude [dB]")

figure()
subplot(2, 1, 1)
plot(Y_1)
title("Sampleplot      DC")
xlabel("Samples")
ylabel("Amplitude")
subplot(2, 1, 2)
semilogx(f_axis, abs(fft(Y_1))/N)
xlim([0 fs/2])
ylim([0 4])
title("Frekvensrespons      DC")
xlabel("Frekvens [Hz]")
ylabel("Amplitude [dB]")

figure()
subplot(2, 1, 1)
plot(Y_2)
title("Sampleplot      DC & Lavpas")
xlabel("Samples")
ylabel("Amplitude")
subplot(2, 1, 2)
semilogx(f_axis, abs(fft(Y_2))/N)
xlim([0 fs/2])
ylim([0 4])
title("Frekvensrespons      DC & Lavpass")
xlabel("Frekvens [Hz]")
ylabel("Amplitude [dB]")

figure()
subplot(2, 1, 1)
plot(Y_3)
title("Sampleplot      DC & Lavpas & Båndstop")
xlabel("Samples")
ylabel("Amplitude")
subplot(2, 1, 2)
semilogx(f_axis, abs(fft(Y_3))/N)
xlim([0 fs/2])
ylim([0 4])
title("Frekvensrespons      DC & Lavpas & Båndstop")
xlabel("Frekvens [Hz]")
ylabel("Amplitude [dB]")

figure()
subplot(2, 1, 1)
plot(Y_4)
title("Sampleplot      DC & Lavpas & Båndstop & Højpas")
xlabel("Samples")
ylabel("Amplitude")
subplot(2, 1, 2)
semilogx(f_axis, abs(fft(Y_4))/N)
xlim([0 fs/2])
ylim([0 4])
title("Frekvensrespons      DC & Lavpas & Båndstop & Højpas")
xlabel("Frekvens [Hz]")
ylabel("Amplitude [dB]")



