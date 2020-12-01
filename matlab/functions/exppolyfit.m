function [p] = exppolyfit(x,y,n)
%
% y = 1/(a + a1*exp(x) + a2*exp(2x) + ...);

%%

% avoid Inf
y(find(y==0))=1e-6;
% reciprocal
yr = 1./y; 

% exponential vaule
if n>=0 && floor(n)==n
    ex = exp(x); 
else
    ex = exp(n*x); 
	n = 1;
end

% polyfit
p = polyfit(ex, yr, n);



end

