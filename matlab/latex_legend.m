function latex_legend(name_str,varargin)
t = legend(name_str);
set(t,'Interpreter','Latex'); 
if nargin > 1
   t.FontSize = varargin{1}; 
end
end