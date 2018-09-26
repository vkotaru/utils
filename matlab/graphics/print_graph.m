function [varargout] = print_graph(opts_in, varargin)
% function to generate print plots 
% useful for writing papers
%
% options
% -------
% i'm too lazy to write about options
% take a look at the code ;) 

%% default options

% opts_default.labels.x = 'x axis';
% opts_default.labels.y = 'y axis';
% opts_default.labels.z = 'z axis';
% 
% opts_default.title.name = 'Title';
% opts_default.title.fontsize = 15;
% 
% opts_default.legend.name = ['x','y','z'];
% opts_default.legend.fontsize = 15;
% 
% opts_default.linewidth= 1;
% opts_default.fontsize = 15;

% name_n_size_default.name = 'x';
% name_n_size_default.fontsize= 15;

opts_default.plot.LineWidth = 2;
opts_default.plot.LineWidthOrder = 2;

opts_default.plot.no_of_plots = 1;
opts_default.plot.data.x{1} = [];
opts_default.plot.data.y{1} = [];
opts_default.plot.data.z = [];
opts_default.plot.type = 'plot'; % scatter
opts_default.plot.dim = '2D'; % 3D
opts_default.plot.legend.name = {'','',''};
opts_default.plot.legend.fontsize = 15;
opts_default.plot.legend.location = 'Best';
opts_default.plot.title.name = '';
opts_default.plot.title.fontsize = 15;
opts_default.plot.labels.x.name = '';
opts_default.plot.labels.x.fontsize = 15;
opts_default.plot.labels.y.name = '';
opts_default.plot.labels.y.fontsize = 15;
opts_default.plot.labels.z.name = '';
opts_default.plot.labels.z.fontsize = 15;

opts_default.plot.ColorOrder = [228, 26, 28;  55, 126, 184; 77, 175, 74;
                                152, 78, 163; 255, 127, 0; 255, 255, 51;
                                166, 86, 40; 247, 129, 191; 153, 153, 153]*(1/255);
opts_default.plot.LineStyleOrder = {'-','--',':','-.','-*'};                            
opts_default.plot.MarkerShape = [];

opts_default.subplot.flag = false; % true
opts_default.subplot.no_of_plots = 1;
opts_default.subplot.shape = [1, 1];
opts_default.subplot.plot(1,1)=opts_default.plot;


opts_default.print.index = 1;
opts_default.print.pos_sz_stored{1} = [0.25 2.5 8 2.4];
opts_default.print.pos_sz_stored{2}  = [0.25 2.5 8 4];
opts_default.print.pos_sz_stored{3} = [0.25 2.5 8 6.25];
opts_default.print.pos_sz_stored{4} = [0.25 2.5 8 8.5];
opts_default.print_pos_sz = []; % [0.25 0.25 2 2]

opts_default.print.filename = 'tmp_image';
opts_default.print.ext = '.eps';

%% extracting information

% struct_overlay is one awesome function :)
% thanks Eric Cousineau!
opts = struct_overlay(opts_default, opts_in);
if opts.subplot.flag
    for i = 1:opts.subplot.shape(1)
        for j = 1:opts.subplot.shape(2)
            temp_subplot.plot(i,j) = struct_overlay(opts_default.plot,opts.subplot.plot(i,j));
        end
    end
    opts.subplot = rmfield(opts.subplot,'plot');
    opts.subplot.plot = temp_subplot.plot;
end

% verifying print options
if isempty(opts.print_pos_sz)
    opts.print_pos_sz = opts.print.pos_sz_stored{opts.print.index};
end

% verifying if a figure is already provided
stage1_flag = true;
if nargin > 1
    stage1_flag = false;
    fig_handle = varargin{1};
    if ~ishandle(fig_handle)
        error('Input should be a figure handle');
    end
end

if stage1_flag== true
    % verifying plot data dimension
    if ~isempty(opts.plot.data.z)
        opts.plot.dim = '3D';
        if ~(length(opts.plot.data.y)==length(opts.plot.data.z))
            error('atleast y and z should have the same dimesions');
        end
    end

    % verifying colorOrder
    if iscell(opts.plot.ColorOrder)
        if ischar(opts.plot.ColorOrder{1})
            co_= opts.plot.ColorOrder;
            clear opts.plot.ColorOrder
            opts.plot.ColorOrder = ColorOrder_str2array(co_);
        end
    end
end
    

%% plotting data

% create a new figure
if stage1_flag == true
    fig_handle = figure; 
%     ax.NextPlot= 'add';
    if ~opts.subplot.flag
        ax = gca;
        set(ax,'ColorOrder',opts.plot.ColorOrder);
        set(ax,'LineStyleOrder',opts.plot.LineStyleOrder);
        hold all;
        if strcmp(opts.plot.type,'plot')
            if strcmp(opts.plot.dim,'2D')
                N = length(opts.plot.data.y);
                if length(opts.plot.LineWidthOrder)==1
                   opts.plot.LineWidthOrder = opts.plot.LineWidth*ones(1,N);
                end
                for iter= 1:N
                    if length(opts.plot.data.x) <= 1
                        x_ = opts.plot.data.x{1};
                    else
                        x_ = opts.plot.data.x{iter};
                    end
                    y_ = opts.plot.data.y{iter};
                    if strcmp(opts.plot.dim,'2D')                    
                        plot(x_,y_,...
                            'linewidth',opts.plot.LineWidthOrder(iter));
                    elseif strcmp(opts.plot.dim, '3D')
                        z_ = opts.plot.data.z{iter};
                        plot3(x_,y_,z_,...
                            'linewidth',opts.plot.LineWidthOrder(iter));
                    end
                    ax.LineStyleOrderIndex = ax.ColorOrderIndex;
                end
            end
        end
        
%         set(fig_handle,'Renderer','painters')
        % legend            
        leg1 = legend(opts.plot.legend.name);
        set(leg1,'Interpreter','latex');
        set(leg1,'FontSize',opts.plot.legend.fontsize);
        set(leg1,'Location',opts.plot.legend.location);
        % title
        t1 = title(opts.plot.title.name,'Interpreter','Latex');
        t1.FontSize = opts.plot.title.fontsize;
        %labels
        xl = xlabel(opts.plot.labels.x.name,'Interpreter','Latex');
        xl.FontSize = opts.plot.labels.x.fontsize;
        yl = ylabel(opts.plot.labels.y.name,'Interpreter','Latex');
        yl.FontSize = opts.plot.labels.y.fontsize;
        zl = zlabel(opts.plot.labels.z.name,'Interpreter','Latex');
        zl.FontSize = opts.plot.labels.z.fontsize;
        
        grid on;
        
    elseif opts.subplot.flag
        % i -->
        for i = 1:opts.subplot.shape(1)
            % j -->
            for j = 1:opts.subplot.shape(2)
                if i*j > opts.subplot.no_of_plots
                    break
                end
                fprintf('generating plot for subplot (%d, %d) and plot number %d \n',i,j,i*j);
                subplot(opts.subplot.shape(1),opts.subplot.shape(2),i*j); hold on
                ax = gca;
                set(ax,'ColorOrder',opts.plot.ColorOrder);
                set(ax,'LineStyleOrder',opts.plot.LineStyleOrder);
                hold all;
                if strcmp(opts.subplot.plot(i,j).type,'plot')
                    if strcmp(opts.subplot.plot(i,j).dim,'2D')
                        N = length(opts.subplot.plot(i,j).data.y);
                        if length(opts.subplot.plot(i,j).LineWidthOrder)==1
                           opts.subplot.plot(i,j).LineWidthOrder = opts.subplot.plot(i,j).LineWidth*ones(1,N);
                        end
                        for iter= 1:N
                            if length(opts.subplot.plot(i,j).data.x) <= 1
                                x_ = opts.subplot.plot(i,j).data.x{1};
                            else
                                x_ = opts.subplot.plot(i,j).data.x{iter};
                            end
                            y_ = opts.subplot.plot(i,j).data.y{iter};
                            if strcmp(opts.subplot.plot(i,j).dim,'2D')                    
                                plot(x_,y_,...
                                    'linewidth',opts.subplot.plot(i,j).LineWidthOrder(iter));
                            elseif strcmp(opts.subplot.plot(i,j).dim, '3D')
                                z_ = opts.subplot.plot(i,j).data.z{iter};
                                plot3(x_,y_,z_,...
                                    'linewidth',opts.subplot.plot(i,j).LineWidthOrder(iter));
                            end
                            ax.LineStyleOrderIndex = ax.ColorOrderIndex;
                        end
                    end
                end        
        %         set(fig_handle,'Renderer','painters')
                % legend            
                leg1 = legend(opts.subplot.plot(i,j).legend.name);
                set(leg1,'Interpreter','latex');
                set(leg1,'FontSize',opts.subplot.plot(i,j).legend.fontsize);
                set(leg1,'Location',opts.subplot.plot(i,j).legend.location);
                % title

                % labels
                t1 = title(opts.subplot.plot(i,j).title.name,'Interpreter','Latex');
                t1.FontSize = opts.subplot.plot(i,j).title.fontsize;
                %labels
                xl = xlabel(opts.subplot.plot(i,j).labels.x.name,'Interpreter','Latex');
                xl.FontSize = opts.subplot.plot(i,j).labels.x.fontsize;
                yl = ylabel(opts.subplot.plot(i,j).labels.y.name,'Interpreter','Latex');
                yl.FontSize = opts.subplot.plot(i,j).labels.y.fontsize;
                zl = zlabel(opts.subplot.plot(i,j).labels.z.name,'Interpreter','Latex');
                zl.FontSize = opts.subplot.plot(i,j).labels.z.fontsize;
                
                grid on;
                hold off;
            end % <-- j
        end % <-- i
    end

end


%% printing the plot 
set(fig_handle, 'PaperPositionMode', 'manual');
set(fig_handle, 'PaperUnits', 'inches');
set(fig_handle, 'PaperPosition', opts.print_pos_sz); 
print(opts.print.filename,'-depsc2','-r300');%

if nargin > 1
    varargout{1} = gcf;
end

end

function [co_out] = ColorOrder_str2array(co_in)

% defining colors
color_keySet =   {'y', 'm', 'c', 'r', 'g', 'b', 'w', 'k'};
color_valueSet = [{[1 1 0]}, {[1 0 1]}, {[0 1 1 ]}, {[1 0 0]}, {[0 1 0]}, {[0 0 1]}, {[1 1 1]}, {[0 0 0]}];
color_mapObj = containers.Map(color_keySet,color_valueSet);

co_out = [];
for i = 1:length(co_in)
   co_out = [co_out; color_mapObj(co_in{i})];
end

end
