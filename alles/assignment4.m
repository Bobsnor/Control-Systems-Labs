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
% C = kp + ki/s + kd*s;

% C = C/((s+5e3)*(s+6e3)); % C + poles

% C = (8.4875e10*(s+120)*(s+0.1));
% C = C/(s*(s+1e04)*(s^2 + 1600*s + 6.724e05));       % sinus werkt goed 
% 
% C = (1.681e11 *(s+120)*(s+0.05));
% C = C/(s*(s+1e04)*(s^2 + 1600*s + 6.724e05));       % sinus werkt ook goed 
% 
% C = (1.9396e11*(s+130)*(s+0.04));
% C = C/(s*(s+1e04)*(s^2 + 1600*s + 6.724e05));       % sinus werkt ook goed 

C = (2.72e11*(s+250)*(s+0.2));
C = C/(s*(s+1e04)*(s^2 + 2000*s + 1.36e06));        % Deze zit in het report

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