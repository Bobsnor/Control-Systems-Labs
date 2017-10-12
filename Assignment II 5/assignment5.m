% assignment 5
clear;
close all;
clc;


%% Specify the following variables that resulted from previous assignments:

% poscal = ;
% I0 = ;
% Y0 = ;
% Controller without integrator designed in Assignment II-4:
% C_num = ;  
% C_den = ;

Ts = 1/2000;

%% START GUI : Run continuous controller
% Depending on what set-up you are using, rename the file ContinuousController_newsetup.p or
% ContinuousController_oldsetup.p to ContinuousController.p
waitfor(ContinuousController);

%% plot results
figure(1); hold on; plot(time,pos); plot(time,posref+Y0);
hold off; xlabel('time(s)'); ylabel('position(m)'); legend('pos','posref');
%axis([]);

figure(2); plot(time,current); xlabel('time(s)'); ylabel('current(A)');
%axis([]);
