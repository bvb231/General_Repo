close all; clear all; clc; 

signal_energy = 1;

s1 = [sqrt(signal_energy),0];
s2 = [0,sqrt(signal_energy)];


n1_01 = 0.1*randn(2,300);
n1_03 = 0.3*randn(2,300);
n1_05 = 0.5*randn(2,300);


r_01(1,:) = n1_01(1,:) + s1(1);
r_01(2,:) = n1_01(2,:) + s1(2);

r_03(1,:) = n1_03(1,:) + s1(1);
r_03(2,:) = n1_03(2,:) + s1(2);

r_05(1,:) = n1_05(1,:) + s1(1);
r_05(2,:) = n1_05(2,:) + s1(2);

figure(1)
plot(1:300,r_01);
title('Noise Variance of 0.1')


figure(2)
plot(1:300,r_03);
title('Noise Variance of 0.3')

figure(3)
plot(1:300,r_05);
title('Noise Variance of 0.5')

%Discussion
%With the increase of varience of the noise vector, the amplitude of the
%noise is further increase. Therefore increasing the probability of error
%occuring when a signal is transmitted across the channel. With the 
%greatest varience causing the signals to completely overlap and making the
%probability for error higher than in the scenario where the varience is at
%the lowest.
