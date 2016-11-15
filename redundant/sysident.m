clear all
close all

tu = 0.96;
tg = 4.52;
Ks = 36.94-22;
r = tu/tg;

r2 = 0.09;
T = r2*tg;

n = 4;
s = tf('s');

for k=1:n
    T_k(k) = T/(1-(k-1)*r);
    G(k) = 1/(1+s*T_k(k));
end

Gs = 22+Ks*G(1)*G(2)*G(3)*G(4);
[a,t] = step(Gs,10);
plot(t,a);
hold on
line([tg tg],[22 38],'LineStyle','--','Color','r');
line([tu tu],[22 38],'LineStyle','--','Color','r');
line([0 10],[Ks+22 Ks+22],'LineStyle','--','Color','r');
grid on