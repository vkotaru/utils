function[start, goal, obst, robot,varargout]=envGen3D(n,s)
% Generates the environment for motion planning

if nargout > 4
   flagPolyhedron = 1;
else
    flagPolyhedron = false;
end

% flag = true;
% while flag

    % defininng startign and ending point
%     x0 = 10*rand(1); y0 = 0;
%     xf = 10*rand(1); yf = 10;

    allVerts = [];
    for i = 1:n
        
        l = 10*rand(1);
        w = 10*rand(1);
        h = 10*rand(1);
        vert = getVertices(l,w,h);
        c = repmat(20*rand(1,3),size(vert,1),1);
%         K = convhull(x,y) ;
        obst{i} = c+vert;
        allVerts = [allVerts; obst{i}];
        if flagPolyhedron
            
            O{i} = Polyhedron('V',obst{i});
%             O{i}.plot; hold on;
%             alpha(0.5);
        end
    end

    start = [-2,-2,-2]+min(allVerts);%[x0, y0];
    goal = [2,2,2]+max(allVerts);%[xf, yf];

    l= 2.5*rand(1); w=2.5*rand(1); h=2.5*rand(1);
    rVert = getVertices(l,w,h);
    robot.vert = rVert; %[start; start(1),start(2)+2*rand(1);start(1)+ 2*rand(1),start(2);start];
    robot.l = l;
    robot.h = h;
    robot.w = w;
    R = Polyhedron('V',robot.vert);
    
%     a = R.plot;
    
    if flagPolyhedron
        varargout{1} = O;
    end
    if nargout > 5
        
        varargout{2} = R;
        bounds.lb = min(allVerts);
        bounds.ub = max(allVerts);
        varargout{3} = bounds;
    end
    
%     plot(robot(:,1),robot(:,2),'-r');
% end
% 
% end