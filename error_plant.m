function [error_rms,n_diff] = error_plant(tu,tg,Ks)
    T_sani = ident_sani(tu,tg,Ks);
    T_hudzo = ident_hudzovic(tu,tg,Ks);
    t = linspace(0,ceil(2.5*sum([tu tg])),1e3);
    n_sani = length(T_sani);
    n_hudzo = length(T_hudzo);
    plant_sani = 1;
    plant_hudzo = 1;

    for n = 1:n_sani
       plant_sani = conv(plant_sani,[T_sani(n) 1]);
    end

    for n =1:n_hudzo
       plant_hudzo = conv(plant_hudzo,[T_hudzo(n) 1]); 
    end

    h_sani = step(Ks,plant_sani,t);
    h_hudzo = step(Ks,plant_hudzo,t);

    error_rms = rms(h_sani-h_hudzo);
    n_diff = n_sani-n_hudzo;
    % figure('Name','Step responses')
    % plot(t,h_sani,t,h_hudzo)
    % legend('Sani','Hudzovic')
    % grid on 
    % grid minor
end

