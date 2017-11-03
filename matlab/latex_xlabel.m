function latex_xlabel(name_str,varargin)
t = xlabel(name_str,'Interpreter','Latex');
if nargin > 1
   t.FontSize = varargin{1}; 
end
end