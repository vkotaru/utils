function [varargout] = print_fig(opts_in, fig_handle)
% function to generate print plots 
% useful for writing papers
%
% options
% -------
% i'm too lazy to write about options
% take a look at the code ;) 

%% default options

opts_default.print.index = 1;
opts_default.print.pos_sz_stored{1} = [0.25 2.5 8 2.4];
opts_default.print.pos_sz_stored{2}  = [0.25 2.5 8 4];
opts_default.print.pos_sz_stored{3} = [0.25 2.5 8 6.25];
opts_default.print.pos_sz_stored{4} = [0.25 2.5 8 8.5];
opts_default.print_pos_sz = []; % [0.25 0.25 2 2]

opts_default.print.filename = 'tmp_image';
opts_default.print.ext = '.eps';

%% extracting information

opts = struct_overlay(opts_default, opts_in);
% verifying print options
if isempty(opts.print_pos_sz)
    opts.print_pos_sz = opts.print.pos_sz_stored{opts.print.index};
end

%% printing the plot 
set(fig_handle, 'PaperPositionMode', 'manual');
set(fig_handle, 'PaperUnits', 'inches');
set(fig_handle, 'PaperPosition', opts.print_pos_sz); 
print(opts.print.filename,opts.print.ext,'-r300');%

if nargin > 1
    varargout{1} = gcf;
end

end
