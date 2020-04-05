function [human_sig] = get_human(N)
%% human
upsample_fs = 96000;
[sampledata2,FS] = audioread('camera.m4a');
human_raw_sig = resample(sampledata2,upsample_fs,FS);
human_sig = repmat(human_raw_sig*100,80,1);
human_sig = human_sig/max(human_sig);
human_sig = human_sig(1:N);
N = size(human_sig,1);
human_sig_fft = abs(fft(human_sig))/N*2;
f = upsample_fs/N:upsample_fs/N:upsample_fs;
figure;subplot(211),plot(f/1000,human_sig_fft);
xlabel("f/kHz");
title("human fft");
 
t = (1:1:N)/upsample_fs;
subplot(212),plot(t,human_sig);
xlabel("t/s");
title("human sig ")
saveas(gcf,'human_sig.pdf');
end

