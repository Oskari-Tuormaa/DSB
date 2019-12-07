
%% Load Lyd
[y fs] = audioread('musicex1.wav');
% udtager venstre kanal af stereosignalet og
% laver søjleformatet om til rækkeformat
y = y(:,1)';

%% Filtre
%Loaded from file: fs = 44100;     % Sampling frequency
N   = 24;        % Order
f_akse = logspace(log10(1),log10(fs/2),20000);

%Init gains
gain1 = 1;
gain2 = 1;
gain3 = 1;
gain4 = 1;
gain5 = 1;
gain6 = 1;
gain7 = 1;
gain8 = 1;


% Make the filters have a positive offset, so they overlap a bit
freq_offset = 1;

% Filter 1: 20-100
freq_offset1 = 1.07;
fc1_1 = 20;       % First Cutoff Frequency
fc1_2 = 100*freq_offset1;       % Second Cutoff Frequency
%[z1, p1, k1] = butter(N/2,[fc1_1 fc1_2]/(fs/2),'bandpass');
[z1, p1, k1] = cheby2(N/2,40,[fc1_1 fc1_2]/(fs/2),'bandpass');
sos1 = zp2sos(z1, p1, k1);
hz_sos1 = freqz(sos1,f_akse,fs);


% Filter 2: 100-200
freq_offset2 = 1.07;
fc2_1 = 100;       % First Cutoff Frequency
fc2_2 = 200*freq_offset2;       % Second Cutoff Frequency
%[z2, p2, k2] = butter(N/2,[fc2_1 fc2_2]/(fs/2),'bandpass');
[z2, p2, k2] = cheby2(N/2,40,[fc2_1 fc2_2]/(fs/2),'bandpass');
sos2 = zp2sos(z2, p2, k2);
hz_sos2 = freqz(sos2,f_akse,fs);

% Filter 3: 200-500
freq_offset3 = 1.07;
fc3_1 = 200;       % First Cutoff Frequency
fc3_2 = 500*freq_offset3;       % Second Cutoff Frequency
%[z3,p3,k3] = butter(N/2,[fc3_1 fc3_2]/(fs/2),'bandpass');
[z3,p3,k3] = cheby2(N/2,40,[fc3_1 fc3_2]/(fs/2),'bandpass');
sos3 = zp2sos(z3, p3, k3);
hz_sos3 = freqz(sos3,f_akse,fs);

% Filter 4: 500-1000
freq_offset4 = 1.06;
fc4_1 = 500;       % First Cutoff Frequency
fc4_2 = 1000*freq_offset4;       % Second Cutoff Frequency
%[z4,p4,k4] = butter(N/2,[fc4_1 fc4_2]/(fs/2),'bandpass');
[z4,p4,k4] = cheby2(N/2,40,[fc4_1 fc4_2]/(fs/2),'bandpass');
sos4 = zp2sos(z4, p4, k4);
hz_sos4 = freqz(sos4,f_akse,fs);

% Filter 5: 1000-2000
freq_offset5 = 1.07;
fc5_1 = 1000;       % First Cutoff Frequency
fc5_2 = 2000*freq_offset5;       % Second Cutoff Frequency
%[z5,p5,k5] = butter(N/2,[fc5_1 fc5_2]/(fs/2),'bandpass');
[z5,p5,k5] = cheby2(N/2,40,[fc5_1 fc5_2]/(fs/2),'bandpass');
sos5 = zp2sos(z5, p5, k5);
hz_sos5 = freqz(sos5,f_akse,fs);

% Filter 6: 2000-5000
freq_offset6 = 1.07;
fc6_1 = 2000;       % First Cutoff Frequency
fc6_2 = 5000*freq_offset6;       % Second Cutoff Frequency
%[z6,p6,k6] = butter(N/2,[fc6_1 fc6_2]/(fs/2),'bandpass');
[z6,p6,k6] = cheby2(N/2,40,[fc6_1 fc6_2]/(fs/2),'bandpass');
sos6 = zp2sos(z6, p6, k6);
hz_sos6 = freqz(sos6,f_akse,fs);

% Filter 7: 5000-10000
freq_offset7 = 1.065;
fc7_1 = 5000;       % First Cutoff Frequency
fc7_2 = 10000*freq_offset7;       % Second Cutoff Frequency
%[z7,p7,k7] = butter(N/2,[fc7_1 fc7_2]/(fs/2),'bandpass');
[z7,p7,k7] = cheby2(N/2,40,[fc7_1 fc7_2]/(fs/2),'bandpass');
sos7 = zp2sos(z7, p7, k7);
hz_sos7 = freqz(sos7,f_akse,fs);

% Filter 8: 10000-20000
fc8_1 = 10000;       % First Cutoff Frequency
fc8_2 = fs/2 - 1;       % Second Cutoff Frequency - Same as nyquist
%[z8,p8,k8] = butter(N/2,[fc8_1 fc8_2]/(fs/2),'bandpass');
[z8,p8,k8] = cheby2(N/2,40,[fc8_1 fc8_2]/(fs/2),'bandpass');
sos8 = zp2sos(z8, p8, k8);
hz_sos8 = freqz(sos8,f_akse,fs);

hz_sos_tot = hz_sos1 + hz_sos2 + hz_sos3 + hz_sos4 + hz_sos5 + hz_sos6 + hz_sos7 + hz_sos8;

%% Mortens amazing GUI
% Kør koden nedenfor. Indstil gainet i de forskellige bånd. Lad være med at
% lukke vinduet, når de er indstillet. Ellers virker det ikke :-P
close all force;
fig = uifigure('Name','Equalizer','WindowState','maximized','Color', [0.73 0.90 1]);
% Window width = 1920. Window heigth = 1080
% Position = left padding, bottom padding, width, height
guioffset = (1080-840)/4;

uilabel(fig,'Position',[840 950 300 40],'FontSize',32,'FontWeight','bold','Text','Amazing EQ GUI');
panel1 = uipanel(fig,'Position',[460 770+guioffset 1000 110]);
uilabel(fig,'Position',[875 850+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','20 Hz - 100 Hz bånd [dB]');
band1 = uislider(fig,'Position',[510 820+guioffset 900 3], 'ValueChangingFcn',@(band1,event) bandfunc1(event, k1));
band1.Limits = [-18 18];
band1.Value = 0;

panel2 = uipanel(fig,'Position',[460 660+guioffset 1000 110]);
uilabel(fig,'Position',[875 740+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','100 Hz - 200 Hz bånd [dB]');
band2 = uislider(fig,'Position',[510 710+guioffset 900 3], 'ValueChangingFcn',@(band2,event) bandfunc2(event, k2));
band2.Limits = [-18 18];
band2.Value = 0;

panel3 = uipanel(fig,'Position',[460 550+guioffset 1000 110]);
uilabel(fig,'Position',[875 630+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','200 Hz - 500 Hz bånd [dB]');
band3 = uislider(fig,'Position',[510 600+guioffset 900 3], 'ValueChangingFcn',@(band3,event) bandfunc3(event, k3));
band3.Limits = [-18 18];
band3.Value = 0;

panel4 = uipanel(fig,'Position',[460 440+guioffset 1000 110]);
uilabel(fig,'Position',[875 520+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','500 Hz - 1 kHz bånd [dB]');
band4 = uislider(fig,'Position',[510 490+guioffset 900 3], 'ValueChangingFcn',@(band4,event) bandfunc4(event, k4));
band4.Limits = [-18 18];
band4.Value = 0;

panel5 = uipanel(fig,'Position',[460 330+guioffset 1000 110]);
uilabel(fig,'Position',[875 410+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','1 kHz - 2 kHz bånd [dB]');
band5 = uislider(fig,'Position',[510 380+guioffset 900 3],'ValueChangingFcn',@(band5,event) bandfunc5(event, k5));
band5.Limits = [-18 18];
band5.Value = 0;

panel6 = uipanel(fig,'Position',[460 220+guioffset 1000 110]);
uilabel(fig,'Position',[875 300+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','2 kHz - 5 kHz bånd [dB]');
band6 = uislider(fig,'Position',[510 270+guioffset 900 3],'ValueChangingFcn',@(band6,event) bandfunc6(event, k6));
band6.Limits = [-18 18];
band6.Value = 0;

panel7 = uipanel(fig,'Position',[460 110+guioffset 1000 110]);
uilabel(fig,'Position',[875 190+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','5 kHz - 10 kHz bånd [dB]');
band7 = uislider(fig,'Position',[510 160+guioffset 900 3],'ValueChangingFcn',@(band7,event) bandfunc7(event, k7));
band7.Limits = [-18 18];
band7.Value = 0;

panel8 = uipanel(fig,'Position',[460 0+guioffset 1000 110]);
uilabel(fig,'Position',[875 80+guioffset 300 20],'FontSize',16,'FontWeight','bold','Text','10 kHz - 20 kHz bånd [dB]');
band8 = uislider(fig,'Position',[510 50+guioffset 900 3], 'ValueChangingFcn',@(band8,event) bandfunc8(event, k8));
band8.Limits = [-18 18];
band8.Value = 0;

btn = uibutton(fig, 'Position', [1460 30+guioffset 100 22], 'Text', 'Plot filtre','ButtonPushedFcn',...
    @(btn,event) plotButton(f_akse, hz_sos1,hz_sos2,hz_sos3,hz_sos4,hz_sos5,hz_sos6,hz_sos7,hz_sos8,hz_sos_tot));


i = 1;
while i < fs*5
    soundsc(y_filtered(i:i+fs),fs);
    tic;
    load('gains');
    i = i+fs;
    
    % Recalculate filters
    sos1 = zp2sos(z1, p1, gain1*k1);
    hz_sos1 = freqz(sos1,f_akse,fs);
    
    sos2 = zp2sos(z2, p2, gain2*k2);
    hz_sos2 = freqz(sos2,f_akse,fs);
    
    sos3 = zp2sos(z3, p3, gain4*k3);
    hz_sos3 = freqz(sos3,f_akse,fs);
    
    sos4 = zp2sos(z4, p4, gain4*k4);
    hz_sos4 = freqz(sos7,f_akse,fs);
    
    sos5 = zp2sos(z5, p5, gain5*k5);
    hz_sos5 = freqz(sos5,f_akse,fs);
    
    sos6 = zp2sos(z6, p6, gain6*k6);
    hz_sos6 = freqz(sos6,f_akse,fs);
    
    sos7 = zp2sos(z7, p7, gain7*k7);
    hz_sos7 = freqz(sos7,f_akse,fs);
    
    sos8 = zp2sos(z8, p8, gain8*k8);
    hz_sos8 = freqz(sos8,f_akse,fs);
    endtime = toc;
    pause(1-endtime);
end

%% Functions
function bandfunc1(event, gain1)
   gain1 = gain1*10^(event.Value/20);
   save('gains.mat','gain1','-append')
end

function bandfunc2(event, gain2)
   gain2 = gain2*10^(event.Value/20);
   save('gains.mat','gain2','-append')
end

function bandfunc3(event, gain3)
   gain3 = gain3*10^(event.Value/20);
   save('gains.mat','gain3','-append')
end

function bandfunc4(event, gain4)
   gain4 = gain4*10^(event.Value/20);
   save('gains.mat','gain4','-append')
end

function bandfunc5(event, gain5)
   gain5 = gain5*10^(event.Value/20);
   save('gains.mat','gain5','-append')
end

function bandfunc6(event, gain6)
   gain6 = gain6*10^(event.Value/20);
   save('gains.mat','gain6','-append')
end

function bandfunc7(event, gain7)
   gain7 = gain7*10^(event.Value/20);
   save('gains.mat','gain7','-append')
end

function bandfunc8(event, gain8)
   gain8 = gain8*10^(event.Value/20);
   save('gains.mat','gain8','-append')
end

function plotButton(f_akse, hz_sos1,hz_sos2,hz_sos3,hz_sos4,hz_sos5,hz_sos6,hz_sos7,hz_sos8,hz_sos_tot)
    docfig = figure(1);
    docfig.WindowState = 'maximized';
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
    semilogx(f_akse, 20*log10(abs(hz_sos_tot)), 'linewidth', 1, 'Color', 'black');
    hold off
    grid on
    ylim([-25 30]);
    ylabel('Gain');
    xlim([20 20000]);
    xlabel('Frekvens [Hz]')
    title('8 båndpas filtre');
    legend('Filter1 20-100Hz','Filter2 100-200Hz','Filter3 200-500Hz','Filter4 500-1000Hz','Filter5 1000-2000Hz','Filter6 2000-5000Hz','Filter7 5000-10000Hz','Filter8 10000-20000Hz', 'Samlet filter','NumColumns',3);
   
end