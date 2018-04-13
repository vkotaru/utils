function [points] = shortestPath(start,goal,O,R,bounds,varargin)
% function to calculate shortest path
% 
%%
if nargin > 5
   robot = varargin{1};
else
    robot.l = 0.25;
    robot.w = 0.25;
    robot.h = 0.1;
    robot.vert = R.V;
end
if nargin > 6
    plotFlag = varargin{2};
else
    plotFlag = false;
end
n = length(O);

%% plot of the environment
if plotFlag
    figure(1); hold on;
    plot3(0,0,0,'-go','MarkerSize',8);
    plot3(start(1),start(2),start(3),'-bs','MarkerSize',8,'MarkerFaceColor',[0,0,1]);
    plot3(goal(1),goal(2),goal(3),'-bd','MarkerSize',8,'MarkerFaceColor',[0,0,1]);
    for i = 1:n
       O{i}.plot;
       alpha(0.5);
    end
    R.plot('Color','g','alpha',0.1);
end

%% configuration space
if plotFlag
    f2 = figure(2); hold on;
    plot3(0,0,0,'-go','MarkerSize',8);
    plot3(start(1),start(2),start(3),'-bs','MarkerSize',8,'MarkerFaceColor',[0,0,1]);
    plot3(goal(1),goal(2),goal(3),'-bd','MarkerSize',8,'MarkerFaceColor',[0,0,1]);
    R.plot('Color','g','alpha',0.1);
    drawBox([bounds.ub-bounds.lb],0.5*[bounds.lb+bounds.ub]);
    hold on;
end
O2 = cell(1,n);
for i = 1:n
    O{i}.plot;
    [newVerts] = obstacleConfigSpace(O{i}.V,robot,O{i},R);
    O2{i} = Polyhedron('V',newVerts);
    if plotFlag
        O2{i}.plot('Color','b','alpha',0.2);
    end
end

%% vertex set
vertexSet = []; 
edgeSet = [];
for i = 1:n
    tempv = O2{i}.V;  % c-space vertices
    tempe = [];

    for j = 1:(size(tempv,1)-1)
        tempe(j,:) = [tempv(j,:),tempv(j+1,:)];
    end
    tempv(size(tempv,1),:) = [];
    vertexSet = [vertexSet; tempv, i*ones(size(tempv,1),1)];
end
vertexSet = [start, 0; 
                vertexSet;
                goal, Inf]; % Set of all the vertices in C-SPACE

%% checkt visibility

nn= size(vertexSet,1);
vGraph = ones(nn,nn);
distGraph = Inf*ones(nn,nn);
for j = 1:nn
    for i = 1:nn
%         fprintf('i=%d, j=%d\n',i,j);
%         if i > 29
%             keyboard;
%         end
        if  i~=j 
            vGraph(j,i) = visibility3D(vertexSet(j,:),vertexSet(i,:),O2);
            if vGraph(j,i)
                distGraph(j,i) = norm(vertexSet(j,1:3)-vertexSet(i,1:3));
                p1 = [vertexSet(j,:);vertexSet(i,:)];
                if plotFlag
                    plot3(p1(:,1),p1(:,2),p1(:,3),'c'); 
%                   scatter(vertexSet(i,1),vertexSet(i,2),'k');
                end
            end
        end        
    end
%     drawnow;
% close all;
end

%% SHORTEST PATH ALGO
d = length(vertexSet);
[e L] = dijkstra(distGraph,1,d);

if e == Inf
    disp('NO PATH EXISTS');
else
%     figure(3]2\\\);
    points = vertexSet(L,1:3);
    disp('SHORTEST PATH - vertices');disp(L); 
    if plotFlag
        plot3(points(:,1),points(:,2),points(:,3),'k','LineWidth',2);
    end
end

end




%% additional functions
function [newVerts] = obstacleConfigSpace(obstVerts,robot,varargin)
    if nargin > 2
        O = varargin{1};
        R = varargin{2};
    end
    l = robot.l;    w = robot.w;    h = robot.h;

    n = size(obstVerts,1);
    newVerts =  obstVerts;

    minx = min(obstVerts(:,1));
    miny = min(obstVerts(:,2));
    minz = min(obstVerts(:,3));

    maxx = max(obstVerts(:,1));
    maxy = max(obstVerts(:,2));
    maxz = max(obstVerts(:,3));
    
    ind = find(abs(obstVerts(:,1)-minx)<1e-3);
    newVerts(ind,1) = obstVerts(ind,1)-[l/2]; clear ind;
    ind = find(abs(obstVerts(:,2)-miny)<1e-3);
    newVerts(ind,2) = obstVerts(ind,2)-[w/2]; clear ind;
    ind = find(abs(obstVerts(:,3)-minz)<1e-3);
    newVerts(ind,3) = obstVerts(ind,3)-[h/2]; clear ind;

    ind = find(abs(obstVerts(:,1)-maxx)<1e-3);
    newVerts(ind,1) = obstVerts(ind,1)+[l/2]; clear ind;
    ind = find(abs(obstVerts(:,2)-maxy)<1e-3);
    newVerts(ind,2) = obstVerts(ind,2)+[w/2]; clear ind;
    ind = find(abs(obstVerts(:,3)-maxz)<1e-3);
    newVerts(ind,3) = obstVerts(ind,3)+[h/2]; clear ind;
end

function [flag] = visibility3D(p1,p2,O2)
debug =0;

if debug
    figure; hold on;
    plot3(0,0,0,'-go','MarkerSize',8);
    plot3(p1(1),p1(2),p1(3),'-bs','MarkerSize',8,'MarkerFaceColor',[0,0,1]);
    plot3(p2(1),p2(2),p2(3),'-bd','MarkerSize',8,'MarkerFaceColor',[0,1,1]);
    plot3([p1(1), p2(1)],[p1(2), p2(2)],[p1(3), p2(3)],'c');
    color = ['r','g','b','m','c','y','k'];
end

flag = true;
for i = 1:length(O2)
    
    n = p2-p1;
    A = O2{i}.A;
    b = O2{i}.b;
    
    if debug
        gcf;
        O2{i}.plot('Color',color(i),'alpha',0.4); hold on;
    end
    
    if O2{i}.contains(p1(1:3)') && O2{i}.contains(p2(1:3)')
        if abs(p1(1)-p2(1))>1e-3  && abs(p1(2)-p2(2))>1e-3 && abs(p1(3)-p2(3))>1e-3
            flag = false;
        end
        return;          
    else      
%         size(A,1)
        for j = 1:size(A,1)
           t = (b(j) - A(j,:)*p1(1:3)')/(A(j,:)*n(1:3)');
           if 1e-6 < t && t< 1-1e-6
               inter_point = p1(1:3)'+n(1:3)'*t;
               if O2{i}.contains(inter_point)
                   flag = false;
                   return;
               end
           end
        end
    end
end
end


