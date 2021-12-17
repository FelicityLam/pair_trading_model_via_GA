function f = benchmark(head, tail)
% allocate the capital in equal proportion to each stock

global price
capital_init = 1000000;

hold_price = price(head, :);
share = (capital_init / 10) ./ hold_price;   
capital = price(head:tail, :) * share';
profit = capital - capital_init;
ret = profit / capital_init;
ret = [0; ret];
f = ret;
end