function [tu,tg,Ks,t,sys_step] = wendepkt(Ks,T,startval)

% Schrittantwort bestimmen
% -------------------------------------------------------------------------
N = length(T);
% num = Ks;
denum_n = zeros(N,2);
denum = 1;

if Ks<=startval
   error('Ks muss grösser sein als der Startwert')
end

for k=1:N
    denum_n(k,1:2) = [T(k) 1];
end

for k=1:N
    denum = conv(denum_n(k,1:2),denum);
end

t = linspace(0,5*sum(T),1e3);
sys_step = step(Ks-startval,denum,t);
sys_step = sys_step+startval;
sys_min = min(sys_step);

% Achsenlimite für Plot bestimmen
ax_max = Ks*1.05;
ax_min = sys_min-Ks*0.05;

% Berechnung der Wendetangente
[dy,t_pt] = max(diff(sys_step));
% dt = (t(t_pt+1)-t(t_pt-1))/2;
dt = t(2)-t(1);
% t_slope = linspace(0,max(t),1e3);
sys_wndtg = dy/dt*t-dy/dt*t(t_pt)+sys_step(t_pt);

% Tu, Tg aus Wendetangente bestimmen
% [~,t_Ks] = min(abs(Ks-sys_wndtg));
% [~,t_tu] = min(abs(sys_min-sys_wndtg));
% tu = t_slope(t_tu);
tu = (sys_min+dy/dt*t(t_pt)-sys_step(t_pt))*dt/dy-t(1);
tg = (Ks+dy/dt*t(t_pt)-sys_step(t_pt))*dt/dy-t(1)-tu;
% tg = t_slope(t_Ks)-tu;


% % Plots
% % -------------------------------------------------------------------------
% % set(0,'DefaultFigureWindowStyle','docked')
% % neues Plotfenster erstellen
% figure('Name','Schrittantwort Strecke mit Wendetangente')
% hold on
% 
% % Schrittantwort plotten
% plot(t,sys_step,'Color','k','LineWidth',2)
% axis([0 max(t) ax_min ax_max])
% 
% % Wendetangente plotten
% plot(t_slope,sys_wndtg,'b','LineWidth',1.5)
% 
% % tu tg ks plotten
% line([min(t) max(t)],[Ks Ks],'Color','g','LineWidth',1.5)
% line([(min(t)) tu],[(ax_max-ax_min)/2+sys_min (ax_max-ax_min)/2+sys_min],'LineWidth',1.5,'Color','m')
% line([tu tu+tg],[sys_min-Ks*0.025 sys_min-Ks*0.025],'LineWidth',1.5,'Color','r')
% 
% line([t_slope(t_Ks) t_slope(t_Ks)],[ax_min ax_max],'Color','r','LineStyle','--')
% line([t_slope(t_tu) t_slope(t_tu)],[ax_min ax_max],'Color','m','LineStyle','--')
% line([0 max(t)],[sys_min sys_min],'Color','k')
% 
% 
% % Beschriftungen hinzufügen
% % text((tg)/2+tu,sys_min-Ks*0.001,'t_{g}','Color','r')
% % text((tu-min(t))/2,(ax_max-ax_min)/1.92+sys_min,'t_{u}','Color','m')
% % text(tg/2+tu,(ax_max-ax_min)*0.86+sys_min,'K_{s}','Color','g')
% xlabel('Zeit t (s)')
% legend({'Schrittantwort der Strecke','Wendetangente','Ks','tu','tg'},'Location','best')
% hold off
% grid on 
% grid minor
end