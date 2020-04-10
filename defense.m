function [after_anc] = defense(attack_base_sig,attack_sec_sig,error_anc)
%% 去除一次项信号
mic_fs = 44100;
 N = size(attack_base_sig,1);
t = (1:1:N)/mic_fs;

demod_sig = sin(2*pi*t*10000)';
attack_base_sig =  attack_base_sig .* demod_sig;
d = fdesign.lowpass('Fp,Fst,Ap,Ast',14/48,20/48,1,60);
Hd=design(d,'butter');
attack_base_sig=filter(Hd,attack_base_sig);
attack_base_sig = attack_base_sig/max(attack_base_sig);
attack_base_fft = abs(fft(attack_base_sig))/N*2;
f = mic_fs/N:mic_fs/N:mic_fs;

figure;subplot(211),plot(f/1000,attack_base_fft);ylim([0 0.01]),xlim([0 25])
xlabel("f/kHz");
title("attack base fft");

subplot(212),plot(t,attack_base_sig);
xlabel("t/s");
title("attack base sig ")

 FrameSize = 120;
Length = size(attack_sec_sig,1);
NIter = Length/FrameSize;
lmsfilt2 = dsp.LMSFilter('Length',100,'Method','Normalized LMS', 'StepSize',0.05);

%wout = zeros(100,ceil(NIter));
for k = 1:NIter
 x = attack_sec_sig((k-1)*FrameSize+1:k*FrameSize)*5;
 d = error_anc((k-1)*FrameSize+1:k*FrameSize);
     [~,e,~] = lmsfilt2(x,d);
     after_anc((k-1)*FrameSize+1:k*FrameSize) = e;
 end

d = fdesign.lowpass('Fp,Fst,Ap,Ast',4/48,8/48,1,60);
Hd=design(d,'butter');
after_anc=filter(Hd,after_anc);
%audiowrite('2th_anc.m4a',after_anc,48000);

%%N = size(after_anc,1);
%%after_anc_fft = abs(fft(after_anc))/N*2;
%%f = mic_fs/N:mic_fs/N:mic_fs;
%%figure;subplot(211),plot(f/1000,after_anc_fft);
%%xlabel("f/kHz");
%%title("after anc fft");

%%t = (1:1:N)/mic_fs;
%%subplot(212),plot(t,after_anc);
%%xlabel("t/s");
%%title("after anc sig ")

end

