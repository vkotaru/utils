function [out] = apply_lpf_so(t, y, fs, fc)

out = zeros(size(y));

%%
lpf = LowPassFilterSO(fs, fc);


for i = 1:length(t)
    if i-1 < 1
        out(i,:) = lpf.reset(y(i,:)')';
        continue;
    end
    dt = t(i)-t(i-1);
    out(i,:) = lpf.apply(y(i,:)')';
end

end