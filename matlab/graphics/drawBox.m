function drawBox(l,varargin)

dim = length(l);

if nargin > 1
    c = varargin{1};
else
    c = zeros(dim,1);
end

if nargin > 2
    color = varargin{2};
else
    color = 'k';
end

% [lx, ly, lz] = deal(l(1),l(2),l(3));
% [cx, cy, cz] = deal(c(1),c(2),c(3));

p = [];
for i = 1:2
    for j = 1:2
        if dim > 2
            for k = 1:2
               p = [p; [c(1)+(l(1)/2)*(-1)^i, c(2)+(l(2)/2)*(-1)^j, c(3)+(l(2)/2)*(-1)^k]]; 
            end
        else
            p = [p; [c(1)+(l(1)/2)*(-1)^i, c(2)+(l(2)/2)*(-1)^j]];             
        end
    end
end

hold on;
if dim == 2
    scatter(p(:,1),p(:,2), 'MarkerEdgeColor',color,...
            'MarkerFaceColor',[0 .25 .25]); hold on;
        p_ = [p(1,:); p(2,:); p(4,:); p(3,:); p(1,:)];
        plot(p_(:,1), p_(:,2), color,'linewidth',1);
elseif dim == 3
    scatter3(p(:,1),p(:,2),p(:,3), 'MarkerEdgeColor',color,...
        'MarkerFaceColor',[0 .25 .25]); hold on;
    plot3([p(1,1), p(2,1), p(4,1), p(3,1), p(1,1)],...
            [p(1,2), p(2,2), p(4,2), p(3,2), p(1,2)],...
            [p(1,3), p(2,3), p(4,3), p(3,3), p(1,3)], color,'linewidth',1);
    plot3([p(5,1), p(6,1), p(8,1), p(7,1), p(5,1)],...
            [p(5,2), p(6,2), p(8,2), p(7,2), p(5,2)],...
            [p(5,3), p(6,3), p(8,3), p(7,3), p(5,3)], color,'linewidth',1);
    plot3([p(1,1), p(2,1), p(6,1), p(5,1), p(1,1)],...
            [p(1,2), p(2,2), p(6,2), p(5,2), p(1,2)],...
            [p(1,3), p(2,3), p(4,3), p(3,3), p(1,3)], color,'linewidth',1);
    plot3([p(3,1), p(4,1), p(8,1), p(7,1), p(3,1)],...
            [p(3,2), p(4,2), p(8,2), p(7,2), p(3,2)],...
            [p(3,3), p(4,3), p(8,3), p(7,3), p(3,3)], color,'linewidth',1);

end
    



end