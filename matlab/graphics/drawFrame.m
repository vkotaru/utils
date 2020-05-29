function drawFrame(varargin)
% Draws a Right-Hand 3D frame 
%
% Inputs: drawFrame(R, xQ, length, linestyle);

%%
R = eye(3);
xQ = zeros(3,1);
length = 1;
linestyle = '-';

if nargin > 0
    R = varargin{1};
end
if nargin > 1
    xQ = varargin{2};
end
if nargin > 2
    length = varargin{3};
end
if nargin > 3
    linestyle = varargin{4};
end

e = [[length;0;0],[0;length;0],[0;0;length]];
    
    R2 = xQ + R*e;
    
%     plot3([xQ(1) R2(1,1)],[xQ(2) R2(2,1)],[xQ(3) R2(3,1)],'r','linewidth',2);
%     plot3([xQ(1) R2(1,2)],[xQ(2) R2(2,2)],[xQ(3) R2(3,2)],'g','linewidth',2);
%     plot3([xQ(1) R2(1,3)],[xQ(2) R2(2,3)],[xQ(3) R2(3,3)],'b','linewidth',2);
    
  
s.xaxis = line([xQ(1) R2(1,1)],[xQ(2) R2(2,1)],[xQ(3) R2(3,1)]); hold on ;
s.yaxis = line([xQ(1) R2(1,2)],[xQ(2) R2(2,2)],[xQ(3) R2(3,2)]);
s.zaxis = line([xQ(1) R2(1,3)],[xQ(2) R2(2,3)],[xQ(3) R2(3,3)]);

set(s.xaxis,'Color','r', 'LineWidth',2, 'LineStyle', linestyle);
set(s.yaxis,'Color','g', 'LineWidth',2, 'LineStyle', linestyle);
set(s.zaxis,'Color','b', 'LineWidth',2, 'LineStyle', linestyle);

scatter3(R2(1,1),R2(2,1),R2(3,1), 'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0.75 .0 .0]);
scatter3(R2(1,2),R2(2,2),R2(3,2), 'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0 .75 .0]);
scatter3(R2(1,3),R2(2,3),R2(3,3), 'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0. .0 .75]);

grid on; 
xlabel('X');
ylabel('Y');
zlabel('Z');
% grid minor;
    
% view([30,30]);
    
end