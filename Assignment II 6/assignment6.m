%  Assignment 6, Compare continuous and discrete controller performance

clear;
close all;
clc;

%% Specify the following variables that resulted from previous assignments:

% I0 = ;
% Y0 = ;
% LinModel = ;

% Controller designed in Assignment II-4:
% C = ;


% continuous plant and controller
[C_num,C_den] = tfdata(C,'v');
C_den = C_den(1:end-1); %remove integrator
[P_num,P_den] = tfdata(LinModel,'v');


Ts = 1/500; %adjust Ts to find the maximum Ts that stabilizes the plant

% discretize
Cd = c2d(C,Ts);
[z,p,k] = zpkdata(Cd,'v');

% discrete numerator en denominator with integrator removed
[Cd_num,Cd_den] = tfdata(zpk(z,p(2:end),k,Ts),'v');

% simulate continuous and discrete controller in simulink
sim('DiscreteImplementationContinuousController.mdl');