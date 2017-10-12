% assignment 8

clear;
clc;
close all;

%% Specify the following variables that resulted from previous assignments:
% I0 = ;
% Y0 = ;
% LinModel = ;
% Ts = ;
% Cd = ;

%% Prepare for simulation
[P_num,P_den] = tfdata(LinModel,'v');

[z,p,k] = zpkdata(Cd,'v');
[Cd_num,Cd_den] = tfdata(zpk(z,p(2:end),k,Ts),'v'); %remove integrator

