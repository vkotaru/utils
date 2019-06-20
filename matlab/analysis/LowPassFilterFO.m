classdef LowPassFilterFO < handle
   
properties 
    dim    = 3
    alpha  = 30
    sample
end

%%
methods
    function obj = LowPassFilterFO(a)
        obj.alpha = a.*ones(3,1);
        obj.sample = zeros(3,1);
    end
    
    function [lpf_sample] = apply(obj, dt, new_sample)
        lpf_sample = (1-dt*obj.alpha).*obj.sample + ...
                            dt*obj.alpha.*new_sample;
        obj.sample = lpf_sample;
    end
end
    
    
end