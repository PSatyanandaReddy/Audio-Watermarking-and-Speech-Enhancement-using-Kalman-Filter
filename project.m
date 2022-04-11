clc
clear
close all
wm_sz = 20000;
px_sz = wm_sz/8;
im_sz = sqrt(px_sz);
host_new = audioread('C:\Users\jeeva\OneDrive\Desktop\FALL 21\sample.wav');
host_new = uint8(255*(host_new + 0.5));
host_bin = dec2bin(host_new, 8);
wm_bin_str = host_bin(1:wm_sz, 8);
wm_bin = reshape(wm_bin_str, px_sz , 8);
wm_str = zeros(px_sz, 1, 'uint8');
for i = 1:(px_sz)
wm_str(i, :) = bin2dec(wm_bin(i, :));
end
wm = reshape(wm_str, im_sz , im_sz);
figure (1);
%wm = imread('C:\Users\jeeva\OneDrive\Desktop\FALL 21\download.png');
imshow(wm)
[x fs]=audioread('C:\Users\jeeva\OneDrive\Desktop\FALL 21\sample.wav');
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
figure (2);
subplot (311);
plot(x);
title ('ORIGINAL SIGNAL');
subplot (313);
plot (orig);
title ('Enhanced Speech Signal');
figure (3);
plot (tt, x, tt, orig);
title ('Combined plot');
legend ('original','estimated');
audiowrite('C:\Users\jeeva\OneDrive\Desktop\FALL 21\sample.wav', orig, fs)
soundsc(orig, fs);