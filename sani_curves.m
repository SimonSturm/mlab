function [tu_tg,t_tg,r_interpol] = sani_curves(r_res,r_interpol)
    
    r = linspace(0,1-1e-10,r_res);
    r_interpol = linspace(0,1-1e-10,r_res*r_interpol);
    T = 1;
    Ks = 1;
    n_max = 8;

    for ind = 0:n_max-1
        Tk(ind+1,:) = T*r.^ind;
    end

    for n = 2:n_max
        for r_ind = 1:r_res
            [tu(n-1,r_ind),tg(n-1,r_ind)] = wendepkt(Tk(1:n,r_ind),Ks,0,0);
        end
    end

    t1_temp = tu./tg;
    t2_temp = T./tg;
    
    for n = 2:8
        tu_tg(n-1,:) = spline(r,t1_temp(n-1,:),r_interpol);
        t_tg(n-1,:) = spline(r,t2_temp(n-1,:),r_interpol);
    end
    
    % for n = 2:8
    %     lambda_r(n-1,:) = 1.315*sqrt(3.8*(1-r.^(2*(n+1)))./(1-r.^2)-1)./(log(2)+r.*(1-r.^n)./(1-r));
    % end
end