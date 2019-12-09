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
clear all;
close all force;
[y fs] = audioread('musicex1.wav');
% udtager venstre kanal af stereosignalet og
% laver søjleformatet om til rækkeformat
y = y(:,1)';
N = length(y);

%% Signalanalyse af sangen
Y = fft(y);
figure(1);
logabsY = 20*log10(abs(1/N*Y(1:0.5*fs))); 
semilogx(logabsY,'b');
grid on
xlabel('Frekvens [Hz]');
ylabel('Amplitude [dB relateret til 1]');

%% Mortens amazing GUI
% Kør koden nedenfor. Indstil gainet i de forskellige bånd. Lad være med at
% lukke vinduet, når de er indstillet. Ellers virker det ikke :-P
close all force;
fig = uifigure('Name','Equalizer','WindowState','maximized','Color', [0.73 0.90 1]);
% Window width = 1920. Window heigth = 1080
% Position = left padding, bottom padding, width, height
guioffset = (1080-840)/4;

uilabel(fig,'Position',[840 950 300 40],'FontSize',32,'FontWeight','bold','Text','Amazing EQ GUI');
p1 = uipanel(fig,'Position',[460 770+guioffset 1000 110]);
uilabel(fig,'Position',[875 850+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','20 Hz - 100 Hz bånd [dB]');
band1 = uislider(fig,'Position',[510 820+guioffset 900 3]);
band1.Limits = [-18 18];
band1.Value = 0;

p2 = uipanel(fig,'Position',[460 660+guioffset 1000 110]);
uilabel(fig,'Position',[875 740+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','100 Hz - 200 Hz bånd [dB]');
band2 = uislider(fig,'Position',[510 710+guioffset 900 3]);
band2.Limits = [-18 18];
band2.Value = 0;

p3 = uipanel(fig,'Position',[460 550+guioffset 1000 110]);
uilabel(fig,'Position',[875 630+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','200 Hz - 500 Hz bånd [dB]');
band3 = uislider(fig,'Position',[510 600+guioffset 900 3]);
band3.Limits = [-18 18];
band3.Value = 0;

p4 = uipanel(fig,'Position',[460 440+guioffset 1000 110]);
uilabel(fig,'Position',[875 520+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','500 Hz - 1 kHz bånd [dB]');
band4 = uislider(fig,'Position',[510 490+guioffset 900 3]);
band4.Limits = [-18 18];
band4.Value = 0;

p5 = uipanel(fig,'Position',[460 330+guioffset 1000 110]);
uilabel(fig,'Position',[875 410+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','1 kHz - 2 kHz bånd [dB]');
band5 = uislider(fig,'Position',[510 380+guioffset 900 3]);
band5.Limits = [-18 18];
band5.Value = 0;

p6 = uipanel(fig,'Position',[460 220+guioffset 1000 110]);
uilabel(fig,'Position',[875 300+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','2 kHz - 5 kHz bånd [dB]');
band6 = uislider(fig,'Position',[510 270+guioffset 900 3]);
band6.Limits = [-18 18];
band6.Value = 0;

p7 = uipanel(fig,'Position',[460 110+guioffset 1000 110]);
uilabel(fig,'Position',[875 190+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','5 kHz - 10 kHz bånd [dB]');
band7 = uislider(fig,'Position',[510 160+guioffset 900 3]);
band7.Limits = [-18 18];
band7.Value = 0;

p8 = uipanel(fig,'Position',[460 0+guioffset 1000 110]);
uilabel(fig,'Position',[875 80+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','10 kHz - 20 kHz bånd [dB]');
band8 = uislider(fig,'Position',[510 50+guioffset 900 3]);
band8.Limits = [-18 18];
band8.Value = 0;

%% Filtre
%Loaded from file: fs = 44100;     % Sampling frequency
order   = 24;        % Order
f_akse = logspace(log10(1),log10(fs/2),22000);

% freq_offset Makes the filters have a positive offset, so they overlap a bit

% Filter 1: 20-100
freq_offset1 = 1.07;
fc1_1 = 20;       % First Cutoff Frequency
fc1_2 = 100*freq_offset1;       % Second Cutoff Frequency
%[z1, p1, k1] = butter(N/2,[fc1_1 fc1_2]/(fs/2),'bandpass');
[z1, p1, k1] = cheby2(order/2,40,[fc1_1 fc1_2]/(fs/2),'bandpass');
k1 = k1*10^(band1.Value/20);
sos1 = zp2sos(z1, p1, k1);
hz_sos1 = freqz(sos1,f_akse,fs);
%b = fir1(N, [fc1_1 fc1_2]/(fs/2));
%freq_resp1 = freqz(b, f_akse, fs);


% Filter 2: 100-200
freq_offset2 = 1.07;
fc2_1 = 100;       % First Cutoff Frequency
fc2_2 = 200*freq_offset2;       % Second Cutoff Frequency
%[z2, p2, k2] = butter(N/2,[fc2_1 fc2_2]/(fs/2),'bandpass');
[z2, p2, k2] = cheby2(order/2,40,[fc2_1 fc2_2]/(fs/2),'bandpass');
k2 = k2*10^(band2.Value/20);
sos2 = zp2sos(z2, p2, k2);
hz_sos2 = freqz(sos2,f_akse,fs);

% Filter 3: 200-500
freq_offset3 = 1.07;
fc3_1 = 200;       % First Cutoff Frequency
fc3_2 = 500*freq_offset3;       % Second Cutoff Frequency
%[z3,p3,k3] = butter(N/2,[fc3_1 fc3_2]/(fs/2),'bandpass');
[z3,p3,k3] = cheby2(order/2,40,[fc3_1 fc3_2]/(fs/2),'bandpass');
k3 = k3*10^(band3.Value/20);
sos3 = zp2sos(z3, p3, k3);
hz_sos3 = freqz(sos3,f_akse,fs);

% Filter 4: 500-1000
freq_offset4 = 1.06;
fc4_1 = 500;       % First Cutoff Frequency
fc4_2 = 1000*freq_offset4;       % Second Cutoff Frequency
%[z4,p4,k4] = butter(N/2,[fc4_1 fc4_2]/(fs/2),'bandpass');
[z4,p4,k4] = cheby2(order/2,40,[fc4_1 fc4_2]/(fs/2),'bandpass');
k4 = k4*10^(band4.Value/20);
sos4 = zp2sos(z4, p4, k4);
hz_sos4 = freqz(sos4,f_akse,fs);

% Filter 5: 1000-2000
freq_offset5 = 1.07;
fc5_1 = 1000;       % First Cutoff Frequency
fc5_2 = 2000*freq_offset5;       % Second Cutoff Frequency
%[z5,p5,k5] = butter(N/2,[fc5_1 fc5_2]/(fs/2),'bandpass');
[z5,p5,k5] = cheby2(order/2,40,[fc5_1 fc5_2]/(fs/2),'bandpass');
k5 = k5*10^(band5.Value/20);
sos5 = zp2sos(z5, p5, k5);
hz_sos5 = freqz(sos5,f_akse,fs);

% Filter 6: 2000-5000
freq_offset6 = 1.07;
fc6_1 = 2000;       % First Cutoff Frequency
fc6_2 = 5000*freq_offset6;       % Second Cutoff Frequency
%[z6,p6,k6] = butter(N/2,[fc6_1 fc6_2]/(fs/2),'bandpass');
[z6,p6,k6] = cheby2(order/2,40,[fc6_1 fc6_2]/(fs/2),'bandpass');
k6 = k6*10^(band6.Value/20);
sos6 = zp2sos(z6, p6, k6);
hz_sos6 = freqz(sos6,f_akse,fs);

% Filter 7: 5000-10000
freq_offset7 = 1.065;
fc7_1 = 5000;       % First Cutoff Frequency
fc7_2 = 10000*freq_offset7;       % Second Cutoff Frequency
%[z7,p7,k7] = butter(N/2,[fc7_1 fc7_2]/(fs/2),'bandpass');
[z7,p7,k7] = cheby2(order/2,40,[fc7_1 fc7_2]/(fs/2),'bandpass');
k7 = k7*10^(band7.Value/20);
sos7 = zp2sos(z7, p7, k7);
hz_sos7 = freqz(sos7,f_akse,fs);

% Filter 8: 10000-20000
fc8_1 = 10000;       % First Cutoff Frequency
fc8_2 = fs/2 - 1;       % Second Cutoff Frequency - Same as nyquist
%[z8,p8,k8] = butter(N/2,[fc8_1 fc8_2]/(fs/2),'bandpass');
[z8,p8,k8] = cheby2(order/2,40,[fc8_1 fc8_2]/(fs/2),'bandpass');
k8 = k8*10^(band8.Value/20);
sos8 = zp2sos(z8, p8, k8);
hz_sos8 = freqz(sos8,f_akse,fs);


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

% Combined filter:
hz_sos_tot = hz_sos1 + hz_sos2 + hz_sos3 + hz_sos4 + hz_sos5 + hz_sos6 + hz_sos7 + hz_sos8;
semilogx(f_akse, 20*log10(abs(hz_sos_tot)), 'linewidth', 1, 'Color', 'black');
hold off
grid on
ylim([-25 30]);
ylabel('Gain dB');
xlim([20 22000]);
xlabel('Frekvens [Hz]')
title('8 båndpas filtre');
legend('Filter1 20-100Hz','Filter2 100-200Hz','Filter3 200-500Hz','Filter4 500-1000Hz','Filter5 1000-2000Hz','Filter6 2000-5000Hz','Filter7 5000-10000Hz','Filter8 10000-20000Hz', 'Samlet filter','NumColumns',3);

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
% tic and toc is execution time.
tic;

y1 = sosfilt(sos1,y);
y2 = sosfilt(sos2,y);
y3 = sosfilt(sos3,y);
y4 = sosfilt(sos4,y);
y5 = sosfilt(sos5,y);
y6 = sosfilt(sos6,y);
y7 = sosfilt(sos7,y);
y8 = sosfilt(sos8,y);

y_tot = y1+ y2 + y3 + y4 + y5 + y6 + y7 + y8;

executiontime = toc;
display(['Done filtering in ' num2str(executiontime) 's']);

%% Signalanalyse af sangen
Y_tot = fft(y_tot);
figure(3);
subplot(2,1,1);
logabsY = 20*log10(abs(1/N*Y(1:0.5*fs))); 
semilogx(logabsY,'b');
grid on
xlabel('Frekvens [Hz]');
ylabel('Amplitude [dB relateret til 1]');
subplot(2,1,2);
logabsY_tot = 20*log10(abs(1/N*Y_tot(1:0.5*fs))); 
semilogx(logabsY_tot,'b');
grid on
xlabel('Frekvens [Hz]');
ylabel('Amplitude [dB relateret til 1]');


%% Impulsrespons
impuls = [1 zeros(1,999)];

k2 = sosfilt(sos2,impuls);
k7 = sosfilt(sos7,impuls);
figure(3)
plot(k2);
hold on
grid on
plot(k7);
ylim([-0.2 0.2]);
ylabel('Gain');
xlabel('Samples');
hold off
title('Impulsrespons for filter');
legend('Filter2 100-200Hz','Filter7 5000-10000Hz');
