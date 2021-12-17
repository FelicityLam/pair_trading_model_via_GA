function [open, close, ma, stop]= bollingBand(data, n, x, y, head, tail)
% Bollinger Bands
% open: opening line
% close: closing line
% ma: moving average
% stop: loss stopping line

movavg = zeros(tail - head + 1, 1);
sigma = zeros(tail - head + 1, 1);
for i = 1:(tail - head + 1)
    movavg(i) = mean(data((head - n + i):(head - 1 + i)));
    sigma(i) = std(data((head - n + i):(head - 1 + i)));
end
open = movavg + x .* sigma;   
close = movavg + y .* sigma;  
ma = movavg;                  
stop = movavg + 1.5 * sigma;
end
