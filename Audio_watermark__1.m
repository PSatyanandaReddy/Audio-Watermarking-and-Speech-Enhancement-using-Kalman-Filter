clc
clear
close all
[host, f] = audioread ('D:\References materials\Fall semester 2021-22\DSP\Project\audio\1m_wav.wav');
dt=1/f;
t = 0:dt:(length(host)*dt)-dt;
t1 = 0:dt:(2*(((length(host)+0.5)*dt)-dt));
subplot(1,2,1)
plot(t,host)
title('Original Audio')
host = uint16(65535*(host + 0.5));
wm = imread('D:\References materials\Fall semester 2021-22\DSP\Project\audio\chair.png');
[r, c] = size(wm);
wm_l = length(wm(:))*8;
if length(host) < (length(wm(:))*8)
disp('your image pixel is not enough')
else
host_bin = dec2bin(host, 8);
wm_bin = dec2bin(wm(:), 8);
wm_str = zeros(wm_l, 1);
for j = 1:8
for i = 1:length(wm(:))
ind = (j-1)*length(wm(:)) + i;
wm_str(ind, 1) = str2double(wm_bin(i, j));
end
end
for i = 1:wm_l
host_bin(i, 8) = dec2bin(wm_str(i));
end
host_new = bin2dec(host_bin);
host_new = (double(host_new)/65535 - 0.5);
subplot(1,2,2)
plot(t1,host_new)
title('Watermarked Audio')
audiowrite('host_new.wav', host_new, f)
soundsc(host_new, f);
end