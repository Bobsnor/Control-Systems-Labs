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

wc = 200*pi;
a = s / wc;
B = (a + 1)*(a^2 + -2*cos(3/5*pi)*a + 1)*(a^2 + -2*cos(4/5*pi)*a +1);
H = 1/B;
%bode(H);

wc = 20*pi;
a = s / wc;
P = 1/(1+a);
%step(P);

Kp = 0.00174;
Ki = 0.005304;
Kd = 0;
D = Kp + Ki/s + Kd*s;


Tuner = G*H;
K = D*G*H;
K = feedback(K,1);
K = P*K;
step(K);