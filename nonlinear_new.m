function [nonlinear_sig] = nonlinear_new(input_sig)
%% nolinear 
nonlinear_sig = input_sig.*input_sig + input_sig ;
% nonlinear_sig = nonlinear_sig/max(nonlinear_sig);
%������˷�Ĳ���Ƶ�ʣ�����ʹ��48K
mic_fs = 44100;
%�����ȷ����ԣ�Ȼ�������(�����൱����˷紦���Ӳ������)
super_fs=96000*3;
upsample_fs = 96000;
%nonlinear_sig = resample(nonlinear_sig,mic_fs,super_fs);
 
% %������˷�Ĳ��������Ҫ������һ������
% nonlinear_sig = resample(nonlinear_sig,upsample_fs,mic_fs);
nonlinear_sig = resample(nonlinear_sig,upsample_fs,super_fs);
N = size(nonlinear_sig,1);
 
f = upsample_fs/N:upsample_fs/N:upsample_fs;
nonlinear_fft = abs(fft(nonlinear_sig))/(N/2);
figure;subplot(211);plot(f/1000,nonlinear_fft);ylim([0 0.001]);xlim([0 20]);
xlabel("f/kHz");
title("�����Ի���ź�Ƶ��")

t = (1:1:N)/upsample_fs;
subplot(212),plot(t,nonlinear_sig);
xlabel("t/s");
title("�����Ի���ź�ʱ��ͼ")
saveas(gcf,'nonlinear.pdf');
end

