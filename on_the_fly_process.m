clear all;clc;close all;
% 产生攻击信号ni
attack_mod_sig=hop_attack_generator();
% 由攻击信号的采样点数，得到防御信号（这一步仅限于软件仿真）
[attack_split,freq_record,split_length]=convert(attack_mod_sig,10);
after_anc=[];
for m=1:10
close all
attack_mod_sig=repmat(attack_split(:,m),1,10);
defense_sig=hop_defense(attack_mod_sig,30000);
% 应该将即将输入的
input_sig=input_mixed(attack_mod_sig,defense_sig);
%输入麦克风的非线性效应
nonlinear_sig=nonlinear(input_sig);
%进入之后的低通滤波器
before_anc_sig = lowpass(nonlinear_sig);
%提取基带信号
mix_base_sig = extraction_base(before_anc_sig);
%提取一次攻击信号
attack_base_sig = extraction_attack_base(before_anc_sig);
%提取二次攻击信号
attack_sec_sig = extraction_attack_second(attack_base_sig);
%对time slot的提取
error_anc = timeslot(attack_base_sig,mix_base_sig,attack_sec_sig);
%防御
after_anc = [after_anc,defense(attack_base_sig,attack_sec_sig,error_anc)];
end
audiowrite('2th_anc.m4a',after_anc,48000);
