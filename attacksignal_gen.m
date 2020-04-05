clc;clear all;close all;

[sampledata,FS] = audioread('Alex.m4a');
% FS= sample frequence
sampledata = resample(sampledata,96000,FS);
%Ҫô��ֵ��Ҫô�ٲ���������ʵ��Ƶ������
%���²����Ĺ��̣�������96000Hz  ���������Ĺ��̣�
%����֤������Ƶ�ʣ���
figure;plot(sampledata);   %figure1



sig_m2 = sampledata.*sampledata; % Ҫ�Լ����Լ���� ���ܻ�ɸ�Ƶ�Ĺ����ź�
% �Լ����Լ��� ���������
% figure;plot(sampledata);

N1 = 80;                %�˲����ڵ����
wc = 0.0001;              %��һ����ֹƵ��
lowpass1 = fir1(N1,wc,'low'); % ���ڼӴ�������FIR�˲������   %һ����ͨ�˲���

testout1 = conv2(sig_m2,lowpass1);   % ��ά���� ͨ����ͨ�˲���
length_test = max(size(sig_m2));
signal1 = testout1((1+N1/2):(length_test+N1/2));   % �źž����󣬳������л�䡣ȡ����Ҫ����һ����
for i=1:5
    figure;plot(abs(fft(signal1((i-1)*9600+1:i*9600))));
end

anti_sig = 0.5*sampledata.*sampledata; % ���η����Ե�
anti_sig2 = 0.125*sampledata.*sampledata.*sampledata; % ���η�����
anti_sig3 = 0.5*signal1;  %ȡ������ԭ����

anti_sig3 = [anti_sig3; anti_sig3];
anti_sig3 = anti_sig3';

sig_mod1 = sampledata + 1;
sig_mod2 = sampledata + 1 - anti_sig ;
sig_mod3 = sampledata + 1 - anti_sig -anti_sig2 ;
sig_mod4 = sampledata + 1 - anti_sig3 ; 
sig_mod5 = sampledata + 1.5 - 4/3*anti_sig;  

fc = 25000; %�ز�Ƶ��
fs = 96000; %����Ƶ��
% AM����5��ģʽ���ź�
ultrasond1=modulate(sig_mod1,fc,fs,'am') ;
ultrasond2=modulate(sig_mod2,fc,fs,'am') ;
ultrasond3=modulate(sig_mod3,fc,fs,'am') ;
ultrasond4=modulate(sig_mod4,fc,fs,'am') ;
ultrasond5=modulate(sig_mod5,fc,fs,'am') ;
N = size(ultrasond1,1);
f = (1:N)*96000/N;
plot(f,abs(fft(ultrasond1))); 
% for i = 1:100
% 
%     i
% sound(ultrasond1,fs);
% pause()
% end