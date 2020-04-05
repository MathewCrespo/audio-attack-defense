clc;clear all;close all;

[sampledata,FS] = audioread('Alex.m4a');
% FS= sample frequence
sampledata = resample(sampledata,96000,FS);
%要么插值，要么再采样（根据实际频率来）
%重新采样的过程，采样到96000Hz  （降采样的过程）
%（保证声音的频率？）
figure;plot(sampledata);   %figure1



sig_m2 = sampledata.*sampledata; % 要自己和自己相乘 才能混成高频的攻击信号
% 自己和自己乘 仿真二次项
% figure;plot(sampledata);

N1 = 80;                %滤波器节点个数
wc = 0.0001;              %归一化截止频率
lowpass1 = fir1(N1,wc,'low'); % 基于加窗函数的FIR滤波器设计   %一个低通滤波器

testout1 = conv2(sig_m2,lowpass1);   % 二维卷积 通过低通滤波器
length_test = max(size(sig_m2));
signal1 = testout1((1+N1/2):(length_test+N1/2));   % 信号卷积后，长度序列会变。取出需要的那一部分
for i=1:5
    figure;plot(abs(fft(signal1((i-1)*9600+1:i*9600))));
end

anti_sig = 0.5*sampledata.*sampledata; % 二次非线性的
anti_sig2 = 0.125*sampledata.*sampledata.*sampledata; % 三次非线性
anti_sig3 = 0.5*signal1;  %取出来的原序列

anti_sig3 = [anti_sig3; anti_sig3];
anti_sig3 = anti_sig3';

sig_mod1 = sampledata + 1;
sig_mod2 = sampledata + 1 - anti_sig ;
sig_mod3 = sampledata + 1 - anti_sig -anti_sig2 ;
sig_mod4 = sampledata + 1 - anti_sig3 ; 
sig_mod5 = sampledata + 1.5 - 4/3*anti_sig;  

fc = 25000; %载波频率
fs = 96000; %采样频率
% AM调制5种模式的信号
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