function [Tk] = ident_hudzovic(tu,tg,Ks,plot_set)
    if nargin == 3
       plot_set = 'off'; 
    end
    tu_tg = tu/tg;
    step_rep = 1;
%     [curves_tutg,curves_ttg,r] = hudzo_curves(30,1e3);

    cd('D:\FHNW\Matlab\mlab\Versuch_3\matrices')
%     curves_alex = load('curves_alex.mat');
    curves_tutg = struct2array(load('hudzo_tutg.mat'));
    curves_ttg = struct2array(load('hudzo_ttg.mat'));
    r = struct2array(load('hudzo_r.mat'));
    cd('D:\FHNW\Matlab\mlab\Versuch_3')

%     curves = curves_alex.curves_alex.curves;
%     for k = 1:7
%         r(k,:) = curves(k).r;
%         curves_tutg(k,:) = curves(k).tu_tg;
%         curves_ttg(k,:) = curves(k).t_tg;
%     end
    n_min = find((tu_tg-curves_tutg(:,1))<=0,1);

    r_min = spline(curves_tutg(n_min,:),r(n_min,:),tu_tg);
    ttg_min = spline(r(n_min,:),curves_ttg(n_min,:),r_min);
    T = ttg_min*tg;

    for k = 1: n_min + 1
        Tk(1,k) = T/(1-(k-1)*r_min);
    end

   
        for k = 1: n_min + 1
           step_rep = conv(step_rep,[Tk(1,k) 1]); 
        end

%         t = linspace(0,5*sum(Tk),1e3);
%         g_t = step(Ks,step_rep,t);  
       
    if strcmp(plot_set,'on')        
        cd('D:\FHNW\5_Semester\mlab\Versuch_3\graphics')
        figure('Name','Bestimmung Ordnung, T und r')
        subplot(211)
        plot_tutg = plot(r',curves_tutg','LineWidth',1);
        col_mat = cell2mat(get(plot_tutg,'Color'));
        col_nmin = col_mat(n_min,:);
        legend('n=2','n=3','n=4','n=5','n=6','n=7','n=8')
        line([0 r_min],[tu_tg tu_tg],'LineStyle','--','Color',col_nmin,'LineWidth',1);
        line([r_min r_min],[tu_tg 0],'LineStyle','--','Color',col_nmin,'LineWidth',1);
        grid on 
        grid minor
        ylabel('t_{u}/t_{g}')
        xlabel('r')
        axis([0 1 0 0.7])

        subplot(212)
        plot(r',curves_ttg','LineWidth',1);
        legend('n=2','n=3','n=4','n=5','n=6','n=7','n=8')
        line([r_min r_min],[0.4 ttg_min],'LineStyle','--','Color',col_nmin,'LineWidth',1);
        line([r_min 0],[ttg_min ttg_min],'LineStyle','--','Color',col_nmin,'LineWidth',1);
        grid on 
        grid minor
        ylabel('T/t_{g}')
        xlabel('r')
        axis([0 1 0 0.4])

        % figure('Name','Schrittantwort Strecke')
        % plot(t,g_t,'LineWidth',2)
        % grid on
        % grid minor
        % xlabel('Zeit t (s)')
        % axis([0 t(end) 0 Ks])
        cd('D:\FHNW\Matlab\mlab\Versuch_3')
    end
end
