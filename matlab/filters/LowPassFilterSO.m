classdef LowPassFilterSO < handle
   
properties
    cutoff_freq = 0;
    a1 = 0
    a2 = 0
    
    b0 = 0
    b1 = 0
    b2 = 0
    
    delay_element_1 = zeros(3,1)
    delay_element_2 = zeros(3,1)
    
end

%%
methods
    function obj = LowPassFilterSO(sample_freq, cutoff_freq)
       obj.set_cutoff_frequency(sample_freq, cutoff_freq); 
    end
    
    function set_cutoff_frequency(obj, fs, fc)
        obj.cutoff_freq = fc;
%         obj.delay_element_1 = zeros(3,1);
%         obj.delay_element_2 = zeros(3,1);
        
        if (fc < 0)
            return
        end
        
        fr = fs/obj.cutoff_freq;
        ohm = tan(pi/fr);
        c = 1 + 2*cos(pi/4)*ohm + ohm^2;
        
        obj.b0 = ohm^2/c;
        obj.b1 = 2*obj.b0;
        obj.b2 = obj.b0;
        
        obj.a1 = 2*(ohm^2-1)/c;
        obj.a2 = (1-2*cos(pi/4)*ohm + ohm*ohm)/c;
        
    end
    
    function [output] = apply(obj, sample)
        delay_element_0 = sample - obj.delay_element_1*obj.a1 - obj.delay_element_2 * obj.a2;
        output = delay_element_0 *obj.b0 + obj.delay_element_1 *obj.b1 + obj.delay_element_2 * obj.b2;
        
        obj.delay_element_2 = obj.delay_element_1;
        obj.delay_element_1 = delay_element_0;
        
    end
    
    function [output] = apply2(obj, dt, sample)
        obj.set_cutoff_frequency(1/dt, obj.cutoff_freq); 
        delay_element_0 = sample - obj.delay_element_1*obj.a1 - obj.delay_element_2 * obj.a2;
        output = delay_element_0 *obj.b0 + obj.delay_element_1 *obj.b1 + obj.delay_element_2 * obj.b2;
        
        obj.delay_element_2 = obj.delay_element_1;
        obj.delay_element_1 = delay_element_0;
        
    end
    
    function [output] = reset (obj, sample)
        obj.delay_element_1 = sample;
        obj.delay_element_2 = sample;
        output = obj.apply(sample);
    end
    
end
    
end