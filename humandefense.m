clear all;clc;close all;
% ����������֮��Ĺ���
% ���������ź�
attack_mod_sig=attack_generator();
% �ɹ����źŵĲ����������õ������źţ���һ��������������棩
defense_sig=defense_generator(attack_mod_sig);
% ��ȡ����  (�Ȳ�����)
N=size(attack_mod_sig,1);
human_sig=get_human(N);
% �������(��ֻ���˹�����������û�м���������
input_sig=input_mixed2(attack_mod_sig,defense_sig,human_sig);
%������˷�ķ�����ЧӦ
nonlinear_sig=nonlinear(input_sig);
%����֮��ĵ�ͨ�˲���
before_anc_sig = lowpass(nonlinear_sig);
%��ȡ�����ź�
mix_base_sig = extraction_base(before_anc_sig);
%��ȡһ�ι����ź�
attack_base_sig = extraction_attack_base(before_anc_sig);
%��ȡ���ι����ź�
attack_sec_sig = extraction_attack_second(attack_base_sig);
%��time slot����ȡ
error_anc = timeslot(attack_base_sig,mix_base_sig,attack_sec_sig);
% ȥ������
after_anc = defense(attack_base_sig,attack_sec_sig,error_anc);
