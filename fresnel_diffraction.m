clear all; close all; clc;

%Creating the background
N = 1000;
M = 1000;
whiteImage = 255 * ones(N, M, 'uint8');
imshow(whiteImage);

%%
%Creating the triangle for us

slope = sqrt(3);
side_length = 300;

%Building our background image
rows        = side_length*2;
columns     = rows;
x_pos = (0:(side_length/2)-0.1);
x_neg = (side_length/2:side_length);
%y = mx + b form
y_pos = (slope.*x_pos);
y_neg = (-slope .*x_neg)+(side_length * sqrt(3));

%Combining the two vectors together.
y = horzcat(y_pos,y_neg);
x = horzcat(x_pos,x_neg);
z = ones(1,length(x));
y_zero = zeros(1,length(x));

y = uint8(y);
x = uint8(x);

 
aperature_1(2,:) = y;
aperature_1(1,:) = x;
aperature_1(3,:) = zeros(1,length(x));

aperature_2(2,:) = y_zero;
aperature_2(1,:) = x;
aperature_2(3,:) = zeros(1,length(x));


% figure(1);
% plot(x_pos,y_pos)
% figure(2);
% plot(x_neg,y_neg)
% figure(3);
%figure(1);
line(x,y,z)
hold on;
line(x,y_zero,z)
 
% figure(2);
% mesh(aperature)


figure(3);
A = fft2(whiteImage);
imagesc(abs(fftshift(A)))


