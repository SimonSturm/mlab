% [tu,tg] = wendepkt();
n = [2:8]';
r_max = 1./(n-1);
np = 10;
for k=1:6
    r(k,1:np) = linspace(0,r_max(k),np);
end

T_n = T/(1-(n-1)*r);
T = curve_2*tg;
% T = T/(1-(k-1)*r);