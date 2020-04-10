function [defense_sig] = defense_generator(attack_mod_sig)
%% generate defense signal(Fs = 44100)
f1 = 20000;
f2 = 40000;


upsample_fs = 96000;
length_attack = size(attack_mod_sig,1);
N = length_attack;%采样点数
t=(0:N-1)/upsample_fs;%采样时间s
%defense_sig1 = ((sin(2*pi*f1*t)-sin(2*pi*f3*t)+sin(2*pi*f5*t)-sin(2*pi*f7*t)+sin(2*pi*f9*t))')/100  ;%防御信号采样值
%defense_sig2=  ((sin(2*pi*f2*t)-sin(2*pi*f4*t)+sin(2*pi*f6*t)-sin(2*pi*f8*t))')/100;
%defense_sig = defense_sig1+defense_sig2;
%defense_sig = ((sin(2*pi*f1*t)-sin(2*pi*f2*t)+sin(2*pi*f3*t)-sin(2*pi*f4*t)+sin(2*pi*f5*t))')/100;
%defense_sig = defense_sig+((sin(2*pi*f11*t)-sin(2*pi*f21*t)+sin(2*pi*f31*t)-sin(2*pi*f41*t)+sin(2*pi*f51*t))')/100;
defense_sig = ((sin(2*pi*f1*t)-sin(2*pi*f2*t))')/100;
end

