function [Ks,tu,tg] = wendetng(t,step_response)
% step_response = importdata('sys_ex.mat');
% t = importdata('sys_t.mat');

% Berechnungen
% -------------------------------------------------------------------------

% Noise entfernen, Offset und Ks bestimmen
% sys_step = smooth(step_response);
sys_step = step_response;
Ks = max(sys_step);
sys_min = min(sys_step);

% Achsenlimite für Plot bestimmen
ax_max = Ks*1.05;
ax_min = sys_min-Ks*0.05;

% Berechnung der Wendetangente

% dt = max(sys_t)/length(sys_t);
[dy,t_pt] = max(diff(sys_step));
dt = t(2)-t(1);
% slope_org = dy/dt*sys_t+sys_smooth(t_pt);
% t_org = sys_t(t_pt:length(sys_t));
% t_slope = linspace(0,max(t),1e3);
% delta_x = sys_t(t_pt);
% delta_y = sys_smooth(t_pt)-sys_min;
sys_wndtg = dy/dt*t-dy/dt*t(t_pt)+sys_step(t_pt);
% % find middle
% t_slope = linspace(0,max(sys_t),1000);
% slope_temp = dy/dt*t_slope+sys_min;
% [~,slope_ind] = min(abs(t_org(1)-t_slope));
% sys_slope = slope_temp-(slope_temp(slope_ind)-slope_org(1));

% Tu, Tg aus Wendetangente bestimmen
% [~,t_Ks] = min(abs(Ks-sys_wndtg));
% [~,t_tu] = min(abs(sys_min-sys_wndtg));
% tu = t_slope(t_tu);
% tg = t_slope(t_Ks)-tu;
tu = (sys_min+dy/dt*t(t_pt)-sys_step(t_pt))*dt/dy-t(1);
tg = (Ks+dy/dt*t(t_pt)-sys_step(t_pt))*dt/dy-t(1)-tu;


% % Plots
% % -------------------------------------------------------------------------
% % set(0,'DefaultFigureWindowStyle','docked')
% 
% % neues Plotfenster erstellen
% figure('Name','Schrittantwort Strecke mit Wendetangente')
% hold on
% 
% % Schrittantwort plotten
% plot(t,sys_smooth,'Color','k','LineWidth',1.5)
% axis([0 max(t) ax_min ax_max])
% 
% % Wendetangente plotten
% plot(t_slope,sys_wndtg,'b')
% 
% % tu tg ks plotten
% line([min(t) max(t)],[Ks Ks],'Color','g','LineStyle','--')
% line([t_slope(t_Ks) t_slope(t_Ks)],[ax_min ax_max],'Color','r','LineStyle','--')
% line([t_slope(t_tu) t_slope(t_tu)],[ax_min ax_max],'Color','m','LineStyle','--')
% line([0 max(t)],[sys_min sys_min],'Color','k')
% 
% line([(min(t)) tu],[(ax_max-ax_min)/2+sys_min (ax_max-ax_min)/2+sys_min],'LineWidth',2,'Color','m')
% line([tu tu+tg],[sys_min-Ks*0.025 sys_min-Ks*0.025],'LineWidth',2,'Color','r')
% 
% % Beschriftungen hinzufügen
% text((tg)/2+tu,sys_min-Ks*0.01,'t_{g}','Color','r')
% text((tu-min(t))/2,(ax_max-ax_min)/1.9+sys_min,'t_{u}','Color','m')
% text((tg)/2+tu,Ks*1.015,'K_{s}','Color','g')
% xlabel('Zeit t (s)')
% legend({'Schrittantwort der Strecke','Wendetangente'},'Location','best')
% hold off
% grid on 
% grid minor
end


