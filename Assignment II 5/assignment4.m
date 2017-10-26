% assignment 4
clear;
close all;
clc;

%% Specify the following variables that you have found in Assignment II-3:
% I0 = ;
% Y0 = ;
% LinModel = ;
load('Assignment3.mat');
load('Assignment4.mat');
s = tf('s');

% C = 6.67e+10 + 1.33e+15/s + 8.33e+05*s;
kp = 8e8;
ki = 5e7;
kd = 15e5;
% C = 1.0618e9*(s+589.5)*(s+1.748)/s;
C = kp + ki/s + kd*s;

C = C/((s+10001)*(s+10000)); % C + poles
% pidTuner(LinModel);

% load('Assignment4.mat');

% Use rltool to design a Controller C
% sisotool(LinModel, C);
% input('Press enter to continue after exporting the controller to workspace.');
% After exporting a Controller C to workspace execute this part of the
% script

% C = ;


[num, den] = tfdata(C,'v');

% construct from num and den a modified version (C_num, C_den) that is equal to C but without
% integrator.

C_num = num;

C_den = den(1:end-1);
% C_den = den/s; 

save('Assignment4.mat', 'C', 'C_num', 'C_den');

[P_num,P_den] = tfdata(LinModel,'v'); % put plant in simulation model form.