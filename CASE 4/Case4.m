%% Case 4 - EQ
% Vi vil lave en 8 bånds EQ
% Vi filtrere lidt i nummeret Badekar med Yor & Ü

%% 1. Opdel input x(n) i 8 frekvensbånd vha. båndpassfilter. 
% 1: 20-100
% 2: 100-200
% 3: 200-500
% 4: 500-1k
% 5: 1k-2k
% 6: 2k-5k
% 7: 5k-10k
% 8: 10k-20k

%% Load Lyd
y = audioread('badekar.mp3');

%% Filtre
Fs = 44100;     % Sampling frequency
N   = 4;        % Order
f_akse = logspace(log10(1),log10(fs/2),20000);

% Filter 1: 20-100
fc1_1 = 20;       % First Cutoff Frequency
fc1_2 = 100;       % Second Cutoff Frequency
[z1, p1, k1] = butter(N/2,[fc1_1 fc1_2]/(fs/2),'bandpass');
sos1 = zp2sos(z1, p1, k1);
hz_sos1 = freqz(sos1,f_akse,Fs);

% Filter 2: 100-200
fc2_1 = 100;       % First Cutoff Frequency
fc2_2 = 200;       % Second Cutoff Frequency
[z2, p2, k2] = butter(N/2,[fc2_1 fc2_2]/(fs/2),'bandpass');
sos2 = zp2sos(z2, p2, k2);
hz_sos2 = freqz(sos2,f_akse,Fs);

% Filter 3: 200-500
fc3_1 = 200;       % First Cutoff Frequency
fc3_2 = 500;       % Second Cutoff Frequency
[z3,p3,k3] = butter(N/2,[fc3_1 fc3_2]/(fs/2),'bandpass');
sos3 = zp2sos(z3, p3, k3);
hz_sos3 = freqz(sos3,f_akse,Fs);

% Filter 4: 500-1000
fc4_1 = 500;       % First Cutoff Frequency
fc4_2 = 1000;       % Second Cutoff Frequency
[z4,p4,k4] = butter(N/2,[fc4_1 fc4_2]/(fs/2),'bandpass');
sos4 = zp2sos(z4, p4, k4);
hz_sos4 = freqz(sos4,f_akse,Fs);

% Filter 5: 1000-2000
fc5_1 = 1000;       % First Cutoff Frequency
fc5_2 = 2000;       % Second Cutoff Frequency
[z5,p5,k5] = butter(N/2,[fc5_1 fc5_2]/(fs/2),'bandpass');
sos5 = zp2sos(z5, p5, k5);
hz_sos5 = freqz(sos5,f_akse,Fs);

% Filter 6: 2000-5000
fc6_1 = 2000;       % First Cutoff Frequency
fc6_2 = 5000;       % Second Cutoff Frequency
[z6,p6,k6] = butter(N/2,[fc6_1 fc6_2]/(fs/2),'bandpass');
sos6 = zp2sos(z6, p6, k6);
hz_sos6 = freqz(sos6,f_akse,Fs);

% Filter 7: 5000-10000
fc7_1 = 5000;       % First Cutoff Frequency
fc7_2 = 10000;       % Second Cutoff Frequency
[z7,p7,k7] = butter(N/2,[fc7_1 fc7_2]/(fs/2),'bandpass');
sos7 = zp2sos(z7, p7, k7);
hz_sos7 = freqz(sos7,f_akse,Fs);

% Filter 8: 10000-20000
fc8_1 = 10000;       % First Cutoff Frequency
fc8_2 = 20000;       % Second Cutoff Frequency
[z8,p8,k8] = butter(N/2,[fc8_1 fc8_2]/(fs/2),'bandpass');
sos8 = zp2sos(z8, p8, k8);
hz_sos8 = freqz(sos8,f_akse,Fs);

%% Plot frekvenskarakteristik
figure(1)
semilogx(f_akse, 20*log10(abs(hz_sos1)), 'linewidth', 2);
hold on
semilogx(f_akse, 20*log10(abs(hz_sos2)), 'linewidth', 2);
semilogx(f_akse, 20*log10(abs(hz_sos3)), 'linewidth', 2);
semilogx(f_akse, 20*log10(abs(hz_sos4)), 'linewidth', 2);
semilogx(f_akse, 20*log10(abs(hz_sos5)), 'linewidth', 2);
semilogx(f_akse, 20*log10(abs(hz_sos6)), 'linewidth', 2);
semilogx(f_akse, 20*log10(abs(hz_sos7)), 'linewidth', 2);
semilogx(f_akse, 20*log10(abs(hz_sos8)), 'linewidth', 2);
hold off
grid on
ylim([-25 5]);
ylabel('Gain');
xlim([20 20000]);
xlabel('Frekvens [Hz]')
title('8 båndpas filtre');
legend('Filter1 20-100Hz','Filter2 100-200Hz','Filter3 200-500Hz','Filter4 500-1000Hz','Filter5 1000-2000Hz','Filter6 2000-5000Hz','Filter7 5000-10000Hz','Filter8 10000-20000Hz');

%% Fasekarakteristik
figure(2)
plot(f_akse,180/pi*unwrap(angle(hz_sos8)));
hold on
plot(f_akse,180/pi*unwrap(angle(hz_sos7)));
plot(f_akse,180/pi*unwrap(angle(hz_sos6)));
plot(f_akse,180/pi*unwrap(angle(hz_sos5)));
plot(f_akse,180/pi*unwrap(angle(hz_sos4)));
plot(f_akse,180/pi*unwrap(angle(hz_sos3)));
plot(f_akse,180/pi*unwrap(angle(hz_sos2)));
plot(f_akse,180/pi*unwrap(angle(hz_sos1)));
hold off
%xlim([0 max(f_akse)/2]);
%% Lydfilen filtreres

figure(3)
y1 = filter(hz_sos1,1,y);
y2 = filter(hz_sos2,1,y);
y3 = filter(hz_sos3,1,y);
y4 = filter(hz_sos4,1,y);
y5 = filter(hz_sos5,1,y);
y6 = filter(hz_sos6,1,y);
y7 = filter(hz_sos7,1,y);
y8 = filter(hz_sos8,1,y);
hold off
plot(abs(y3));

%% Impulsrespons
impuls = [1 zeros(1,999)];

k2 = sosfilt(sos2,impuls);
k7 = sosfilt(sos7,impuls);
figure(3)
plot(k2);
hold on
grid on
plot(k7);
ylim([-0.08 0.08]);
ylabel('Gain');
xlabel('Samples');
hold off
title('Impulsrespons for filter');
legend('Filter2 100-200Hz','Filter7 5000-10000Hz');

%% 