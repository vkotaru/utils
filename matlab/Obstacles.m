classdef Obstacles < handle
    %% Class to define various obstacles
    
    %%
    properties (Access=protected)
       defaultShape = 'sphere';
       expectedShapes = {'sphere','ellipsoid', 's-ellipsoid', 'cube', 'cylinder', 'cuboid'}; 
        
       defaultCenter = [0;0;0];
       defaultRadius = 1;
       defaultOrder = 2;
       defaultBuffer = 0.2;
    end
    properties (SetAccess=protected, GetAccess=public)
        shape 
        center
        radius
        degree
        buffer
        n = 20;
    end
    %%
    methods
        %%
        function obj = Obstacles(varargin)
            % parsing the inputs
            p = inputParser;
            addOptional(p,'center',obj.defaultCenter);
            addOptional(p,'radius',obj.defaultRadius);
            addOptional(p,'degree',obj.defaultOrder,...
                         @(x) rem(x,2)==0);
            addOptional(p,'buffer',obj.defaultBuffer);
            addParameter(p,'shape',obj.defaultShape,...
                         @(x) any(validatestring(x,obj.expectedShapes)));
            parse(p,varargin{:});        

            % assigning the inputs
            obj.center = p.Results.center;
            obj.radius = p.Results.radius;
            obj.shape  = p.Results.shape;
            obj.degree  = p.Results.degree;
            obj.buffer = p.Results.buffer;

            if ~strcmp(obj.shape,'s-ellipsoid') && obj.degree > 2
                warn_msg = strcat('For the shape "',obj.shape,'" degree "',...
                    int2str(obj.degree),'" is not preferred');
                warning(warn_msg);
            end
            if strcmp(obj.shape,'sphere') && length(obj.radius)~=3
               obj.radius = obj.radius*ones(3,1);
            end
        end
        
        %%
        function [output] = getData(obj)
            output.center = obj.center;
            output.radius = obj.radius;
            output.degree  = obj.degree;
            output.shape  = obj.shape;
        end
        
        function [eq] = getEquation(obj, x, dim)
            if dim == 2
                if strcmp('s-ellipsoid',obj.shape)
                    eq = ((x(1)-obj.center(1))/obj.radius(1)).^(obj.degree) + ...
                        ((x(2)-obj.center(3))/obj.radius(3)).^(obj.degree)-1;
                end
            elseif dim == 3
                 if strcmp('s-ellipsoid',obj.shape)
                    eq = ((x(1)-obj.center(1))/obj.radius(1)).^(obj.degree) + ...
                        ((x(2)-obj.center(2))/obj.radius(2)).^(obj.degree)+...
                        ((x(3)-obj.center(3))/obj.radius(3)).^(obj.degree)-1;
                end
            end
            
        end
        
        %%
        function plot(obj)
            % function to plot the obstacles
            if strcmp('sphere',obj.shape)
                [x,y,z] = sphere(obj.n);
                surf_handle = surf(x*obj.radius(1)+obj.center(1),...
                                    y*obj.radius(1)+obj.center(2),...
                                    z*obj.radius(1)+obj.center(3));
                surf_handle.LineStyle = ':';
                surf_handle.FaceAlpha = 0.5;
                
            elseif strcmp('ellipsoid',obj.shape)
                [x, y, z] = ellipsoid(obj.center(1),obj.center(2),obj.center(3),...
                                        obj.radius(1),obj.radius(2),obj.radius(3),obj.n);
                surf_handle = surf(x, y, z);
                surf_handle.LineStyle = ':';
                surf_handle.FaceAlpha = 0.5;
                
            elseif strcmp('s-ellipsoid',obj.shape)
                [xc,yc,zc]= deal(obj.center(1),obj.center(2),obj.center(3));
                [xr,yr,zr]= deal(obj.radius(1),obj.radius(2),obj.radius(3));
                N = obj.degree;

                theta = linspace(-pi,pi);
                THETA = repmat(theta',1,obj.n);
                xr_ = repmat(linspace(0,xr,obj.n),length(theta),1);
                yr_ = repmat(linspace(0,yr,obj.n),length(theta),1);
                zr_ = repmat(linspace(0,zr,obj.n),length(theta),1);
                
                X = [xc+xr_.*(cos(THETA)).^(N/2);...
                        xc+xr_.*(cos(THETA)).^(N/2);...
                        xc-xr_.*(cos(THETA)).^(N/2);...
                        xc-xr_.*(cos(THETA)).^(N/2);]; 
                Y = [yc+yr_.*(sin(THETA)).^(N/2);...
                        yc-yr_.*(sin(THETA)).^(N/2);...
                        yc+yr_.*(sin(THETA)).^(N/2);...
                        yc-yr_.*(sin(THETA)).^(N/2)];
                tmp =  (1 - ((X-xc).^N)/(xr)^N -((Y-yc).^N)/(yr)^N);
                tmp(tmp<0) = 0;
                Z = zr*nthroot(tmp,N);
                [Xdata,Ydata,Zdata] = deal([X;X],[Y;Y],[(zc+Z);(zc-Z)]);
                clear X Y Z tmp 
                
                Y = [yc+yr_.*(cos(THETA)).^(N/2);...
                        yc+yr_.*(cos(THETA)).^(N/2);...
                        yc-yr_.*(cos(THETA)).^(N/2);...
                        yc-yr_.*(cos(THETA)).^(N/2);]; 
                Z = [zc+zr_.*(sin(THETA)).^(N/2);...
                        zc-zr_.*(sin(THETA)).^(N/2);...
                        zc+zr_.*(sin(THETA)).^(N/2);...
                        zc-zr_.*(sin(THETA)).^(N/2)];
                tmp =  (1 - ((Y-yc).^N)/(yr)^N -((Z-zc).^N)/(zr)^N);
                tmp(tmp<0) = 0;
                X = xr*nthroot(tmp,N);
                [Xdata,Ydata,Zdata] = deal([Xdata; xc+X;xc-X],[Ydata; Y;Y],[Zdata; Z;Z]);
                clear X Y Z tmp 

                Z = [zc+zr_.*(cos(THETA)).^(N/2);...
                        zc+zr_.*(cos(THETA)).^(N/2);...
                        zc-zr_.*(cos(THETA)).^(N/2);...
                        zc-zr_.*(cos(THETA)).^(N/2);]; 
                X = [xc+xr_.*(sin(THETA)).^(N/2);...
                        xc-xr_.*(sin(THETA)).^(N/2);...
                        xc+xr_.*(sin(THETA)).^(N/2);...
                        xc-xr_.*(sin(THETA)).^(N/2)];
                tmp =  (1 - ((Z-zc).^N)/(zr)^N -((X-xc).^N)/(xr)^N);
                tmp(tmp<0) = 0;
                Y = yr*nthroot(tmp,N);
                [Xdata,Ydata,Zdata] = deal([Xdata; X; X],[Ydata; yc+Y;yc-Y],[Zdata; Z;Z]);
                clear X Y Z tmp 
                
                surf_handle = surf(Xdata,Ydata,Zdata); 
                surf_handle.LineStyle = 'none';
                surf_handle.FaceAlpha = 0.5;
            
            end
        end
        
    end
end