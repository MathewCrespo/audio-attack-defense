function [attack_sec_sig] = extraction_attack_second(attack_base_sig)
%% ��ȡ��Ƶ���ι����ź�

%����ݮ���ڲ� ��44100����

% ����Ƶ��96000
% ��ֹƵ��: (15-8)/48 
% ͨ��Ƶ��:(15-4)/48 

attack_sec_sig = attack_base_sig.*attack_base_sig;

% d = fdesign.lowpass('Fp,Fst,Ap,Ast',12/48,16/48,1,60);
d = fdesign.lowpass('Fp,Fst,Ap,Ast',12/48,16/48,1,60);
Hd=design(d,'butter');
attack_sec_sig=filter(Hd,attack_sec_sig);
attack_sec_sig = attack_sec_sig(100:end);
attack_sec_sig = attack_sec_sig/max(attack_sec_sig);
%���������趨Ϊ80,��ȥ���֮����ֵĸ�Ƶ����

% order = 80;
% Wp = 12/48;
% Ws = 16/48;
% [n,Wn] = buttord(Wp,Ws,1,60);
% b = fir1(order,Wn,'low');
% attack_sec_sig=conv(b,attack_sec_sig);
% disp(['LPF-n ������ȡ������ : ',num2str(n)]);  
mic_fs = 44100;
N = size(attack_sec_sig,1);
attack_sec_fft = abs(fft(attack_sec_sig))/N*2;

f = mic_fs/N:mic_fs/N:mic_fs;
figure;subplot(211),plot(f/1000,attack_sec_fft);ylim([0 0.01]),xlim([0 25])
xlabel("f/kHz");
title("before anc sig �ĸ�ͨ���� ������η���");

t = (1:1:N)/mic_fs;
subplot(212),plot(t,attack_sec_sig);
xlabel("t/s");
title("before anc sig �ĸ�ͨ������η���ʱ��ͼ")
saveas(gcf,'attack_sec_fft.pdf');
end

