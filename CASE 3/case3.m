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

% Stud�r EKG og dokument�r nytte-frekvensomr�de (b�ndbredde)

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

%% H�jfrekvent - FIR - Lavpas
close all

f_lo = 150; % Cutoff frekvens
M_lo = 512; % Orden
f_lo_res = fs / M_lo; % Frekvensopl�sning af filter

f_lo_bin = round(f_lo / f_lo_res); % Cutoff frekvens i bin

% Skab filterets overf�ringskarakteristik i frekvensdom�net.
% Da filtret er lavpas, s�ttes 1'er ind p� hvert bin under
% cutoff frekvensen, og 0'er s�ttes ind p� hvert bin
% over cutoff frekvensen.
H_lo = [ones([1 f_lo_bin]) zeros([1 M_lo/2 - f_lo_bin])];
stem(H_lo)

% Spejl filteret omkring nyquist, dvs. det sidste bin.
H_lo = [H_lo fliplr(H_lo)];
figure()
stem(H_lo)

% Brug ifft til at omregne filteret til tidsdom�net for at se
% impulsrespons
h_lo = fftshift(real(ifft(H_lo)));
figure()
plot(h_lo)
title("Impulsrespons")

hanning_w_lo = hanning(length(h_lo))';
h_lo = h_lo .* hanning_w_lo;

% Lav fft p� impulsresponset for at finde den reele overf�rings-
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

% K�r signalet gennem filteret s� at sige
w_net = conv(s, h_lo./f_lo_bin);
figure()
plot(w_net)
hold on
plot(s)
legend(["Filtreret" "Original"])
hold off

%% Lavfrekvent - FIR - H�jpas
close all

f_lo = 2; % Cutoff frekvens
M_lo = 2048; % Orden
f_lo_res = fs / M_lo; % Frekvensopl�sning af filter

f_lo_bin = round(f_lo / f_lo_res) % Cutoff frekvens i bin

% Skab filterets overf�ringskarakteristik i frekvensdom�net.
% Da filtret er lavpas, s�ttes 1'er ind p� hvert bin under
% cutoff frekvensen, og 0'er s�ttes ind p� hvert bin
% over cutoff frekvensen.
H_lo = [zeros([1 f_lo_bin]) ones([1 M_lo/2 - f_lo_bin])];
stem(H_lo)

% Spejl filteret omkring nyquist, dvs. det sidste bin.
H_lo = [H_lo fliplr(H_lo)];
figure()
stem(H_lo)

% Brug ifft til at omregne filteret til tidsdom�net for at se
% impulsrespons
h_lo = fftshift(real(ifft(H_lo)));
figure()
plot(h_lo)
title("Impulsrespons")

% Lav fft p� impulsresponset for at finde den reele overf�rings-
% karakteristik.
N_lo_fft = fs; % Punkter i fft
f_lo_x = (0:N_lo_fft-1) * fs / N_lo_fft; % x-aksen

h_lo = abs(fft(h_lo, N_lo_fft));
figure()
plot(f_lo_x, 20*log10(h_lo))
title("H�jpas, Fc = 0.05 Hz, M = 512")
xlim([0 400])
%ylim([-100 10])
xlabel("Frekvens [Hz]")
ylabel("Gain [dB]")

% K�r signalet gennem filteret s� at sige
w_net = conv(s, h_lo./f_lo_bin);
figure()
plot(w_net)
hold on
plot(s)
legend(["Filtreret" "Original"])
hold off

%% Netst�j - FIR - B�ndstop
close all

f_net_lo = 45;
f_net_hi = 55;

f_net_lo_norm = 2 * f_net_lo / fs;
f_net_hi_norm = 2 * f_net_hi / fs;

h_net = fir1(512, [f_net_lo_norm f_net_hi_norm], 'stop');
stem(h_net)

freqz(h_net, 1, 512, fs);

