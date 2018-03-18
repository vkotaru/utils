function[x] = linspace2(x0,xf,N)

dx = (xf-x0)./(N-1);
dx = repmat(dx,1,N);
dx(:,1) = x0;
x = cumsum(dx,2);

end