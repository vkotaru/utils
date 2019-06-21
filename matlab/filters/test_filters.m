
Hz = 500;
T = [0:1/Hz:10]';

%%
% amp = [1, 10, 0.5, 0.2];
% freq = [10, 0.1, 100, 2000];

amp = [1, 0.5];
freq = [1, 200];


signal = zeros(size(T));
for i = 1:length(freq)
    signal = signal + amp(i).*sin(2*pi*T*freq(i));
end

signal_fo = apply_lpf_fo(T,signal, 1);
signal_so = apply_lpf_so(T,signal, Hz, 1);

%%
close all;
ylimits = [min(-5, min(signal)), max(5, max(signal))];

figure; hold on;
compare_plots({{T, signal, '-', 1, 'orig'},...
                    {T, signal_fo, '-', 1, 'fo'},...
                    {T, signal_so, '-', 1, 'so'}});
ylim(ylimits);
grid on; grid minor;
