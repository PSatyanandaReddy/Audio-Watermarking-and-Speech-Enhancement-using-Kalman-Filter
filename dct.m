clc
clear all
close all
disp('Image compression by using DCT and blockproc function');
tic;
im=imread('7221.jpg');
%Check if it is RGB or gray scale
% If it is RGB convert to grayscale
if(size(im,3)>1)
 % inim - input image
 inim=double(rgb2gray(im));
 disp('The given image is RGB. It is converted to grayscale');
 [r c]=size(inim);
 dim=strcat('image size',int2str(r),'X',int2str(c),'pixels');
 disp(dim);
end
inim1=uint8(inim);
%--------------------------
%Compression
%--------------------------
figure(1)
imshow(inim1);
title 'Original Image';
% Divide the image into 8X8 block and apply dct on each block
%donwshift the intensity levels by 256
blksize=8;
dctcoef=blockproc(inim,[blksize, blksize],@(block_struct)dct2(block_struct.data));
% Design a filter to remove the coefiicients in zig zag manner
filt28=[1 1 1 1 1 1 1 0 ;
 1 1 1 1 1 1 0 0 ;
 1 1 1 1 1 0 0 0 ;
 1 1 1 1 0 0 0 0 ;
 1 1 1 0 0 0 0 0 ;
 1 1 0 0 0 0 0 0 ;
 1 0 0 0 0 0 0 0 ;
 0 0 0 0 0 0 0 0];
 % cut the coefficients using the filter filt
 filt10=[1 1 1 1 0 0 0 0 ;
 1 1 1 0 0 0 0 0 ;
 1 1 0 0 0 0 0 0 ;
 1 0 0 0 0 0 0 0 ;
 0 0 0 0 0 0 0 0 ;
 0 0 0 0 0 0 0 0 ;
 0 0 0 0 0 0 0 0 ;
 0 0 0 0 0 0 0 0];
filt6 = [1 1 1 0 0 0 0 0 ;
 1 1 0 0 0 0 0 0 ;
 1 0 0 0 0 0 0 0 ;
 0 0 0 0 0 0 0 0 ;
 0 0 0 0 0 0 0 0 ;
 0 0 0 0 0 0 0 0 ;
 0 0 0 0 0 0 0 0 ;
 0 0 0 0 0 0 0 0];
filt=filt10;
imwrite(dctcoef, '7221_new.jpg');