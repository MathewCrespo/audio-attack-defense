function [mix_base_sig] = extraction_base(before_anc_sig)
%% ��ȡ�����źţ�������Ϣ��+�����źŵĻ���ź�
% ����Ƶ��96000��
% ��ֹƵ��: (5+8)/48 
% ͨ��Ƶ��:(5+4)/48 
d = fdesign.lowpass('Fp,Fst,Ap,Ast',9/48,13/48,1,60);
% d = fdesign.lowpass('Fp,Fst,Ap,Ast',4/48,7.5/48,1,60);
Hd=design(d,'butter');
mix_base_sig=filter(Hd,before_anc_sig);
mic_fs = 44100;
super_fs=96000*3;
upsample_fs = 96000;
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
title("before anc sig �ĵ�ͨ����")

t = (1:1:N)/mic_fs;
subplot(212),plot(t,mix_base_sig);
xlabel("t/s");
title("before anc sig �ĵ�ͨ����ʱ��ͼ")

saveas(gcf,'mix_base_fft.pdf');
end

