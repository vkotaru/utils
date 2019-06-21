function [sol] = odeEuler(dydt, tspan, y0, h,varargin)
%eulode: Euler ODE solver
%   [t,y] = odeEuler(dydt, tspan, y0, h, p1, p2,...)
%   `   uses EULER'S method to INTEGRATE an ODE
%       (uses the slope at the beginning of the stepsize to graph the
%       function.)
%Input:
%   dydt    = name of hte M-file that evaluates the ODE
%   tspan   = [ti,tf] where ti and tf = initial and final values of
%               independent variables
%   y0      = initial value of dependent variable
%   h       = step size
%   p1,p2   = additional parameter used by dydt
%Output:
%   t = vector of independent variable
%   y = vector of solution for dependent variable
% ======================================================================

%% initializing
dataFlag = false;

if nargin<4 
    error('at least 4 input arguments required')
elseif nargin == 5
    data = varargin{1};
    dataFlag = true;
end
ti = tspan(1); tf = tspan(2);

if ~ (tf>ti) 
    h = -h;
end
t = (ti:h:tf)'; 
n = length(t);
%if necessary, add an additional value of t 
%so that range goes from t=ti to tf
if t(n)<tf
    t(n+1) = tf;
    n = n+1;
    t(n)=tf;
end

if dataFlag
    odefun = @(t,x) dydt(t,x,data);
else
    odefun = @(t,x) dydt(t,x);
end
%% Euler Integration
y = repmat(y0',n,1); %preallocate y to improve efficiency
for i = 1:n-1 %implement Euler's Method
    dy = odefun(t(i),y(i,:)');
    y(i+1,:) = y(i,:) + dy'*h;
end

%% output
sol.x = t;
sol.y = y';

end
