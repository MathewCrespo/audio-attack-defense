function [defense_sig] = hop_defense(attack_mod_sig,freq)
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
f1=freq-15000;
f2=40000;
upsample_fs = 96000;
length_attack = size(attack_mod_sig,1);
N = length_attack;%��������
t=(0:N-1)/upsample_fs;%����ʱ��s
defense_sig = ((sin(2*pi*f1*t)-sin(2*pi*f2*t))')/100;
end

