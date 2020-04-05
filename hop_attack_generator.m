function [attack_mod_reshaped_sig] = hop_attack_generator()
clear all;clc;
upsample_fs = 96000;
[sampledata1,FS] = audioread('camera4.m4a');
% % % % 读攻击信号
% % % % 选择是否对攻击信号进行限带处理，这里控制单边频带宽度低于4K
d = fdesign.lowpass('Fp,Fst,Ap,Ast',4000/FS*2,8000/FS*2,1,60);
Hd=design(d,'butter');
sampledata1=filter(Hd,sampledata1);

attack_raw_sig = repmat(sampledata1*100,10,1);% 周期性延拓10个周期，FFT更准确
attack_upsample_sig = resample(attack_raw_sig(:,1),upsample_fs,FS);
attack_upsample_sig = attack_upsample_sig/max(attack_upsample_sig); %对信号归一化处理
attack_upsample_fft = abs(fft(attack_upsample_sig));

% figure  增加了一部分代码，将对称的fft图像去除多余的一半，仅保留低频部分
length = size(attack_upsample_sig,1);
n=0:length-1;
f=n*FS/length;
figure;subplot(211),plot(f(1:length/2)/1000,attack_upsample_fft(1:length/2)/length*2);
xlabel("f/kHz");
title("攻击信号基带频谱")

t = (1:1:length)/upsample_fs;
subplot(212),plot(t,attack_upsample_sig);
xlabel("t/s");
title("攻击信号时域图")

% DC
attack_premod_sig = attack_upsample_sig + 1;

% modulation
frenumber=3;                       %跳频频点个数
hopbw=5000;                       %频点间隔
hopnumber=10;                      %跳频次数
fs = 96000;                       %升采样率
hopfrequency=[25000:hopbw:(25000+hopbw*(frenumber-1))];         %调频频率
hoplength=length/10;
attack_reshape_sig=reshape(attack_premod_sig,hoplength,10);
attack_reshape_sig=attack_reshape_sig';
for i=1:10
    attack_mod_sig(i,:)=modulate(attack_reshape_sig(i,:),hopfrequency(mod(i-1,frenumber)+1),fs,'am');
end    
attack_mod_sig=attack_mod_sig';
attack_mod_reshaped_sig=reshape(attack_mod_sig,length,1);
attack_mod_fft = abs(fft(attack_mod_reshaped_sig));

f = upsample_fs/length:upsample_fs/length:upsample_fs;
figure;subplot(211),plot(f/1000,attack_mod_fft/length*2); ylim([0 0.01]);xlim([0 40]);
xlabel("f/kHz");
title("攻击信号调制频谱");
t = (1:1:length)/upsample_fs;
subplot(212);plot(t,attack_mod_reshaped_sig);
xlabel("t/s");
title("攻击信号时域图")
saveas(gcf,'attack_mod.pdf');
audiowrite('attack.m4a',attack_mod_reshaped_sig,48000);
end