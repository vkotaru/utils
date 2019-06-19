classdef Bag2Mat < handle
    
methods
    function obj = Bag2Mat(varargin)
        
    end
end

%%
methods(Static)
    
    function msgData = readPoseVelStamped(msgFile)
        tSecs = cellfun(@(m) double(m.Header.Stamp.Sec), msgFile);
        tNsecs = cellfun(@(m) double(m.Header.Stamp.Nsec), msgFile);

        msgData.t = tSecs + tNsecs*1e-9;
        msgData.p = [cellfun(@(m) double(m.Position.X), msgFile), ...
                    cellfun(@(m) double(m.Position.Y), msgFile), ...
                    cellfun(@(m) double(m.Position.Z), msgFile)];
        msgData.v = [cellfun(@(m) double(m.Velocity.X), msgFile), ...
                    cellfun(@(m) double(m.Velocity.Y), msgFile), ...
                    cellfun(@(m) double(m.Velocity.Z), msgFile)];
        msgData.q = [cellfun(@(m) double(m.Orientation.X), msgFile), ...
                    cellfun(@(m) double(m.Orientation.Y), msgFile), ...
                    cellfun(@(m) double(m.Orientation.Z), msgFile), ...
                    cellfun(@(m) double(m.Orientation.W), msgFile)];

    end
    
    function msgData = readCommandTrajectory(msgFile)
        tSecs = cellfun(@(m) double(m.Header.Stamp.Sec), msgFile);
        tNsecs = cellfun(@(m) double(m.Header.Stamp.Nsec), msgFile);

        msgData.t = tSecs + tNsecs*1e-9;
        msgData.traj_t = cellfun(@(m) double(m.TrajT), msgFile);
        
        msgData.p = [cellfun(@(m) double(m.Position.X), msgFile), ...
                    cellfun(@(m) double(m.Position.Y), msgFile), ...
                    cellfun(@(m) double(m.Position.Z), msgFile)];
        msgData.v = [cellfun(@(m) double(m.Velocity.X), msgFile), ...
                    cellfun(@(m) double(m.Velocity.Y), msgFile), ...
                    cellfun(@(m) double(m.Velocity.Z), msgFile)];
        msgData.a = [cellfun(@(m) double(m.Acceleration.X), msgFile), ...
                    cellfun(@(m) double(m.Acceleration.Y), msgFile), ...
                    cellfun(@(m) double(m.Acceleration.Z), msgFile)];
        msgData.Om = [cellfun(@(m) double(m.Omega.X), msgFile), ...
                    cellfun(@(m) double(m.Omega.Y), msgFile), ...
                    cellfun(@(m) double(m.Omega.Z), msgFile)];
        msgData.dOm = [cellfun(@(m) double(m.DOmega.X), msgFile), ...
                    cellfun(@(m) double(m.DOmega.Y), msgFile), ...
                    cellfun(@(m) double(m.DOmega.Z), msgFile)];
        msgData.M = [cellfun(@(m) double(m.Moment.X), msgFile), ...
                    cellfun(@(m) double(m.Moment.Y), msgFile), ...
                    cellfun(@(m) double(m.Moment.Z), msgFile)];
                
        msgData.f = cellfun(@(m) double(m.Thrust), msgFile);
        msgData.mode = cellfun(@(m) double(m.Mode), msgFile);
    end 
    
    function msgData = readQuadrotorLog(msgFile)
        tSecs = cellfun(@(m) double(m.Header.Stamp.Sec), msgFile);
        tNsecs = cellfun(@(m) double(m.Header.Stamp.Nsec), msgFile);

        msgData.t = tSecs + tNsecs*1e-9;
        
        msgData.euler = [cellfun(@(m) double(m.Euler.X), msgFile), ...
                    cellfun(@(m) double(m.Euler.Y), msgFile), ...
                    cellfun(@(m) double(m.Euler.Z), msgFile)];
        msgData.bodyrates = [cellfun(@(m) double(m.BodyRates.X), msgFile), ...
                    cellfun(@(m) double(m.BodyRates.Y), msgFile), ...
                    cellfun(@(m) double(m.BodyRates.Z), msgFile)];
        msgData.cmd_euler = [cellfun(@(m) double(m.CmdEuler.X), msgFile), ...
                    cellfun(@(m) double(m.CmdEuler.Y), msgFile), ...
                    cellfun(@(m) double(m.CmdEuler.Z), msgFile)];
        msgData.p = [cellfun(@(m) double(m.Position.X), msgFile), ...
                    cellfun(@(m) double(m.Position.Y), msgFile), ...
                    cellfun(@(m) double(m.Position.Z), msgFile)];
        msgData.v = [cellfun(@(m) double(m.Velocity.X), msgFile), ...
                    cellfun(@(m) double(m.Velocity.Y), msgFile), ...
                    cellfun(@(m) double(m.Velocity.Z), msgFile)];
        msgData.M = [cellfun(@(m) double(m.Moment.X), msgFile), ...
                    cellfun(@(m) double(m.Moment.Y), msgFile), ...
                    cellfun(@(m) double(m.Moment.Z), msgFile)];
                
        msgData.f = cellfun(@(m) double(m.Thrust), msgFile);
        msgData.loop_rate = cellfun(@(m) double(m.LoopRate), msgFile);
        msgData.vol = cellfun(@(m) double(m.Voltage), msgFile);
    end  
    
    function msgData = readCommandInput(msgFile)
        tSecs = cellfun(@(m) double(m.Header.Stamp.Sec), msgFile);
        tNsecs = cellfun(@(m) double(m.Header.Stamp.Nsec), msgFile);

        msgData.t = tSecs + tNsecs*1e-9;
        
        msgData.F = [cellfun(@(m) double(m.ThrustVector.X), msgFile), ...
                    cellfun(@(m) double(m.ThrustVector.Y), msgFile), ...
                    cellfun(@(m) double(m.ThrustVector.Z), msgFile)];
        msgData.euler = [cellfun(@(m) double(m.EulerAngles.X), msgFile), ...
                    cellfun(@(m) double(m.EulerAngles.Y), msgFile), ...
                    cellfun(@(m) double(m.EulerAngles.Z), msgFile)];
        msgData.Om = [cellfun(@(m) double(m.OmegaFf.X), msgFile), ...
                    cellfun(@(m) double(m.OmegaFf.Y), msgFile), ...
                    cellfun(@(m) double(m.OmegaFf.Z), msgFile)];
        msgData.dOm = [cellfun(@(m) double(m.DOmegaFf.X), msgFile), ...
                    cellfun(@(m) double(m.DOmegaFf.Y), msgFile), ...
                    cellfun(@(m) double(m.DOmegaFf.Z), msgFile)];
        msgData.M = [cellfun(@(m) double(m.MomentFf.X), msgFile), ...
                    cellfun(@(m) double(m.MomentFf.Y), msgFile), ...
                    cellfun(@(m) double(m.MomentFf.Z), msgFile)];
                
    end 
    
    function msgData = readCommandThrust(msgFile)
        tSecs = cellfun(@(m) double(m.Header.Stamp.Sec), msgFile);
        tNsecs = cellfun(@(m) double(m.Header.Stamp.Nsec), msgFile);

        msgData.t = tSecs + tNsecs*1e-9;

        msgData.F = [cellfun(@(m) double(m.ThrustVector.X), msgFile), ...
                    cellfun(@(m) double(m.ThrustVector.Y), msgFile), ...
                    cellfun(@(m) double(m.ThrustVector.Z), msgFile)];
        msgData.euler = [cellfun(@(m) double(m.EulerAngles.X), msgFile), ...
                    cellfun(@(m) double(m.EulerAngles.Y), msgFile), ...
                    cellfun(@(m) double(m.EulerAngles.Z), msgFile)];

    end 
    
    function msgData = readImuRawData(msgFile)
        tSecs = cellfun(@(m) double(m.Header.Stamp.Sec), msgFile);
        tNsecs = cellfun(@(m) double(m.Header.Stamp.Nsec), msgFile);

        msgData.t = tSecs + tNsecs*1e-9;
        
        msgData.accel = [cellfun(@(m) double(m.Acc.X), msgFile), ...
                            cellfun(@(m) double(m.Acc.Y), msgFile), ...
                            cellfun(@(m) double(m.Acc.Z), msgFile)];
        msgData.gyro = [cellfun(@(m) double(m.Gyro.X), msgFile), ...
                            cellfun(@(m) double(m.Gyro.Y), msgFile), ...
                            cellfun(@(m) double(m.Gyro.Z), msgFile)];
        msgData.mag = [cellfun(@(m) double(m.Mag.X), msgFile), ...
                            cellfun(@(m) double(m.Mag.Y), msgFile), ...
                            cellfun(@(m) double(m.Mag.Z), msgFile)];
    end
    
end
    
end



% function [varargout] = bag2mat(filename, varargin)
% 
% defaultIgnoreTopics = {'/rosout', ...
%                 '/rosout_agg', ...
%                 '/tf'};
% 
% 
% %% extract file folder
% 
% %%
% [filepath,name,ext] = fileparts(filename) ;
% 
% %% 
% bag = rosbag(filename);
% topics = bag.AvailableTopics.Properties.RowNames;
% 
% data = {};
% 
% for ind1 = 1:length(topics)
%     
%     t_ = topics{ind1};
%     
%     if any(strcmp(defaultIgnoreTopics,t_))
%         fprintf("Ignoring %s...\n",t_);
%     else
%         bTopic = select(bag,'Topic',t_);
%         msgStructs = readMessages(bTopic,'DataFormat','struct');
%         
%         if ~isempty(msgStructs)
%             % if the msg is not empty
%       
%             fields = accessFields(msgStructs{1});
%             for ind2  = 1:length(fields)
%             
%                 
%             end
%             disp('here'); 
%         end
%     end
%     
% end
% 
% 
% %% packing output
% 
% end
% 
% function [output] = accessFields(s)
% fields = fieldnames(s);
% 
% output = {};
% 
% for i =1:length(fields)
%     f =  fields{i};
%     if isstruct(s.(f)) 
%        output{end+1} = accessFields(s.(f));
%     else
%         output{end+1} = f;
%     end
% end
% 
% 
% end
% 
