function [attack_split,freq_record,split_length] = convert(attack_mod_reshaped_sig,repeat_times)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
len=size(attack_mod_reshaped_sig,1);
split_length=len/repeat_times;
attack_split=zeros(repeat_times, split_length);

frenumber=3;                     
hopbw=2500;                     
hopfrequency=[30000:hopbw:(30000+hopbw*(frenumber-1))];
freq_record=zeros(1,repeat_times);
for n=1:repeat_times
    freq_record(n)=hopfrequency(mod(n-1,frenumber)+1);
end

for m=0:9
    attack_split(m+1,:)=attack_mod_reshaped_sig(1+m*split_length:(m+1)*split_length,1);
end
attack_split=attack_split';

end

