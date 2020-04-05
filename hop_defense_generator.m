function [defense_sig] = hop_defense_generator(attack_mod_sig)
%% generate defense signal(Fs = 44100)
f1 = 10000;
%f2 = 25000;
%f3 = 30000;
%f4 = 35000;
f5 = 40000;
upsample_fs = 96000;
length_attack = size(attack_mod_sig,1);
N = length_attack;%采样点数
t=(0:N-1)/upsample_fs;%采样时间s

defense_sig = ((sin(2*pi*f1*t)-sin(2*pi*f5*t))')/100;
end