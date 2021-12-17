function f = plot2(n, x, y, beta)
% plot the cumulative return curve of GA model and benchmark model
global price head tail              

spread = price * beta;
[open, close, ma, stop] = bollingBand(spread, n, x, y, head, tail); 
h = false;                 
hold_state = 0;               
hold_price = 0;
capital_init = 1000000;
share = 0;
capital = capital_init;
rf = 0.05 / 250;
p = price(head:tail, :);
pro(1) = 0;
day = 0;

for i = 1:length(p)    
    if i >= 2
        if h == false
            pro(i) = capital * rf;
        else
            if hold_state == 1
                pro(i) = (spread(i) - spread(i - 1)) * share;
            else
                pro(i) = (spread(i - 1) - spread(i)) * share;
            end
        end
    end
    
    if h == false
        if spread(i) >= open(i) % short
            hold_price = spread(i);
            share = capital / spread(i);
            cash = 0;
            hold_state = -1;
            h = true;
        elseif spread(i) <= -open(i) % long
            hold_price = spread(i);
            share = capital / spread(i);
            cash = 0;
            hold_state = 1;
            h = true; 
        end
    else
        if spread(i) <= close(i) && hold_state == -1 % close the short position
            profit = (hold_price - spread(i)) * share;
            capital = capital + profit; % dividend reinvestment
            share = 0;
            cash = capital;
            hold_state = 0;
            h = false;
        end
        if spread(i) >= -close(i) && hold_state == 1 % close the long position
            profit = (spread(i) - hold_price) * share;
            capital = capital + profit;
            share = 0;
            cash = capital;
            hold_state = 0;
            h = false;
        end
    end
    
%     if h == false
%         day = day + 1;
%     else
%         day = 0;
%     end
%     
%     if day >= 30
%         if spread(i) >= ma(i) % short
%             hold_price = spread(i);
%             share = capital / spread(i);
%             hold_state = -1;
%             h = true;
%         else % long
%             hold_price = spread(i);
%             share = capital / spread(i);
%             hold_state = 1;
%             h = true;
%         end
%         day = 0;
%     end
    
    ret_ga(i) = sum(pro(1:i)) / capital_init;
end
ret_ga = [0 ret_ga] * 100;
ret_bm = benchmark(head, length(price)) * 100;

% plot setting
plot(1:length(ret_bm), ret_bm, 'b', 'LineWidth', 1.25);
hold on
plot(1:length(ret_ga), ret_ga, 'r --', 'LineWidth', 0.75);
set(gca, 'fontname', 'Times');
legend('Benchmark', 'GA-based model')
title('Accumulated return of the 10 Taiwan semiconductor stocks (2003-2012)', 'Fontsize', 12)
xlabel('Time')
ylabel('Accumulated return(%)')
xtickangle(90)
xticklabels({'2009/01/01','2011/01/01','2013/01/01', '2015/01/01', '2017/01/01', '2018/12/31'});
grid on
end