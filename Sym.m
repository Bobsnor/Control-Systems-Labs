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