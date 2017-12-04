function latex_ylabel(name_str,varargin)
t = ylabel(name_str,'Interpreter','Latex');
if nargin > 1
   t.FontSize = varargin{1}; 
else 
    t.FontSize = 15;
end
end