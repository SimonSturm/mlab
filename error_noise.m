function [e_sani,e_hudzo,noise] = error_noise(Tk,noise_max,n_noise)
    tu_tg_max = [103.6338e-003 218.0123e-003 319.3480e-003 410.2920e-003 493.2909e-003 570.0276e-003 641.7107e-003];
    results = struct('err_sani',0,'err_hudzo',0);
    Ks = 1;
    it_max = 100;
    n_pt = 1e3;

    noise = linspace(0,noise_max,n_noise)';
    T_conv = 1;
    order = length(Tk);

    for k = 1:order
        T_conv = conv(T_conv,[Tk(k) 1]); 
    end

    t = linspace(0,3*sum(Tk),n_pt);
    step_resp = step(Ks,T_conv,t)';

    for ind_noise = 1:n_noise
        for it = 1:it_max
            noise_amp = noise(ind_noise)*Ks*(rand(1,n_pt)-0.5);
            step_noise = step_resp+noise_amp; 
            [~,tu,tg] = wendetng(t,step_noise,'on');
            if tu/tg <= tu_tg_max(order-1)
                T_sani = ident_sani(tu,tg,Ks);
                T_hudzo = ident_hudzovic(tu,tg,Ks);
                n_sani = length(T_sani);
                n_hudzo = length(T_hudzo);
                plant_sani = 1;
                plant_hudzo = 1;

                for n = 1:n_sani
                   plant_sani = conv(plant_sani,[T_sani(n) 1]);
                end

                for n = 1:n_hudzo
                   plant_hudzo = conv(plant_hudzo,[T_hudzo(n) 1]); 
                end

                h_sani = step(Ks,plant_sani,t);
                h_hudzo = step(Ks,plant_hudzo,t);

                err_sani = rms(step_resp-h_sani');
                err_hudzo = rms(step_resp-h_hudzo');
                results(ind_noise).err_sani(it) = err_sani;
                results(ind_noise).err_hudzo(it) = err_hudzo; 
            end
        end
    end

    for k = 1:n_noise
        results(k).err_sani = results(k).err_sani(~isnan(results(k).err_sani));
        results(k).err_hudzo = results(k).err_hudzo(~isnan(results(k).err_hudzo));
        sing_sani = results(k).err_sani>=Ks;
        sing_hudzo = results(k).err_hudzo>=Ks;

        results(k).err_sani(sing_sani) = [];
        results(k).err_hudzo(sing_hudzo) = [];
        e_sani(k,1) = mean(results(k).err_sani);
        e_hudzo(k,1) = mean(results(k).err_hudzo);
    end
end
