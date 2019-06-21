function compare_plots(dat, varargin)
%%
% dat = {x, y, ltype, lwidth, legend}
%%
hold on;
l_ = {};
for i = 1:length(dat)
    tmp = dat{i};
    l_{i} = tmp{5};
    plot(tmp{1}, tmp{2}, tmp{3}, 'linewidth', tmp{4});
end
latex_legend(l_);
% xlim(xlimits);
if nargin > 1
    latex_title(varargin{1});
end
if nargin > 2
   xlim(varargin{2}); 
end



end