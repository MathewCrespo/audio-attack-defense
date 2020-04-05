function [attack_base_sig] = extraction_attack_base(before_anc_sig)
%% 提取高频一次攻击信号 
% 采样频率96000，中心频率15K Hz, 单边带宽8Khz  截止频率，15-8 = 7KHz
% 截止频率: (15-8)/48 
% 通带频率:(15-4)/48 
d = fdesign.highpass('Fst,Fp,Ast,Ap',7/48,11/48,60,1);   % 提取和防御信息卷积后的一次攻击信号
d1 = fdesign.highpass('Fst,Fp,Ast,Ap',17/48,21/48,60,1); 

% d = fdesign.highpass('Fst,Fp,Ast,Ap',4/48,7.5/48,60,1);
Hd=design(d,'butter');
Hd1=design(d1,'butter');


attack_base_sig=filter(Hd,before_anc_sig);
attack_base_sig1=filter(Hd1,before_anc_sig);
attack_base_sig=attack_base_sig-attack_base_sig1;

% Wp = 11/48;
% Ws = 7/48;
% [n,Wn] = buttord(Wp,Ws,1,60)
% [B,A] = butter(n,Wn);
% attack_base_sig=filter(B,A,nonlinear_sig);

% 截止频率: 22/48 
% 通带频率:(15+4)/48 
d = fdesign.lowpass('Fp,Fst,Ap,Ast',19/48,20/48,1,60);
% d = fdesign.lowpass('Fp,Fst,Ap,Ast',12.5/48,16/48,1,60);
mic_fs = 44100;
super_fs=96000*3;
upsample_fs = 96000;
Hd=design(d,'butter');
attack_base_sig=filter(Hd,attack_base_sig);
attack_base_sig = resample(attack_base_sig,mic_fs,upsample_fs);
attack_base_sig = attack_base_sig(100:end);
attack_base_sig = attack_base_sig/max(attack_base_sig);
N = size(attack_base_sig,1);
attack_base_fft = abs(fft(attack_base_sig))/N*2;

f = mic_fs/N:mic_fs/N:mic_fs;
figure;subplot(211),plot(f/1000,attack_base_fft);ylim([0 0.01]),xlim([0 25])
xlabel("f/kHz");
title("before anc sig 的高通分量");

t = (1:1:N)/mic_fs;
subplot(212),plot(t,attack_base_sig);
xlabel("t/s");
title("before anc sig 的高通分量时域图")
saveas(gcf,'attack_base.pdf');
end

