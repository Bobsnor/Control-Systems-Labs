% Discrete design of the controller

clear;
close all;
clc;


% Specify the following variables that resulted from previous assignments:

% LinModel = ;

% Indicate the sample time of the discrete controller
% Ts = ;

% discretize the plant
Hpd=c2d(LinModel,Ts,'zoh');     

[z,p,Kp]=zpkdata(Hpd,'v');

% process poles in z-domain
p1=p(1) % the unstable pole
p2=p(2) % the stable pole

% process zeros in z-domain
n1=z(1) % only one zero

% Control design
% User input for pole location
Cp=input('All closed loop poles in : ');


% Controller with configuration:
	%
	%	   Kr*(z-n2)(z-p2)
	% Cd=-----------------------------
	%     (z-1)(z^2 + a1z + a2)
	%
	%  p2 is the process pole within the unit circle to be cancelled with a controller zero
	%  n2, Kr, a1, a2 are the controller parameters to be calculated

% use the MATLAB command 'solve' to solve the equations
    % syms Kr n2 a1 a2
    % [Kr,n2,a1,a2]=solve();
    

% The polynomial for the complex pole pair
pol=[1 a1 a2];
Ro=roots(pol); % get the pole locations 

% generate the discrete time controller
Cd=zpk([n2,p2],[1,Ro(1),Ro(2)],Kr,Ts);

% Check closed loop poles
[numcd, dencd] = tfdata(Cd,'v');
[numpd, denpd] = tfdata(Hpd,'v');
[numold,denold]=series(numpd,denpd,numcd,dencd);

tftot=tf(numold,denold,Ts);
figure(1)
rlocus(tftot);
grid on;
axis([-4 4 -1 1]);
axis equal;

% Calculate the closed loop transfer
[numcld,dencld]=cloop(numold,denold,-1);

% Evaluate closed loop poles and zeros
[z,p,Kcl]=tf2zp(numcld,dencld);

disp('Closed loop poles and zeros')
p
z
Kcl


