% assignment 1
clear;
close all;
clc;

%% Specify parameter values

%Height of supports, uncomment one set of heights depending on the setup 
%you are using.

% pbottom = 0.016;
% pmiddle = 0.021;
% ptop = 0.026;

pbottom = 0.044;
pmiddle = 0.049;
ptop = 0.054;

% Corresponding position of bottom of ball
Pos = [pbottom pmiddle ptop]; 


%% START GUI : Measuring voltages on the setup stored in vector V
% waitfor(CalibratePosition);

% save('Voltage.mat', 'V');
%% Linear fit
%*************************for students to complete****************
load('Voltage.mat');
poscal = polyfit(V,Pos,1);
save('Assignment1.mat', 'poscal');
V(4) = 4; %Placeholders so that the line will continue after the last point
Pos(4) = 0;
poscallin = V.*poscal(1) + poscal(2);
plot(poscallin, V);
hold on;
scatter(Pos,V);
title('Position calibration');
xlim([0.043 0.055]);
ylim([1.8 3.8]);
ylabel('Voltage (V)');
xlabel('Height (m)');
legend('Calibration', 'Measurements', 'Location', 'northwest');
% use the matlab function polyfit to make a linear fit on measered
% position and sensor voltage. Put the results in the variable called
% poscal. Produce a plot showing the measured dta points together with the
% linear fit

% poscal = ....



%% Saving your results
% it is possible to save certain variables from the workspace to a .mat
% file. This will allow you to use the same values during the next lab
% session or assignment. 
% >> save name.mat variable1 variable2 variable 3
% Omitting the variables saves the entire workspace in the .mat file. 
% 
% A previously saved mat file can be opened by double clicking in the
% folder (top left screen of matlab) or using >> load name.mat
