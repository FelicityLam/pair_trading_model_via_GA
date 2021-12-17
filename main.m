global price head tail
price = xlsread('tw_semiconductor.xlsx');
if price(1, 1) > 10000
    price(:, 1) = [];  % the first column is date
end
head = 247;
tail = length(price);

% setting for GA
A = [0 -1 1 0 0 0 0 0 0 0 0 0 0;
    0 0 0 1 1 1 1 1 1 1 1 1 1;
    0 0 0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
b = [0; 1; -1];
options = gaoptimset('Display', 'iter', 'TolFun', 1e-4);

% Genectic Algorithm
[para, fval, exitflag] = ga(@(x)fitness(x), 13, A, b, [], [],...
    [1 0 0 0.005*ones(1, 10)], [200 5 3 1*ones(1, 10)], [], [1], options)

sprintf('The cumulative return of the GA model is: %d%%', round((-fval)^10*100))
plot2(para(1), para(2), para(3), para(4:13)') 