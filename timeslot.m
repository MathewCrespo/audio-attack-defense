function [error_anc] = timeslot(attack_base_sig,mix_base_sig,attack_sec_sig)
%% ����time slot �����źŵĴ���
% ������ 96000�� ����slot ����Ϊ һ����һ����Ĵ���

% %��ʼ��ϵ�� 
% fir_co = zeros(order+1,1);
% �ݶ��½�����������С��ԭ��
% ����ź�Ϊsig - sighp*co ������С��
mic_fs = 44100;
super_fs=96000*3;
upsample_fs = 96000;
order  =50;
error_anc = zeros( size(attack_base_sig,1),1);
after_anc = zeros( size(attack_base_sig,1),1);
% �ο�����Ϊǰ80������ʱ����Ϣ

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
lmsfilt2 = dsp.LMSFilter('Length',100,'Method','Normalized LMS', 'StepSize',0.05);
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

end

