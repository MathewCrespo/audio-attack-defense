function [before_anc_sig] = lowpass(nonlinear_sig)
%% lowpass filter: ������˷�֮���źŵĽ�ֹ 

%����Ƶ��upsample_fs:Ŀ����Ϊ�˷���۲���֮���Ƶ�ף�ͨ����ͨ�˲�֮��������»ָ�96000�Ĳ���Ƶ��
% ģ���ֹƵ��30K�� 30/48
% ģ��ͨ��Ƶ��25K�� 23/48 
N = size(nonlinear_sig,1);
d = fdesign.lowpass('Fp,Fst,Ap,Ast',19/48,20/48,1,60);  % ��
Hd=design(d,'butter');
before_anc_sig=filter(Hd,nonlinear_sig);
before_anc_sig = before_anc_sig/max(before_anc_sig);
before_anc_fft = abs(fft(before_anc_sig))/N*2;
super_fs=96000*3;
f = super_fs/N:super_fs/N:super_fs;
figure;subplot(211),plot(f/1000,before_anc_fft);ylim([0 0.001]),xlim([0 50])
xlabel("f/kHz");
title("��ͨ��ֹ֮����ź�");
upsample_fs = 96000;mic_fs = 44100;
t = (1:1:N)/upsample_fs;
subplot(212),plot(t,before_anc_sig);
xlabel("t/s");
title("��ͨ��ֹ֮����ź�ʱ��ͼ")

saveas(gcf,'before_anc.pdf');
a = resample(before_anc_sig,mic_fs,upsample_fs);

%audiowrite('zzh.m4a',a,mic_fs);
end

