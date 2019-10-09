function  [F, Xm] = smthoct1(X, fs, M, stst);


%  [F, Xm] = smthoct(X, fs, M, stst, P)
%
%  Smooths the spectrum in X sampled by fs in 1/M octaves
%  The two-element vector stst contains start and stop frequencies,
%  


X = abs(X);
N = length(X);
alpha = N/fs;
F = []; Xm = [];

if or(M>30, M<1)
    disp('illegal smoothing')
    return
end

if length(X(1,:)) < length(X(:,1))
  X = X';
end

P = 2500;


f_start  = stst(1);
f_end    = stst(2);

Antal_Moktaver = ceil(log(f_end/f_start)/log(2^(1/M)));
Antal_samples  = round(P/Antal_Moktaver);
I = [0:Antal_Moktaver];

f_centers = f_start*((2^(1/M)).^I);
f_lows    = f_centers/(sqrt(2)^(1/M));
f_highs   = f_centers*(sqrt(2)^(1/M));

for i=1:Antal_Moktaver+1

  flow_log  = log10(f_lows(i));
  fhigh_log = log10(f_highs(i));
  freq_i    = logspace(flow_log,fhigh_log,Antal_samples+1);
  freq_i    = freq_i(1:end-1);
  
  Mspectrum_index = [round(alpha*f_lows(i)):round(alpha*f_highs(i))];
  XMoct(i) = mean(X(Mspectrum_index));
  
  F = [F freq_i];
  
end

f_axis = alpha*[f_lows(1) f_centers f_highs(end)];
XMoct_start = mean(X(round(alpha*f_lows(1)):round(alpha*(f_lows(1))+3)));
XMoct_end = mean(X(round(alpha*(f_highs(end))-300):round(alpha*f_highs(end))));
XM = [XMoct_start XMoct XMoct_end];

Xm = spline(f_axis, XM, alpha*F);

