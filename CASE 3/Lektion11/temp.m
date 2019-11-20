clear;
close all;
clc;

fs = 24000;
wanted_order = 6;
fc_low = 3000;
fc_high = 4000;

% Design the filter
% Since it is bandpass, the a
[b,a] = butter(wanted_order/2,[fc_low fc_high]/fs,'bandpass');

% Verify order
if filtord(b,a) == wanted_order
    % Plot it
    figure(101);
    freqz(b,a);
    title('Butterworth filterkarakteristik');
end

figure(102);
grpdelay(b,a);

gd = grpdelay(b,a);
max(gd)

%% Opgave 3.14

clear
close all
clc

% Opgave a løst i Mathcad.
% nedenfor er opgave b og frem:

% (s+w1)/(s+w2)

w1 = 565;
w2 = 942;
Ts = 0.001;

%Bestemmelse af koefficienter fra Mathcad
b = [2.56,-1.43];
a = [2.94,-1.06];

%Vis frekvensresponsen for H(z) vha. freqz.m i Matlab
% Tegn filter
figure(101);
freqz(b,a)
title('Shelf filter frekvensrespons');

%Er H(z) filteret stabilt? Hvorfor / hvorfor ikke?

nulpunkter = roots(b);
poler = roots(a);

figure(102);
zplane(nulpunkter, poler);
%Filtret er stabilt da alle poler er inden for enhedscirklen. Dvs. mellem
%-1 og 1.

%Find differensligningen der repræsenterer H(z), altså y(n) = ... 
