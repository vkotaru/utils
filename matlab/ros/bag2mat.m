function [varargout] = bag2mat(filename, varargin)


filename = '/home/kotaru/workspace/catkin_ws/qrotor/bags/vel-estm/nov_3/2018-11-03-18-39-50.bag';
%%
ignoreTopics = {'/rosout', ...
                '/rosout_agg', ...
                '/tf'};


%% 
bag = rosbag(filename);
topics = bag.AvailableTopics.Properties.RowNames;

data = {};

for ind1 = 3%1:length(topics)
    
    t_ = topics{ind1};
    
    if any(strcmp(ignoreTopics,t_))
        fprintf("Ignoring %s...\n",t_);
    else
        bTopic = select(bag,'Topic',t_);
        msgStructs = readMessages(bTopic,'DataFormat','struct');
        
        if ~isempty(msgStructs)
            % if the msg is not empty
      
            fields = accessFields(msgStructs{1});
            for ind2  = 1:length(fields)
            
                
            end
            disp('here'); 
        end
    end
    
end


%% packing output

end

function [output] = accessFields(s)
fields = fieldnames(s);

output = {};

for i =1:length(fields)
    f =  fields{i};
    if isstruct(s.(f)) 
       output{end+1} = accessFields(s.(f));
    else
        output{end+1} = f;
    end
end


end

