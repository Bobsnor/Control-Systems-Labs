% assignment 4
clear;
close all;
clc;

%% Specify the following variables that you have found in Assignment II-3:
% I0 = ;
% Y0 = ;
% LinModel = ;
load('Assignment3.mat');
s = tf('s');

load('Assignment4.mat');

% Use rltool to design a Controller C
sisotool(LinModel, C)
input('Press enter to continue after exporting the controller to workspace.');
% After exporting a Controller C to workspace execute this part of the
% script

% C = ;
save('Assignment4.mat', 'C');

[num, den] = tfdata(C,'v');

% construct from num and den a modified version (C_num, C_den) that is equal to C but without
% integrator.

C_num = num;
C_den = 1; 

[P_num,P_den] = tfdata(LinModel,'v'); % put plant in simulation model form.