% assignment 2
clear;
close all;
clc;

%% Specify parameter values

m = 0.017; %measured mass ball [kg]
g = 9.81; % gravitational constant [m/s^2]
d = 0.041; % diameter ball [m]
Feq = m*g; 

% a = distance between base and tip of EM [m]
% To select the proper value of a, uncomment one of the two lines below 
% depending on the set-up you are using.

% a = 0.084; 
a = 0.1113;

%Height of supports, uncomment one set of heights depending on the setup 
%you are using.

% pbottom = 0.016;
% pmiddle = 0.021;
% ptop = 0.026;

pbottom = 0.044;
pmiddle = 0.049;
ptop = 0.054;

%% START GUI : Measure currents where ball accelerates, they are stored in vector I
%waitfor(CurrentMeasurement);
%save('Current.mat', 'I');


%% *****************for students to complete******************
load('Current.mat');
Y = [pbottom pmiddle ptop]; % Position of top of ball 
I = I; % The current required to lift the ball at the positions Y
% Calculate Pm and Cm
% Pick two pairs and solve the set of two equations with two unknowns

% p = polyfit(Y,I,1);
% plot(Y,I);

Cm = (Feq*Y(2)-Feq*Y(1))/(I(1)-I(2));
Pm = Feq*((a-d)-Y(1))-Cm*I(1);