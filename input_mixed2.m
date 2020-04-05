function [input_sig] = input_mixed2(attack_mod_sig,defense_sig,human_sig)
%% input signal mixed
super_fs = 96000*3;
upsample_fs = 96000;
input_sig =attack_mod_sig + defense_sig+human_sig;% 先模拟了攻击和防御的过程，先不加人为的控制
input_sig = resample(input_sig,super_fs,upsample_fs);
input_sig =input_sig/ max(input_sig);
N = size(input_sig,1);
input_fft = abs(fft(input_sig))/N*2;

f = super_fs/N:super_fs/N:super_fs;
figure;subplot(211),plot(f/1000,input_fft);ylim([0 0.01]);xlim([0 50]);
xlabel("f/kHz");
title("混合信号")

t = (1:1:N)/upsample_fs;
subplot(212),plot(t,input_sig);
xlabel("t/s");
title("混合信号时域图")
saveas(gcf,'mixed.pdf');

end

