function [varargout] = print_fig(opts_in, fig_handle)
% function to print figures as eps, pdf etc 
% useful for writing papers
%
% function usage:
% >> print_fig(opts, fig_handle)
%
% options
% -------
% opts.print.index = 1;
% opts.print.pos_sz_stored{1} = [0.25 2.5 8 2.4];
% opts.print.pos_sz_stored{2}  = [0.25 2.5 8 4];
% opts.print.pos_sz_stored{3} = [0.25 2.5 8 6.25];
% opts.print.pos_sz_stored{4} = [0.25 2.5 8 8.5];
% opts.print_pos_sz = []; % [0.25 0.25 2 2]
% 
% opts.print.filename = 'tmp_image';
% opts.print.ext = '.eps';


%% default options

opts_default.print.index = 1;
opts_default.print.pos_sz_stored{1} = [0.25 2.5 8 2.4];
opts_default.print.pos_sz_stored{2}  = [0.25 2.5 8 4];
opts_default.print.pos_sz_stored{3} = [0.25 2.5 8 6.25];
opts_default.print.pos_sz_stored{4} = [0.25 2.5 8 8.5];
opts_default.print_pos_sz = []; % [0.25 0.25 2 2]

opts_default.print.filename = 'tmp_image';
% opts_default.print.ext = '.eps';
opts_default.print.ext = '-depsc';

%% extracting information
options = struct('Recursive', true, 'AllowNew', true);
opts = struct_overlay(opts_default, opts_in, options);
% verifying print options
if isempty(opts.print_pos_sz)
    opts.print_pos_sz = opts.print.pos_sz_stored{opts.print.index};
end

%% printing the plot 
set(fig_handle, 'PaperPositionMode', 'manual');
set(fig_handle, 'PaperUnits', 'inches');
set(fig_handle, 'PaperPosition', opts.print_pos_sz); 
<<<<<<< HEAD
% set(fig_handle, 'OuterPosition', opts.print_out_sz);
pause(0.1);
=======
>>>>>>> e11a2f14f9065eec6947406ab59ff87c9eaada8a
get(fig_handle);
print(opts.print.filename,opts.print.ext,'-r300');%

if nargin > 1
    varargout{1} = gcf;
end

end
