<<<<<<< HEAD
function  [t]= latex_title(name_str,varargin)
=======
function [t] = latex_title(name_str,varargin)
>>>>>>> e11a2f14f9065eec6947406ab59ff87c9eaada8a
t = title(name_str,'Interpreter','Latex');
if nargin > 1
   t.FontSize = varargin{1}; 
else 
    t.FontSize = 15;
end
end