function [attack_mod_reshaped_sig] = hop_attack_generator3()
clear all;clc;
upsample_fs = 96000;
[sampledata1,FS] = audioread('camera4.m4a');
% % % % �������ź�
% % % % ѡ���Ƿ�Թ����źŽ����޴�����������Ƶ���Ƶ����ȵ���4K
d = fdesign.lowpass('Fp,Fst,Ap,Ast',4000/FS*2,8000/FS*2,1,60);
Hd=design(d,'butter');
sampledata1=filter(Hd,sampledata1);

attack_raw_sig = repmat(sampledata1*100,10,1);% ����������10�����ڣ�FFT��׼ȷ
attack_upsample_sig = resample(attack_raw_sig(:,1),upsample_fs,FS);
attack_upsample_sig = attack_upsample_sig/max(attack_upsample_sig); %���źŹ�һ������
attack_upsample_fft = abs(fft(attack_upsample_sig));

% figure  ������һ���ִ��룬���ԳƵ�fftͼ��ȥ�������һ�룬��������Ƶ����
%length = size(attack_upsample_sig,1);
%n=0:length-1;
%f=n*FS/length;
%figure;subplot(211),plot(f(1:length/2)/1000,attack_upsample_fft(1:length/2)/length*2);
%xlabel("f/kHz");
%title("�����źŻ���Ƶ��")

%t = (1:1:length)/upsample_fs;
%subplot(212),plot(t,attack_upsample_sig);
%xlabel("t/s");
%title("�����ź�ʱ��ͼ")

% figure
length=size(attack_upsample_sig,1);
f = upsample_fs/size(attack_upsample_fft,1):upsample_fs/size(attack_upsample_fft,1):upsample_fs;
figure;subplot(211),plot(f/1000,attack_upsample_fft/size(attack_upsample_fft,1)*2);
xlabel("f/kHz");
title("�����źŻ���Ƶ��")

t = (1:1:size(attack_upsample_fft,1))/upsample_fs;
subplot(212),plot(t,attack_upsample_sig);
xlabel("t/s");
title("�����ź�ʱ��ͼ")

% DC
attack_premod_sig = attack_upsample_sig + 1;

% modulation
frenumber=3;                       %��ƵƵ�����
hopbw=5000;                       %Ƶ����
hopnumber=20;                      %��Ƶ����
fs = 96000;                       %��������
hopfrequency=[25000:hopbw:(25000+hopbw*(frenumber-1))];         %��ƵƵ��
hoplength=length/hopnumber;
if (hoplength~=floor(hoplength))      %�������ݣ����������������һ�0
    hoplength=floor(hoplength);
    attack_preshaped_sig=zeros(hoplength*(hopnumber+1),1);
    attack_preshaped_sig(1:length)=attack_premod_sig;
    attack_premod_sig=attack_preshaped_sig;
    length=hoplength*(hopnumber+1);
    hopnumber=hopnumber+1;
end
attack_reshape_sig=reshape(attack_premod_sig,hoplength,hopnumber);
attack_reshape_sig=attack_reshape_sig';
for i=1:hopnumber
    attack_mod_sig(i,:)=modulate(attack_reshape_sig(i,:),hopfrequency(mod(i-1,frenumber)+1),fs,'am');
end    
attack_mod_sig=attack_mod_sig';
attack_mod_reshaped_sig=reshape(attack_mod_sig,length,1);
attack_mod_fft = abs(fft(attack_mod_reshaped_sig));

f = upsample_fs/length:upsample_fs/length:upsample_fs;
figure;subplot(211),plot(f/1000,attack_mod_fft/length*2); ylim([0 0.01]);xlim([0 40]);
xlabel("f/kHz");
title("�����źŵ���Ƶ��");
t = (1:1:length)/upsample_fs;
subplot(212);plot(t,attack_mod_reshaped_sig);
xlabel("t/s");
title("�����ź�ʱ��ͼ")
saveas(gcf,'attack_mod.pdf');
audiowrite('attack.m4a',attack_mod_reshaped_sig,48000);
end