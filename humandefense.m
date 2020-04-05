clear all;clc;close all;
% 加入了人声之后的攻防
% 产生攻击信号
attack_mod_sig=attack_generator();
% 由攻击信号的采样点数，得到防御信号（这一步仅限于软件仿真）
defense_sig=defense_generator(attack_mod_sig);
% 读取人声  (先不加入)
N=size(attack_mod_sig,1);
human_sig=get_human(N);
% 混合输入(先只做了攻防的演练，没有加入人声）
input_sig=input_mixed2(attack_mod_sig,defense_sig,human_sig);
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
% 去除攻击
after_anc = defense(attack_base_sig,attack_sec_sig,error_anc);
