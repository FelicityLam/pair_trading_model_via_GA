function f = fitness(var)
% Parameters to be estimated
n = var(1);                   % MA: length of the time window
x = var(2);                   % Bollinger Band: opening track
y = var(3);                   % Bollinger Band: closing track
beta = var(4:13)';             % Portfolio: weights of stocks 

% Import data
global price head tail
period = 10;                  % training period(unit: year)

spread = price * beta;        % price spread
[open, close, ma, stop] = bollingBand(spread, n, x, y, head, tail); % opening and closing track

hold = false;                 % hold: true(hold a position) false(otherwise) 
hold_state = 0;               % hold_state: 1(long the spread) -1(short)
hold_price = 0;
capital_init = 1000000;       % initial capital
capital = capital_init;            
share = 0;
day = 0;
p = price(head:tail, :);

for i = 1:length(p)
    if hold == false
        if spread(i) >= open(i) % short
            hold_price = spread(i);
            %capital = capital * 0.999; % trading fee
            share = capital / spread(i);
            hold_state = -1;
            hold = true;
        elseif spread(i) <= -open(i) % long
            hold_price = spread(i);
            %capital = capital * 0.999; % trading fee
            share = capital / spread(i);
            hold_state = 1;
            hold = true;
        end
    else
        if spread(i) <= close(i) && hold_state == -1 % close the short position
            profit = (hold_price - spread(i)) * share;
            capital = (capital + profit) * 1; % dividend reinvestment
            share = 0;
            hold_state = 0;
            hold = false;
        end
        if spread(i) >= -close(i) && hold_state == 1 % close the long position
            profit = (spread(i) - hold_price) * share;
            capital = (capital + profit) * 1;
            share = 0;
            hold_state = 0;
            hold = false;
        end
        
%         if spread(i) >= stop(i) && hold_state == -1 % stop the short position
%             profit = (hold_price - spread(i)) * share;
%             capital = capital + profit; % dividend reinvestment
%             share = 0;
%             hold_state = 0;
%             hold = false;
%         end
%         if spread(i) <= -stop(i) && hold_state == 1 % stop the long position
%             profit = (spread(i) - hold_price) * share;
%             capital = capital + profit;
%             share = 0;
%             hold_state = 0;
%             hold = false;
%         end
    end
    
    if hold == false
        day = day + 1;
    else
        day = 0;
    end
    
    if day >= 30
        if spread(i) >= ma(i) % short
            hold_price = spread(i);
            share = capital / spread(i);
            hold_state = -1;
            hold = true;
        else % long
            hold_price = spread(i);
            share = capital / spread(i);
            hold_state = 1;
            hold = true;
        end
        day = 0;
    end
end
r_annum = (capital / capital_init)^(1/period);
f = -r_annum;
end
            