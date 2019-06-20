function [out] = apply_lpf_fo(t, y, a)

out = zeros(size(y));

%%
lpf = LowPassFilterFO(a);


for i = 1:length(t)
    if i-1 < 1
        dt = 0;
    else
        dt = t(i)-t(i-1);
    end
    out(i,:) = lpf.apply(dt, y(i,:)')';
end

end