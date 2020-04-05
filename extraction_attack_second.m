function [attack_sec_sig] = extraction_attack_second(attack_base_sig)
%% 提取高频二次攻击信号

%在树莓派内部 以44100处理；

% 采样频率96000
% 截止频率: (15-8)/48 
% 通带频率:(15-4)/48 

attack_sec_sig = attack_base_sig.*attack_base_sig;

% d = fdesign.lowpass('Fp,Fst,Ap,Ast',12/48,16/48,1,60);
d = fdesign.lowpass('Fp,Fst,Ap,Ast',12/48,16/48,1,60);
Hd=design(d,'butter');
attack_sec_sig=filter(Hd,attack_sec_sig);
attack_sec_sig = attack_sec_sig(100:end);
attack_sec_sig = attack_sec_sig/max(attack_sec_sig);
%阶数初步设定为80,除去卷积之后出现的高频分量

% order = 80;
% Wp = 12/48;
% Ws = 16/48;
% [n,Wn] = buttord(Wp,Ws,1,60);
% b = fir1(order,Wn,'low');
% attack_sec_sig=conv(b,attack_sec_sig);
% disp(['LPF-n 用于提取卷积结果 : ',num2str(n)]);  
mic_fs = 44100;
N = size(attack_sec_sig,1);
attack_sec_fft = abs(fft(attack_sec_sig))/N*2;

f = mic_fs/N:mic_fs/N:mic_fs;
figure;subplot(211),plot(f/1000,attack_sec_fft);ylim([0 0.01]),xlim([0 25])
xlabel("f/kHz");
title("before anc sig 的高通分量 卷积二次分量");

t = (1:1:N)/mic_fs;
subplot(212),plot(t,attack_sec_sig);
xlabel("t/s");
title("before anc sig 的高通卷积二次分量时域图")
saveas(gcf,'attack_sec_fft.pdf');
end

