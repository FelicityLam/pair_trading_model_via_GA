function f = plot1(year)
% plot the best-so-far curve
global fbest

plot(1:length(fbest), -fbest.^year*100);
title('The best-so-far curve by the GA');
xlabel('Generation');
ylabel('Accumulated return(%)');
legend('GA-based model');
grid on
end
