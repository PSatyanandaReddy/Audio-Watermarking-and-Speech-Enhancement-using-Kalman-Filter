clc
clear
close all 
wm_sz     = 20000;                        
px_sz     = wm_sz/8;                      
im_sz     = sqrt(px_sz);                  
host_new  = audioread ('host_new.wav');   
host_new  = uint8(255*(host_new + 0.5)); 