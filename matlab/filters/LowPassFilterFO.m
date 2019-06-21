classdef LowPassFilterFO < handle
   
properties 
	tau 
    alpha  
    prev_output
end

%%
methods
    function obj = LowPassFilterFO(sample_freq, cutoff_freq)
        obj.set_cutoff_freq(sample_freq, cutoff_freq);
        obj.prev_output = zeros(3,1);
    end
    
    function set_cutoff_freq(obj, fs, fc)
        obj.tau = 1/(2*pi*fc); % seconds (time-constant);
        dt = 1/fs;             % seconds (sampling time);
        obj.alpha = exp(-dt/obj.tau); 
    end
    
    function [output] = apply(obj, sample)
        output = (1-obj.alpha).*sample + ...
                            obj.alpha.*obj.prev_output;
        obj.prev_output = output;
    end
    
    function [output] = apply2(obj, dt, sample)
        alpha = exp(-dt/obj.tau);
        output = (1- alpha).*sample + ...
                             alpha.*obj.prev_output;
        obj.prev_output = output;
    end
    
    function [output] = reset(obj, sample)
       obj.prev_output = sample;
       output = sample;
    end
end
    
    
end