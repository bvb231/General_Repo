clear; clc; close all;

%Current and Dipole Calculations
f = 9e8;
c = 3e8;
lambda = c/f;
dipole_D = 1.5; 
antenna_length = 1;
%In terms of Amps
antenna_current = 10; 

%Eq 3.58 Page 80
radiation_res = 20*pi()^2*(antenna_length/lambda)^2;

%Eq 3.57 Page 80
%In terms of Watts
Power_Radiated = 0.5*(antenna_current^2) * radiation_res;
%dB
Pow_Rad_dB = 10*log(Power_Radiated);

%%
%All Units are in meters

%Transmitter Antenna (Base offset of antenna from the buildings)
tx_h = 200 ;
transmitter_distance = 1000;
%Reciever Antenna/Persons location (off set from building 1. The person is
%between B1 and B22
rx_h = 1.5;
walker_location = [3,12,18];

% Building 1
bldg_1_h = 3;
bldg_1_w = 20;
bldg_1_d = 15;
%Street
street_w = 20;
% Building 2
bldg_2_h = 30;
bldg_2_w = 40;


%%
%Calculating the free space loss all the way UP TO the knife edge (building
%1

%Eq 5.6 (dB) 
%FKE = First Knife Edge
Lfreespace_KFE = 32.4 + 20*log( (transmitter_distance + bldg_1_w)/1000 )+ 20*log( (f/10e6) );
%SE = Second Building
Lfreespace_SE = 32.4 + 20*log( (transmitter_distance + bldg_1_w + street_w)/1000 )+ 20*log( (f/10e6) );



%Building the triangle to determine path of radiation.
%See figure 5.6

%%

%Knife Edge Calculation From the Side view
offset_removed_tx = tx_h - rx_h;
distance_between_antennas = transmitter_distance + bldg_1_w + walker_location(1);
%We have the a^2 and b^2 we now need to find the angle. 
%Inverse tangent in degrees
receive_antenna_angle_SideView = atand(offset_removed_tx/distance_between_antennas);
%Rebuilding a 2nd triangle, with the building being the other side (and
%adding in the reciving antenna height, because it was removed to have the
%recieving antenna triangle be at y = 0
knife_edge_height_SideView = ( tand(receive_antenna_angle_SideView) * walker_location(1) ) + rx_h;

%The total building height minus the triangle side height that is created
%by the direct transmitted  wave. Giving us He 
he_SideView = bldg_1_h - knife_edge_height_SideView;
%Equation 5.21
v_SideView = he_SideView * sqrt( (2*( (transmitter_distance + bldg_1_w) + walker_location(1)))/ ...
    (lambda*(transmitter_distance + bldg_1_w)* walker_location(1)) );

%Generating the fresnel
C_SideView = fresnelc(v_SideView);
S_SideView = fresnels(v_SideView);

%From the fresnel calculations creates the F(v) eq 5.23
Fv_SideView = 0.5*(0.5+C_SideView^2-C_SideView+S_SideView^2-S_SideView);
%Knife edge loss from sideview
Lke_SideView = -20*log(Fv_SideView);



%%

%Knife Edge Calculation From the Top view
%No offset 
distance_between_antennas = transmitter_distance + bldg_1_w + walker_location(1);
%The building we're walking along is 15 meters long. 
walking_path = [-15:0.01:0];
%We have the a^2 and b^2 we now need to find the angle. 
%Inverse tangent in degrees
for i = 1 :length(walking_path)
    receive_antenna_angle(i) = atand(distance_between_antennas/walking_path(i));
end
%We need to create aanother triangle (see note 1) to correctly calculate
%the blocking height of the building in the top down perspective
other_recieve_antenna_angle = 90+(receive_antenna_angle);

%Rebuilding a 2nd triangle. DIfferent than the side view
%Use figure 5.6
absorbing_screen_height = ( tand(other_recieve_antenna_angle) .* walker_location(1));

%The total building height minus the triangle side depth that is created
%by the direct transmitted  wave. Giving us He (for the top down view)

%Why do we subtract the bldg 1 distance from the walking path?? Well the
%triangle side changes it's size based on how far along the path the person
%is walking. So the building blocking side needs to be recalculated 
he_TopView = ( bldg_1_d - (15-abs(walking_path)) )- absorbing_screen_height;
%Equation 5.21
v_TopView = he_TopView .* sqrt( (2*( (transmitter_distance + bldg_1_w) + walker_location(1)))/ ...
    (lambda*(transmitter_distance + bldg_1_w)* walker_location(1)) );

%Generating the fresnel
C_TopView = fresnelc(v_TopView);
S_TopView = fresnels(v_TopView);

%From the fresnel calculations creates the F(v) eq 5.23
Fv_TopView = 0.5.*(0.5+C_TopView.^2-C_TopView+S_TopView.^2-S_TopView);
%Knife edge loss from sideview
Lke_TopView = -20*log(Fv_TopView);