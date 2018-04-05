%Reference https://en.wikipedia.org/wiki/Fresnel_diffraction

%Final Location (Maybe we need spread across the 3d plane)
x =
y = 
z = 
%Lambda is the wavelength in meers
lambda = 10; %Meters
%Distance from aperature to the abservation point (3-D space)
r = sqrt( (x - x_prime)^2 + (y - y_prime)^2 + z^2 );
%K Term
k = (2*pi())/lambda;

%We need to define our aperature

%The triangular aperature is an equilateral triangle with a uniform lengh l
triangle_side_length = 1;



  

% Creating the function to be observed for the double integral
% Reference https://www.mathworks.com/help/matlab/ref/integral2.html

fun = @(x_prime,y_prime)  .* (e^(j*k*r))/r



q = 1/(j*lamda) * integral2(fun,triangle_side_length,0,0,(sqrt(3)/2)*triangle_side_length)