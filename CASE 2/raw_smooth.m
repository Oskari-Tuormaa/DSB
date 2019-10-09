function Xsmooth = smoothing(X, M)

% function Xsmooth = smoothing(X, M)
%
% X er det komplekse spectrum
% M er udglatningsvinduet i bins (ex. 31)



v = (M-1)/2;
Xext = [zeros(1,v) abs(X) zeros(1,v)];

for k=v+1:length(Xext)-v
    Xsmooth(k) = mean(Xext(k-v:k+v));
end

Xsmooth = Xsmooth(v+1:end);

