% try ANC (adaptive filter using LMS winner filtering)

clc;clear all;close all;


% % % % % % % % %% gnerate attack signal (FS = 96000,Fc = 96000)
% % % % % % % % upsample_fs = 96000;
% % % % % % % % [sampledata1,FS] = audioread('Hi, galaxy. Take a photo.mp3');
% % % % % % % % % 读攻击信号
% % % % % % % % % 选择是否对攻击信号进行限带处理，这里控制单边频带宽度低于4K
% % % % % % % % d = fdesign.lowpass('Fp,Fst,Ap,Ast',4000/FS*2,8000/FS*2,1,60);
% % % % % % % % Hd=design(d,'butter');
% % % % % % % % sampledata1=filter(Hd,sampledata1);
% % % % % % % % 
% % % % % % % % 
% % % % % % % % attack_raw_sig = repmat(sampledata1*100,10,1);
% % % % % % % % attack_upsample_sig = resample(attack_raw_sig(:,1),upsample_fs,FS);
% % % % % % % % attack_upsample_sig = attack_upsample_sig/max(attack_upsample_sig);
% % % % % % % % 对信号做归一化处理
% % % % % % % % attack_upsample_fft = abs(fft(attack_upsample_sig));
% % % % % % % % 
% % % % % % % % % figure
% % % % % % % % f = upsample_fs/size(attack_upsample_fft,1):upsample_fs/size(attack_upsample_fft,1):upsample_fs;
% % % % % % % % figure;subplot(211),plot(f/1000,attack_upsample_fft/size(attack_upsample_fft,1)*2);
% % % % % % % % xlabel("f/kHz");
% % % % % % % % title("攻击信号基带频谱")
% % % % % % % % 
% % % % % % % % t = (1:1:size(attack_upsample_fft,1))/upsample_fs;
% % % % % % % % subplot(212),plot(t,attack_upsample_sig);
% % % % % % % % xlabel("t/s");
% % % % % % % % title("攻击信号时域图")
% % % % % % % % 
% % % % % % % % % DC
% % % % % % % % attack_premod_sig = attack_upsample_sig + 1;
% % % % % % % % 
% % % % % % % % % modulation
% % % % % % % % fc = 35000;
% % % % % % % % fs = 96000;
% % % % % % % % attack_mod_sig=modulate(attack_premod_sig,fc,fs,'am') ;
% % % % % % % % 
% % % % % % % % N = size(attack_mod_sig,1);
% % % % % % % % attack_mod_fft = abs(fft(attack_mod_sig));
% % % % % % % % 
% % % % % % % % f = upsample_fs/N:upsample_fs/N:upsample_fs;
% % % % % % % % figure;subplot(211),plot(f/1000,attack_mod_fft/N*2); ylim([0 0.01]);xlim([0 50]);
% % % % % % % % xlabel("f/kHz");
% % % % % % % % title("攻击信号（Fc = 35000）调制频谱");
% % % % % % % % t = (1:1:N)/upsample_fs;
% % % % % % % % subplot(212);plot(t,attack_mod_sig);
% % % % % % % % xlabel("t/s");
% % % % % % % % title("攻击信号（Fc = 35000）时域图")
% % % % % % % % saveas(gcf,'attack_mod.pdf');
% % % % % % % % %% generate defense signal(Fs = 44100)
% % % % % % % % 
% % % % % % % % f1 = 20000;%信号频率Hz
% % % % % % % % f2 = 40000;%信号频率Hz
% % % % % % % % 
% % % % % % % % length_attack = size(attack_mod_sig,1);
% % % % % % % % N = length_attack;%采样点数
% % % % % % % % t=(0:N-1)/upsample_fs;%采样时间s
% % % % % % % % defense_sig = ((sin(2*pi*f1*t)-sin(2*pi*f2*t))')/100  ;%防御信号采样值


% % % % % % % % %% human
% % % % % % % % [sampledata2,FS] = audioread('Alexa.mp3');
% % % % % % % % human_raw_sig = resample(sampledata2,upsample_fs,FS);
% % % % % % % % human_sig = repmat(human_raw_sig*100,80,1);
% % % % % % % % human_sig = human_sig/max(human_sig);
% % % % % % % % human_sig = human_sig(1:N);
% % % % % % % % N = size(human_sig,1);
% % % % % % % % human_sig_fft = abs(fft(human_sig))/N*2;
% % % % % % % % f = upsample_fs/N:upsample_fs/N:upsample_fs;
% % % % % % % % figure;subplot(211),plot(f/1000,human_sig_fft);
% % % % % % % % xlabel("f/kHz");
% % % % % % % % title("human fft");
% % % % % % % % 
% % % % % % % % t = (1:1:N)/upsample_fs;
% % % % % % % % subplot(212),plot(t,human_sig);
% % % % % % % % xlabel("t/s");
% % % % % % % % title("human sig ")
% % % % % % % % saveas(gcf,'human_sig.pdf');


% % % % % % % % %% input signal mixed
% % % % % % % % super_fs = 96000*3;
% % % % % % % % input_sig =attack_mod_sig + defense_sig;%加人声
% % % % % % % % input_sig = resample(input_sig,super_fs,upsample_fs);
% % % % % % % % input_sig =input_sig/ max(input_sig);
% % % % % % % % N = size(input_sig,1);
% % % % % % % % input_fft = abs(fft(input_sig))/N*2;
% % % % % % % % 
% % % % % % % % f = super_fs/N:super_fs/N:super_fs;
% % % % % % % % figure;subplot(211),plot(f/1000,input_fft);ylim([0 0.01]);xlim([0 50]);
% % % % % % % % xlabel("f/kHz");
% % % % % % % % title("混合信号")
% % % % % % % % 
% % % % % % % % t = (1:1:N)/upsample_fs;
% % % % % % % % subplot(212),plot(t,input_sig);
% % % % % % % % xlabel("t/s");
% % % % % % % % title("混合信号时域图")
% % % % % % % % saveas(gcf,'mixed.pdf');
% % % % % % % % 
% % % % % % % % %% nolinear 
% % % % % % % % nonlinear_sig = input_sig.*input_sig + input_sig ;
% % % % % % % % % nonlinear_sig = nonlinear_sig/max(nonlinear_sig);
% % % % % % % % %根据麦克风的采样频率，这里使用48K
% % % % % % % % mic_fs = 44100;
% % % % % % % % %这里先非线性，然后采样。(这里相当于麦克风处理的硬件部分)
% % % % % % % % % nonlinear_sig = resample(nonlinear_sig,mic_fs,super_fs);
% % % % % % % % % 
% % % % % % % % % %对于麦克风的采样结果需要进行下一步处理
% % % % % % % % % nonlinear_sig = resample(nonlinear_sig,upsample_fs,mic_fs);
% % % % % % % % nonlinear_sig = resample(nonlinear_sig,upsample_fs,super_fs);
% % % % % % % % N = size(nonlinear_sig,1);
% % % % % % % % 
% % % % % % % % f = upsample_fs/N:upsample_fs/N:upsample_fs;
% % % % % % % % nonlinear_fft = abs(fft(nonlinear_sig))/(N/2);
% % % % % % % % figure;subplot(211);plot(f/1000,nonlinear_fft);ylim([0 0.001]);xlim([0 20]);
% % % % % % % % xlabel("f/kHz");
% % % % % % % % title("非线性混合信号频谱")
% % % % % % % % 
% % % % % % % % t = (1:1:N)/upsample_fs;
% % % % % % % % subplot(212),plot(t,nonlinear_sig);
% % % % % % % % xlabel("t/s");
% % % % % % % % title("非线性混合信号时域图")
% % % % % % % % saveas(gcf,'nonlinear.pdf');


[attack_upsample_sig,upsample_fs] = audioread('output.wav');
attack_upsample_fft = abs(fft(attack_upsample_sig));
N = size(attack_upsample_fft,1);
f = upsample_fs/size(attack_upsample_fft,1):upsample_fs/size(attack_upsample_fft,1):upsample_fs;
figure;subplot(211),plot(f/1000,attack_upsample_fft/size(attack_upsample_fft,1)*2);ylim([0,0.001]);xlim([0,24]);
xlabel("f/kHz");
title("攻击信号基带频谱")

t = (1:1:size(attack_upsample_fft,1))/upsample_fs;
subplot(212),plot(t,attack_upsample_sig);
xlabel("t/s");
title("攻击信号时域图")
% 以上的代码块是可视化攻击信号

%% lowpass filter: 进入麦克风之后信号的截止 

%采样频率upsample_fs:目的是为了方便观察混叠之后的频谱，通过低通滤波之后可以重新恢复96000的采样频率
% 模拟截止频率30K， 30/48
% 模拟通带频率25K， 23/48 
N = size(nonlinear_sig,1);
d = fdesign.lowpass('Fp,Fst,Ap,Ast',19/48,20/48,1,60);  % ？
Hd=design(d,'butter');
before_anc_sig=filter(Hd,nonlinear_sig);
before_anc_sig = before_anc_sig/max(before_anc_sig);
before_anc_fft = abs(fft(before_anc_sig))/N*2;

figure;subplot(211),plot(f/1000,before_anc_fft);ylim([0 0.001]),xlim([0 50])
xlabel("f/kHz");
title("低通截止之后的信号");

t = (1:1:N)/upsample_fs;
subplot(212),plot(t,before_anc_sig);
xlabel("t/s");
title("低通截止之后的信号时域图")

saveas(gcf,'before_anc.pdf');
a = resample(before_anc_sig,mic_fs,upsample_fs);

audiowrite('zzh.m4a',a,mic_fs);


%% 提取基带信号+攻击信号的混合信号
% 采样频率96000，
% 截止频率: (5+8)/48 
% 通带频率:(5+4)/48 
d = fdesign.lowpass('Fp,Fst,Ap,Ast',9/48,13/48,1,60);
% d = fdesign.lowpass('Fp,Fst,Ap,Ast',4/48,7.5/48,1,60);
Hd=design(d,'butter');
mix_base_sig=filter(Hd,before_anc_sig);
% 
% Wp = 9/48;
% Ws = 13/48;
% [n,Wn] = buttord(Wp,Ws,1,60)
% [B,A] = butter(n,Wn);
% mix_base_sig=filter(B,A,nonlinear_sig);

mix_base_sig = resample(mix_base_sig,mic_fs,upsample_fs);
mix_base_sig = mix_base_sig/max(mix_base_sig);
mix_base_sig = mix_base_sig(100:end);
N = size(mix_base_sig,1);
mix_base_fft = abs(fft(mix_base_sig))/N*2;

f = mic_fs/N:mic_fs/N:mic_fs;
figure;subplot(211),plot(f/1000,mix_base_fft);ylim([0 0.01]),xlim([0 15])
xlabel("f/kHz");
title("before anc sig 的低通分量")

t = (1:1:N)/mic_fs;
subplot(212),plot(t,mix_base_sig);
xlabel("t/s");
title("before anc sig 的低通分量时域图")

saveas(gcf,'mix_base_fft.pdf');
%输入声卡 以48k采样
%% 提取高频一次攻击信号 

% 采样频率96000，中心频率15K Hz, 单边贷款8Khz  截止频率，15-8 = 7KHz
% 截止频率: (15-8)/48 
% 通带频率:(15-4)/48 

d = fdesign.highpass('Fst,Fp,Ast,Ap',7/48,11/48,60,1);
% d = fdesign.highpass('Fst,Fp,Ast,Ap',4/48,7.5/48,60,1);
Hd=design(d,'butter');
attack_base_sig=filter(Hd,before_anc_sig);

% Wp = 11/48;
% Ws = 7/48;
% [n,Wn] = buttord(Wp,Ws,1,60)
% [B,A] = butter(n,Wn);
% attack_base_sig=filter(B,A,nonlinear_sig);

% 截止频率: 22/48 
% 通带频率:(15+4)/48 
d = fdesign.lowpass('Fp,Fst,Ap,Ast',19/48,20/48,1,60);
% d = fdesign.lowpass('Fp,Fst,Ap,Ast',12.5/48,16/48,1,60);

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

%输入声卡以48K采样
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

%% 单个time slot 进行信号的处理
% 采样率 96000， 单个slot 划分为 一个点一个点的处理

% %初始化系数 
% fir_co = zeros(order+1,1);
% 梯度下降利用能量最小的原则
% 输出信号为sig - sighp*co 能量最小。
order  =50;
error_anc = zeros( size(attack_base_sig,1),1);
after_anc = zeros( size(attack_base_sig,1),1);
% 参考内容为前80个采样时刻信息

% after_anc = ifft(mix_base_fft(1:size(attack_base_sig,1)) - attack_base_fft(1:size(attack_base_sig,1)));

FrameSize = 256;
Length = size(attack_sec_sig,1);
NIter = Length/FrameSize;
% % % % % % lmsfilt2 = dsp.LMSFilter('Length',100,'Method','Normalized LMS', ...
% % % % % %     'StepSize',0.05);
mix = zeros( size(attack_base_sig,1),1);
wout = zeros(100,ceil(NIter));
% % % % % % for k = 1:NIter-1
% % % % % %     indexuint = 1:FrameSize;
% % % % % %     index = repmat(indexuint,FrameSize,1) + (indexuint-1)';
% % % % % %     index = index + (k-1)*FrameSize;
% % % % % %     dn = attack_sec_sig(index); 
% % % % % %     xn = mix_base_sig(index(:,1));
% % % % % %     en = sum((dn.^2-xn.^2).^2);
% % % % % %     [e,deltat] = min(en);
% % % % % %     an = dn(:,deltat)*(0.1:0.1:10);
% % % % % %     en = sum((an.^2-xn.^2).^2);
% % % % % %     [e,deltat] = min(en);
% % % % % %     error_anc((k-1)*FrameSize+1:k*FrameSize) = xn-an(:,deltat);
% % % % % %     
% % % % % % end

for k = 1:NIter-1
    x = attack_sec_sig((k-1)*FrameSize+1:k*FrameSize)*5;
    d = mix_base_sig((k-1)*FrameSize+1:k*FrameSize);
%     + human_sig((k-1)*FrameSize+1:k*FrameSize) ;
    [y,e,w] = lmsfilt2(x,d);
%     [y,e,w] = lmsfilt2(y,e);
    error_anc((k-1)*FrameSize+1:k*FrameSize) = e;
    mix((k-1)*FrameSize+1:k*FrameSize) = d;
    wout(:,k)  = w;
end
d = fdesign.lowpass('Fp,Fst,Ap,Ast',4/48,8/48,1,60);
Hd=design(d,'butter');
error_anc=filter(Hd,error_anc);
N = size(error_anc,1);
error_anc_fft = abs(fft(error_anc))/N*2;
f = mic_fs/N:mic_fs/N:mic_fs;
figure;subplot(211),plot(f/1000,error_anc_fft);ylim([0 0.001]),xlim([0 25])
xlabel("f/kHz");
title("error anc fft");

t = (1:1:N)/mic_fs;
subplot(212),plot(t,error_anc);
xlabel("t/s");
title("error anc sig ")
saveas(gcf,'error anc sig.pdf');
audiowrite('1th_anc.m4a',error_anc,48000);
audiowrite('mix.m4a',mix_base_sig,48000);

%% 去除一次项信号

% % % % % N = size(attack_base_sig,1);
% % % % % t = (1:1:N)/mic_fs;
% % % % % 
% % % % % 
% % % % % demod_sig = sin(2*pi*t*10000)';
% % % % % attack_base_sig =  attack_base_sig .* demod_sig;
% % % % % d = fdesign.lowpass('Fp,Fst,Ap,Ast',14/48,20/48,1,60);
% % % % % Hd=design(d,'butter');
% % % % % attack_base_sig=filter(Hd,attack_base_sig);
% % % % % attack_base_sig = attack_base_sig/max(attack_base_sig);
% % % % % attack_base_fft = abs(fft(attack_base_sig))/N*2;
% % % % % f = mic_fs/N:mic_fs/N:mic_fs;
% % % % % 
% % % % % figure;subplot(211),plot(f/1000,attack_base_fft);ylim([0 0.01]),xlim([0 25])
% % % % % xlabel("f/kHz");
% % % % % title("attack base fft");
% % % % % 
% % % % % subplot(212),plot(t,attack_base_sig);
% % % % % xlabel("t/s");
% % % % % title("attack base sig ")
% % % % % 
% % % % % FrameSize = 120;
% % % % % Length = size(attack_sec_sig,1);
% % % % % NIter = Length/FrameSize;
% % % % % lmsfilt2 = dsp.LMSFilter('Length',100,'Method','Normalized LMS', ...
% % % % %     'StepSize',0.05);
% % % % % 
% % % % % % wout = zeros(100,ceil(NIter));
% % % % % for k = 1:NIter
% % % % %     x = attack_sec_sig((k-1)*FrameSize+1:k*FrameSize)*5;
% % % % %     d = error_anc((k-1)*FrameSize+1:k*FrameSize);
% % % % %     [y,e,w2] = lmsfilt2(x,d);
% % % % %     after_anc((k-1)*FrameSize+1:k*FrameSize) = e;
% % % % % end
% % % % % 
% % % % % d = fdesign.lowpass('Fp,Fst,Ap,Ast',4/48,8/48,1,60);
% % % % % Hd=design(d,'butter');
% % % % % after_anc=filter(Hd,after_anc);
% % % % % audiowrite('2th_anc.m4a',after_anc,48000);
% % % % % 
% % % % % N = size(after_anc,1);
% % % % % after_anc_fft = abs(fft(after_anc))/N*2;
% % % % % f = mic_fs/N:mic_fs/N:mic_fs;
% % % % % figure;subplot(211),plot(f/1000,after_anc_fft);
% % % % % xlabel("f/kHz");
% % % % % title("after anc fft");
% % % % % 
% % % % % t = (1:1:N)/mic_fs;
% % % % % subplot(212),plot(t,after_anc);
% % % % % xlabel("t/s");
% % % % % title("after anc sig ")
