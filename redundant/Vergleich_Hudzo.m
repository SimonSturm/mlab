clear all
close all

T = [1 1 1 1 1 1 1 1];
Ks = 10;
startval = 0;
[tu,tg,Ks] = wendepkt(Ks,T,startval);

% Hudzo
n = length(T);

r_max = 1/(n-1)-1e-12;
r_pt = 100;
r = linspace(0,r_max,r_pt);
r_interpol = linspace(0,r_max,r_pt*1e2);

for ind=1:n
    T_hudzo(1:r_pt,ind) = 1./(1-(ind-1)*r);
end

for a=1:length(r)
    [tu_T(a),tg_T(a)] = wendepkt(Ks,T_hudzo(a,1:n),startval);
end

T_tg = 1./tg_T; 
tu_tg = tu_T./tg_T;
T_tg_interpol = spline(r,T_tg,r_interpol);
tu_tg_interpol = spline(r,tu_tg,r_interpol);

[~,r_tutg] = min(abs(tu/tg-tu_tg_interpol));
T_h = T_tg_interpol(r_tutg)*tg;
r_k = r_interpol(r_tutg);
T_k = 1./(1-([1:n]-1)*r_k);

step_hudzo(Ks,T_k,startval);
step_hudzo(Ks,T,startval);
figure
% Plots
subplot(211)
plot(r,tu_tg,r_interpol,tu_tg_interpol)
legend('r with 5 points','r with 500 points')
% axis([0 1 0 0.7])
grid on
grid minor


subplot(212)
plot(r,T_tg,r_interpol,T_tg_interpol)
legend('r with 5 points','r with 500 points')
% axis([0 1 0 0.7])
grid on
grid minor

