function freq_analysis(t, y, Fs)
% 
% time: t
% signal: y
% sampling rate: Fs

%%
% Use fft to observe the frequency content of the signal.


% Assume we capture 8192 samples at 1kHz sample rate
Nsamps = length(t);
fsamp = Fs;
Tsamp = 1/fsamp;
t = (0:Nsamps-1)*Tsamp;
% Assume the noisy signal is exactly 123Hz
% fsig = 123;
x = y;
% Plot time-domain signal
subplot(2,1,1);
plot(t, x);
ylabel('Amplitude'); xlabel('Time (secs)');
axis tight;
title('Noisy Input Signal');
% Choose FFT size and calculate spectrum
Nfft = Nsamps;
[Pxx,f] = pwelch(x,gausswin(Nfft),Nfft/2,Nfft,fsamp);
% Plot frequency spectrum
subplot(2,1,2);
plot(f,Pxx);
ylabel('PSD'); xlabel('Frequency (Hz)');
grid on;
% Get frequency estimate (spectral peak)
[~,loc] = max(Pxx);
FREQ_ESTIMATE = f(loc)
title(['Frequency estimate = ',num2str(FREQ_ESTIMATE),' Hz']);
% NFFT = length(y);
% Y = fft(y,NFFT);
% F = ((0:1/NFFT:1-1/NFFT)*Fs).';
% 
% magnitudeY = abs(Y);        % Magnitude of the FFT
% phaseY = unwrap(angle(Y));  % Phase of the FFT
% 
% helperFrequencyAnalysisPlot1(F,magnitudeY,phaseY,NFFT)

end


function helperFrequencyAnalysisPlot1(F,Ymag,Yangle,NFFT,ttlMag,ttlPhase)
% Plot helper function for the FrequencyAnalysisExample

% Copyright 2012 The MathWorks, Inc.

figure
subplot(2,1,1)
plot(F(1:NFFT/2)/1e3,20*log10(Ymag(1:NFFT/2)));
if nargin > 4 && ~isempty(ttlMag)
  tstr = {'Magnitude response of the signal',ttlMag};
else
  tstr = {'Magnitude response of the signal'};
end
title(tstr)
xlabel('Frequency in kHz')
ylabel('dB')
grid on;
axis tight 
subplot(2,1,2)
plot(F(1:NFFT/2)/1e3,Yangle(1:NFFT/2));
if nargin > 5
  tstr = {'Phase response of the signal',ttlPhase};
else  
  tstr = {'Phase response of the signal'};
end
title(tstr)
xlabel('Frequency in kHz')
ylabel('radians')
grid on;
axis tight

end