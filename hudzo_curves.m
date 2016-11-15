function [tu_tg,t_tg,r_interpol] = hudzo_curves(r_res,spline_interpol)

    % predefine matrices and s
    s = tf('s');
    r = zeros(7,r_res);
    r_interpol = zeros(7,r_res*spline_interpol);
    tu = zeros(7,r_res);
    tg = zeros(7,r_res);
    tu_tg = zeros(7,r_res*spline_interpol);
    t_tg = zeros(7,r_res*spline_interpol);

    % main loop which calculates tu and tg for orders 2 through 8
    for n = 2:8
        clear H_sys Tk    
        
        % create r vectors
        for ind = 1:n
            r(n-1,:) = linspace(0,1/(ind-1)-1e-10,r_res);
            r_interpol(n-1,:) = linspace(0,1/(ind-1)-1e-10,r_res*spline_interpol);
        end
        
        % calculate tk for current order
        for k = 1:n
          Tk(:,k) = 1./(1-(k-1)*r(n-1,:));
        end

       
        sys_tf = Tk*s+1;
        G_s = 1;
        
        % calculate impulse response, step response and tu tg
        for ind_r = 1:r_res
            % Impulse response
            for ind = 1:n
                G_s = G_s*sys_tf(ind_r,ind);
            end
            
            % calculate step response
            [h,t] = step(1/G_s);
            
            % create tu, tg with wendetng.m
            [~,tu(n-1,ind_r),tg(n-1,ind_r)] = wendetng(t,h);
            
            % reset step response
            G_s = 1;
        end
        
        % Calculate tu/tg and T/tg and interpolate with spline
        t1_temp = tu./tg;
        t2_temp = 1./tg;

        tu_tg(n-1,:) = spline(r(n-1,:),t1_temp(n-1,:),r_interpol(n-1,:));
        t_tg(n-1,:) = spline(r(n-1,:),t2_temp(n-1,:),r_interpol(n-1,:));
    end

    % Plots 
    
    % subplot(211)
    % set(0,'DefaultFigureVisible','off')
    % plot_tutg = plot(r_interpol',tu_tg');
    % grid on 
    % grid minor
    % 
    % subplot(212)
    % plot_ttg = plot(r_interpol',t_tg');
    % grid on 
    % grid minor
    % set(0,'DefaultFigureVisible','off')
end

