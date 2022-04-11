clc;
clear all;
close all;
I = imread('c-2.png');
figure, imshow(I);
% Y = I;
YCbCr = rgb2ycbcr(I);%YCBCR = rgb2ycbcr( RGB ) converts the values of an RGB image to luminance(Y) and chrominance(Cb and Cr) values of a YCbCr image.
%figure, imshow(YCbCr);
Y = YCbCr(:,:, 1);
figure, imshow(Y);
[h, w] = size(Y);
r = h/8;
c = w/8;
s = 1;
q50 = [16 11 10 16 24 40 51 61;
       12 12 14 19 26 58 60 55;
       14 13 16 24 40 57 69 56;
       14 17 22 29 51 87 80 62;
       18 22 37 56 68 109 103 77;
       24 35 55 64 81 104 113 92;
       49 64 78 87 103 121 120 101;
       72 92 95 98 112 100 103 99];
%    COMPRESSION
for i=1:r
    e = 1;
    for j=1:c
        block = Y(s:s+7,e:e+7);
        cent = double(block) - 128;
        for m=1:8
            for n=1:8
                if m == 1
                    u = 1/sqrt(8);
                else
                    u = sqrt(2/8);
                end
                if n == 1
                    v = 1/sqrt(8);
                else
                    v = sqrt(2/8);
                end
                comp = 0;
                for x=1:8
                    for y=1:8
                        comp = comp + cent(x, y)*(cos((((2*(x-1))+1)*(m-1)*pi)/16))*(cos((((2*(y-1))+1)*(n-1)*pi)/16));
                    end
                end
                  F(m, n) = v*u*comp;
              end
          end
          for x=1:8
              for y=1:8
                  cq(x, y) = round(F(x, y)/q50(x, y));
              end
          end
          Q(s:s+7,e:e+7) = cq;
          e = e + 8;
      end
      s = s + 8;
end
imwrite(Y, 'D:\References materials\Fall semester 2021-22\DSP\Project\audi0\output_1.png');
[host, f] = audioread ('D:\References materials\Fall semester 2021-22\DSP\Project\audio\CantinaBand3.wav');
dt=1/f;
t = 0:dt:(length(host)*dt)-dt;
%subplot(1,2,1)
figure,plot(t,host)
title('Original Audio')
host = uint8(255*(host + 0.5));
wm = imread('D:\References materials\Fall semester 2021-22\DSP\Project\audio\output_1.png');
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
host_new = (double(host_new)/255 - 0.5);
%subplot(1,2,2)
figure,plot(t,host_new)
title('Watermarked Audio')
audiowrite('host_new.wav', host_new, f)
soundsc(host_new, f);
end
wm_sz = 20000;
px_sz = wm_sz/8;
im_sz = sqrt(px_sz);
host_new = audioread('D:\References materials\Fall semester 2021-22\DSP\Project\audio\host_new.wav');
host_new = uint8(255*(host_new + 0.5));
host_bin = dec2bin(host_new, 8);
wm_bin_str = host_bin(1:wm_sz, 8);
wm_bin = reshape(wm_bin_str, px_sz , 8);
wm_str = zeros(px_sz, 1, 'uint8');
for i = 1:(px_sz)
wm_str(i, :) = bin2dec(wm_bin(i, :));
end
wm = reshape(wm_str, im_sz , im_sz);
[x fs]=audioread('D:\References materials\Fall semester 2021-22\DSP\Project\audio\host_new.wav');
orig=x;
no=orig;
N=length(x); % length of the input signal
F = zeros (5, N); % initialization of standard transition matrix
I = eye (5); % transition matrix
H = zeros (5, N);
sig = zeros (5, 5*N); % priori or posteri covariance matrix. K = zeros (5, N); % kalman gain. XX = zeros (5, N); %kalman coefficient for 
yy.y = zeros (1, N); % requiring signal (desired signal)
XX = zeros (5, N); % kalman coefficient for yy
vv = zeros (1, N); % predicted state error vector
yy = zeros (1, N); % Estimated error sequence
Q = 0.0001*eye (5, 5); % Process Noise Covariance. R = 0.1; % Measurement Noise Covariance
R = 0.1;
y=x (1: N); % y is the output signal produced. sig (1:5, 1:5) = 0.1*I;
for k=6: N
F(1:5,k)=-[y(k-1);y(k-2);y(k-3);y(k-4);y(k-5)];
H(1:5,k)=-[yy(k-1);yy(k-2);yy(k-3);yy(k-4);yy(k-5)];
K(1:5,k)=sig(1:5,5*k-29:5*k-25)*F(1:5,k)*inv(F(1:5,k)'*sig(1:5,5*k-29:5*k-25)*F(1:5,k)+R);
%Kalman Gain
sig(1:5,5*k-24:5*k-20)=sig(1:5,5*k-29:5*k-25)-sig(1:5,5*k-29:5*k- 25)*F(1:5,k)*inv(F(1:5,k)'*sig(1:5,5*k-29:5*k-25)*F(1:5,k) +R)*(F(1:5,k)'*sig(1:5,5*k-29:5*k- 25))+Q; % error covariance matrix
XX(1:5,k) =(I - K(1:5,k)*F(1:5,k)')*XX(1:5,k-1) + (K(1:5,k)*y(k)); % posteriori value of estimateX(k)
orig(k) =y (k)-(F (1:3, k)'*XX (1:3, k)); % estimated speech signal
yy(k) = (H (1:5, k)'*XX (1:5, k)) + orig (k); % no. of coefficients per iteration
end;
tt = 1:1: length(x);
figure (6);
subplot (211);
plot(x);
title ('ORIGINAL SIGNAL');
subplot (212);
plot (orig);
title ('Enhanced Speech Signal');
figure (7);
plot (tt, x, tt, orig);
title ('Combined plot');
legend ('original','estimated');
audiowrite('D:\References materials\Fall semester 2021-22\DSP\Project\audio\host_new.wav', orig, fs)
soundsc(orig, fs);