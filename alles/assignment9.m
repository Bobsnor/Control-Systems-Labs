% assignment 9

clear;
close all;
clc;

%% Specify the following variables that resulted from previous assignments:
%
% poscal = ;
% I0 = ;
% Y0 = ;

% Controller designed in Assignment II-8:
% Cd= '
% Ts = ;

% Remove the integrator from the discrete controller
[z,p,k] = zpkdata(Cd,'v');
[Cd_num,Cd_den] = tfdata(zpk(z,p(2:end),k/Ts,Ts),'v');

%% Start GUI, run discrete controller
waitfor(DiscreteController);

%% plot results
figure(1); hold on; plot(time,pos); plot(time,posref+Y0);
hold off; xlabel('time(s)'); ylabel('position(m)'); legend('pos','posref');
axis([0 10 0 30e-3]); title('Designed Discrete Controller');

figure(2); plot(time,current); xlabel('time(s)'); ylabel('current(A)');
axis([0 10 -0.1 3.1]); title('Designed Discrete Controller');
