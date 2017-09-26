clear all;
close all;

J1 = 3.75e-6;
J2 = 3.75e-6;
k = 0.2656;
d = 3.125e-5;
Km = 4.4e-2;
b = 1e-5;

s = tf('s');

N = Km*(J2*s^2 + (b + d)*s + k);
DN = J1*J2*s^3 + (J1 + J2)*(d + b)*s^2 + ((J1 + J2)*k+b^2+2*b*d)*s + 2*b*k;
G = N/DN;
% bode(G);

wc = 200*pi;
a = s / wc;
% B = (a + 1)*(a^2 + -2*cos(3/5*pi)*a + 1)*(a^2 + -2*cos(4/5*pi)*a +1);
% H = 1/B;
% H = H*(1);
% H = (s+1)*(s^2+s+1);
% H = 1/H;
H = 1/(1+a);
% bode(H);

wc = 10*pi; %% FIX DIT; step was te steil
a = s / wc;
P = 1/(1+a);
%step(P);


% THIS WORKS SEMI

% Ratio Kp and Ki is ok. Kp / Ki = 3/2
% Lower means less noise, higher means more speed

% Kp = 0.030;
% Ki = 0.020;
% Kd = 0;


% sisotool(G*H,D,tf(1,1),P)
Kp = 0.035551;
Ki = Kp*19.31;
Kd = 0;

D = Kp + Ki/s + Kd*s;

% NOISE: 90 Hz
% wc = 100*pi; % higher cutoff frequency to filter out noise
% a = s / wc;
% U = 1/(1+a);
% D = D*U;

% bode(D);

Tuner = G*H;
% bode(Tuner);
K = D*G*H;
% bode(K);
K = feedback(K,1);
%bode(K);
K = P*K;
% bode(K);
% step(K);