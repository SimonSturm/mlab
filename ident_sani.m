function [Tk] = ident_sani(tu,tg,Ks,plot_set)
    if nargin == 3
       plot_set = 'off'; 
    end
    
    r_res = 20;
    r_interpol = 1e3;
    step_rep = 1;

    tu_tg = tu/tg;
%     [curves_tutg,curves_ttg,r] = sani_curves(r_res,r_interpol);
    cd('D:\FHNW\Matlab\mlab\Versuch_3\matrices')
        curves_tu = struct2array(load('tu_sani.mat'));
        curves_tg = struct2array(load('tg_sani.mat'));
        r = struct2array(load('r_sani.mat'));
    cd('D:\FHNW\Matlab\mlab\Versuch_3')
    
    curves_tutg = curves_tu./curves_tg;
    curves_ttg = 1./curves_tg;
    
    n_min = find((tu_tg-curves_tutg(:,end))<=0,1);

    r_min = spline(curves_tutg(n_min,:),r,tu_tg);
    ttg_min = spline(r,curves_ttg(n_min,:),r_min);
    T = ttg_min*tg;
    Tk = T*r_min.^(0:n_min);

    if strcmp(plot_set,'on') 
        for k = 1: n_min + 1
            step_rep = conv(step_rep,[T*r_min^(k-1) 1]); 
        end

%         t = linspace(0,ceil(2.5*sum([tu tg])),1e3);
%         g_t = step(Ks,step_rep,t);
        
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
        line([r_min r_min],[1 ttg_min],'LineStyle','--','Color',col_nmin,'LineWidth',1);
        line([r_min 0],[ttg_min ttg_min],'LineStyle','--','Color',col_nmin,'LineWidth',1);
        grid on 
        grid minor
        ylabel('T/t_{g}')
        xlabel('r')
        axis([0 1 0 1])

        print -depsc sani_curves

        % figure('Name','Schrittantwort Strecke')
        % plot(t,g_t,'LineWidth',2)
        % grid on
        % grid minor
        % xlabel('Zeit t (s)')
        % axis([0 t(end) 0 Ks])
        cd('D:\FHNW\Matlab\mlab\Versuch_3')
    end
end