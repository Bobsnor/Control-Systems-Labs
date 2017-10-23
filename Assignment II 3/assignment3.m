% assignment 3
clear;
close all;
clc;

%% Specify parameter values

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

%% Specify the following variables that you have found in Assignment II-2:
%
Pm = 0.0012;
Cm = 9.926785714285727e-04;
Y= [0.044,0.049,0.054];
I= [3.2,2.36,1.66];

%% Obtain linear model (Assignment II 3)
% Pick an operating point (middle one)
I0 = I(2);
Y0 = Y(2);

% From linearization we know the linearized transfer function, using I0,
% Y0, Cm, Pm, a

Fm = (Cm.*I+Pm)./((a-d)-Y);
dI = Cm/((a-d)-Y0);
dY = (Cm * I0 + Pm) / (((a-d)-Y0)^2);
s = tf('s');
H = dI/((m*(s^2)-dY));

%Construct transfer function (LinModel) for the plant using MATLAB function
%tf
% LinModel = laplace(LinTime, [I Y], s);