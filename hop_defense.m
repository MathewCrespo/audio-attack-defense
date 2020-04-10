function [defense_sig] = hop_defense(attack_mod_sig,freq)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
f1=freq-15000;
f2=40000;
upsample_fs = 96000;
length_attack = size(attack_mod_sig,1);
N = length_attack;%采样点数
t=(0:N-1)/upsample_fs;%采样时间s
defense_sig = ((sin(2*pi*f1*t)-sin(2*pi*f2*t))')/100;
end

