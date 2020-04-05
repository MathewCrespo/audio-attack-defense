function [attack_mod_sig] = attack_generator()
%% gnerate attack signal (FS = 96000,Fc = 96000)
upsample_fs = 96000;
[sampledata1,FS] = audioread('Alex.m4a');
% % % % �������ź�
% % % % ѡ���Ƿ�Թ����źŽ����޴�����������Ƶ���Ƶ����ȵ���4K
d = fdesign.lowpass('Fp,Fst,Ap,Ast',4000/FS*2,8000/FS*2,1,60);
Hd=design(d,'butter');
sampledata1=filter(Hd,sampledata1);

attack_raw_sig = repmat(sampledata1*100,10,1);% ����������100�����ڣ�FFT��׼ȷ
attack_upsample_sig = resample(attack_raw_sig(:,1),upsample_fs,FS);
attack_upsample_sig = attack_upsample_sig/max(attack_upsample_sig); %���źŹ�һ������
attack_upsample_fft = abs(fft(attack_upsample_sig));

% figure
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
fc = 35000;
fs = 96000;
attack_mod_sig=modulate(attack_premod_sig,fc,fs,'am') ;

N = size(attack_mod_sig,1);
attack_mod_fft = abs(fft(attack_mod_sig));

f = upsample_fs/N:upsample_fs/N:upsample_fs;
figure;subplot(211),plot(f/1000,attack_mod_fft/N*2); ylim([0 0.01]);xlim([0 50]);
xlabel("f/kHz");
title("�����źţ�Fc = 35000������Ƶ��");
t = (1:1:N)/upsample_fs;
subplot(212);plot(t,attack_mod_sig);
xlabel("t/s");
title("�����źţ�Fc = 35000��ʱ��ͼ")
saveas(gcf,'attack_mod.pdf');
audiowrite('attack.m4a',attack_mod_sig,48000);
end

