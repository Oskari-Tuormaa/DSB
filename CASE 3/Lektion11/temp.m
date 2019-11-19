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

% Opgave a l�st i Mathcad.
% nedenfor er opgave b og frem:

% (s+w1)/(s+w2)

w1 = 565;
w2 = 942;
Ts = 0.001;

laplace = tf([1 w1], [1 w2]);

z_transform = c2d(laplace,Ts)

% Output c2d:
% H(z) = (z - 0.634)/(z - 0.3898)

%Bestemmelse af koefficienter fra output af c2d (skal �ndres)
% Fra Matlab
b = [1,-0.634];
a = [1,-0.3898];

% Fra Mathcad
%b = [2.56,-1.43];
%a = [2.94,-1.06];

%Vis frekvensresponsen for H(z) vha. freqz.m i Matlab
% Tegn filter
figure(101);
freqz(b,a)
title('Shelf filter frekvensrespons');

%Er H(z) filteret stabilt? Hvorfor / hvorfor ikke?
% Fra Matlab
nulpunkter = roots([1,-0.634]);
poler = roots([1,-0.3898]);

% Fra Mathcad
%nulpunkter = roots([2.56,-1.43]);
%poler = roots([2.94,-1.06]);

figure(102);
zplane(nulpunkter, poler);
%Filtret er stabilt da alle poler er inden for enhedscirklen. Dvs. mellem
%-1 og 1.

%Find differensligningen der repr�senterer H(z), alts� y(n) = ... 
% Er det en invfft her??