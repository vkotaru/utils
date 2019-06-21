function [out] = apply_lpf_fo(t, y, fs, fc)
out = zeros(size(y));

%%
lpf = LowPassFilterFO(fs, fc);


for i = 1:length(t)
    if i-1 < 1
        out(i,:) = lpf.reset(y(i,:)')';
        continue;
    end
    dt = t(i)-t(i-1);
    out(i,:) = lpf.apply(y(i,:)')';
end

end