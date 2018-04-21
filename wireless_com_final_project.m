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
Pow_Rad_dB = 10*log10(Power_Radiated);

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
Lfreespace_KFE = 32.4 + 20*log10( (transmitter_distance + bldg_1_w)/1000 )+ 20*log10( (f/10e6) );
%SE = Second Building
Lfreespace_SE = 32.4 + 20*log10( (transmitter_distance + bldg_1_w + street_w)/1000 )+ 20*log10( (f/10e6) );

%%
%Calculating the reflected energy off of the second building
%Given in the project
b2_reflec_coef = 0.5;
%Converting power loss to dB
b2_reflec_coef_dB = 10*log10(b2_reflec_coef);

Recieved_off_B2 = Lfreespace_SE - b2_reflec_coef_dB;

%%
%We need to iterate through the knife edge calculation 3 different times.
%Because we have different person placement on the road. 3m,12m,18m.

for k = 1:length(walker_location)
%%
%Building the triangle to determine path of radiation.
%See figure 5.6


    %Knife Edge Calculation From the Side view
    offset_removed_tx = tx_h - rx_h;
    distance_between_antennas(k) = transmitter_distance + bldg_1_w + walker_location(k);
    %We have the a^2 and b^2 we now need to find the angle. 
    %Inverse tangent in degrees
    receive_antenna_angle_SideView = atand(offset_removed_tx/distance_between_antennas(k));
    %Rebuilding a 2nd triangle, with the building being the other side (and
    %adding in the reciving antenna height, because it was removed to have the
    %recieving antenna triangle be at y = 0
    knife_edge_height_SideView = ( tand(receive_antenna_angle_SideView) * walker_location(k) ) + rx_h;

    %The total building height minus the triangle side height that is created
    %by the direct transmitted  wave. Giving us He 
    he_SideView = bldg_1_h - knife_edge_height_SideView;
    %Equation 5.21
    v_SideView = he_SideView * sqrt( (2*( (transmitter_distance + bldg_1_w) + walker_location(k)))/ ...
        (lambda*(transmitter_distance + bldg_1_w)* walker_location(k)) );

    %Generating the fresnel
    C_SideView = fresnelc(v_SideView);
    S_SideView = fresnels(v_SideView);

    %From the fresnel calculations creates the F(v) eq 5.23
    Fv_SideView(k) = 0.5*(0.5+C_SideView^2-C_SideView+S_SideView^2-S_SideView);
    %Knife edge loss from sideview
    Lke_SideView(k) = -20*log10(Fv_SideView(k));




    %Knife Edge Calculation From the Top view

    %No offset 
    distance_between_antennas(k) = transmitter_distance + bldg_1_w + walker_location(k);
    %The building we're walking along is 15 meters long. 
    walking_path = [-15:0.01:0];
    %We have the a^2 and b^2 we now need to find the angle. 
    %Inverse tangent in degrees
    for i = 1 :length(walking_path)
        receive_antenna_angle(i) = atand(distance_between_antennas(k)/walking_path(i));
    end
    %We need to create aanother triangle (see note 1) to correctly calculate
    %the blocking height of the building in the top down perspective
    other_recieve_antenna_angle(k,:) = 90+(receive_antenna_angle);

    %Rebuilding a 2nd triangle. DIfferent than the side view
    %Use figure 5.6
    absorbing_screen_height = ( tand(other_recieve_antenna_angle(k)) .* walker_location(k));

    %The total building height minus the triangle side depth that is created
    %by the direct transmitted  wave. Giving us He (for the top down view)

    %Why do we subtract the bldg 1 distance from the walking path?? Well the
    %triangle side changes it's size based on how far along the path the person
    %is walking. So the building blocking side needs to be recalculated 
    he_TopView(k,:) = ( bldg_1_d - (15-abs(walking_path)) )- absorbing_screen_height;
    %Equation 5.21
    v_TopView(k,:) = he_TopView(k,:) .* sqrt( (2*( (transmitter_distance + bldg_1_w) + walker_location(k)))/ ...
        (lambda*(transmitter_distance + bldg_1_w)* walker_location(k)) );

    %Generating the fresnel
    C_TopView(k,:) = fresnelc(v_TopView(k,:));
    S_TopView(k,:) = fresnels(v_TopView(k,:));

    %From the fresnel calculations creates the F(v) eq 5.23
    Fv_TopView(k,:) = 0.5.*(0.5+C_TopView(k,:).^2-C_TopView(k,:)+S_TopView(k,:).^2-S_TopView(k,:));
    %Knife edge loss from sideview
    Lke_TopView(k,:) = -20*log10(Fv_TopView(k,:));



%%
%Calculating the entire LINK
Path1(k) = Pow_Rad_dB - Lfreespace_KFE - Lke_SideView(k);
Path2(k,:) = Pow_Rad_dB - Lfreespace_KFE - Lke_TopView(k,:);
Path3(k) = Pow_Rad_dB - Lfreespace_KFE - b2_reflec_coef;
Total_Power_Recieved(k,:) = Path1(k) + Path2(k,:) + Path3(k);

end

%Plotting all of the 3 paths
figure(1);
plot(       walking_path, Total_Power_Recieved(1,:),...
            walking_path, Total_Power_Recieved(2,:),...
            walking_path, Total_Power_Recieved(3,:)...
        );
title('');
legend('y = 3m','y = 12m', 'y = 18m');
ylabel('Recieved Energy [dB]');
xlabel('Walker Location [m] ');

