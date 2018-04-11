clc; close all; clear all;

%Reference https://en.wikipedia.org/wiki/Fresnel_diffraction
%For ease of calculation. The observation point is on the X-Y plane
%with Z distance away. 
xi = 0;
yi = 0;
zi = 0.5; %meters (to stay within the fresnel region)
lambda = 0.01; %meters (our generic wavelength going through the aperature

%K Term
k = (2*pi())/lambda;

%generic length of our triangle. Using unit length for simplicity. 
length = 1;
length_step = length/100;

%Predefining the coefficient.
xo = 0;


%Not perfect but it's a triangle
%Splitting the values in 2 portions because a triangle is made up of two
%lines  / and \.
yo_plus = (sqrt(3)/2.*xo) + 0.13; %- (1/sqrt(2));
yo_minus = (-sqrt(3)/2.*xo) + 0.13;% - (1/sqrt(2));


%According to class notes. we can assume zi >> xi - xo and zi >> yi - yo
%so we can state:
r_plus = zi + ( ((xi-xo).^2 + (yi - yo_plus).^2) /(2*zi));
r_minus = zi + ( ((xi-xo).^2 + (yi - yo_minus).^2) /(2*zi));

%%
  
% Creating the function to be observed for the integral across the 
% area of the triangle.
% Reference https://www.mathworks.com/help/matlab/ref/integral2.html

% We integrate across the x line, with the triangle side slop to solve for 
% 2-D area of the triangle. Done so in some notes to the side.
fun_plus = @(xo) -sqrt(3).*xo .* (exp(j.*k.*r_plus))./r_plus;
fun_minus = @(xo) -sqrt(3).*xo .* (exp(j.*k.*r_minus))./r_minus;


%Since the function above 

q_plus = ( exp(j.*k.*r_plus)./(j*lambda*zi) ) * integral(fun_plus,-length/2,0);
%     ^ Constant portion                        ^Integral Aspect

q_minus = ( exp(j.*k.*r_minus)./(j*lambda*zi) ) * integral(fun_minus,-length/2,0);
%     ^ Constant portion                        ^Integral Aspect

%After integrating across both of the triangle halves, these two halves are
%are then summed to give us the final e&m value at the point in space 
%which is defined as (xi,yi,zi)

Q_total = q_plus + q_minus; 