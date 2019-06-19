classdef LowPassFilterFO < handle
   
properties 
    dim
    alpha
    sample
end

%%
methods
    function obj = LowPassFilterFO(dim, a)
        obj.alpha = a.*ones(dim,1);
    end
    
    function [filtered_sample] = update(obj, dt, new_sample)
        filtered_sample = (1-dt*obj.alpha).*obj.sample + ...
                            dt*obj.alpha.*new_sample;
        obj.sample = filtered_sample;
    end
end
    
    
end