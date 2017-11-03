function latex_zlabel(name_str,varargin)
t = zlabel(name_str,'Interpreter','Latex');
if nargin > 1
   t.FontSize = varargin{1}; 
end
end