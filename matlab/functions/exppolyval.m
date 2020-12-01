function [y] = exppolyval(p, x, n)

% exponential vaule
if n>=0 && floor(n)==n
    ex = exp(x); 
else
    ex = exp(n*x); 
end

yr = polyval(p, ex);
yr(find(yr==0))=1e-6;
y = 1./yr;

end