clear all;clc;close all;
% ���������ź�ni
attack_mod_sig=hop_attack_generator();
% �ɹ����źŵĲ����������õ������źţ���һ��������������棩
[attack_split,freq_record,split_length]=convert(attack_mod_sig,10);
after_anc=[];
for m=1:10
close all
attack_mod_sig=repmat(attack_split(:,m),1,10);
defense_sig=hop_defense(attack_mod_sig,30000);
% Ӧ�ý����������
input_sig=input_mixed(attack_mod_sig,defense_sig);
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
%����
after_anc = [after_anc,defense(attack_base_sig,attack_sec_sig,error_anc)];
end
audiowrite('2th_anc.m4a',after_anc,48000);
