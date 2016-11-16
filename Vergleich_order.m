close all
clear all
tu_tg_max = [103.6338e-003 218.0123e-003 319.3480e-003 410.2920e-003 493.2909e-003 570.0276e-003 641.7107e-003];
it_max = 1e3;
results = struct('err_sani',0,'err_hudzo',0);
Ks = 1;

for order = 2:8
    for it = 1:it_max
        Tk = 1*rand(1,order);
        T_conv = 1;
        for k = 1:order
           T_conv = conv(T_conv,[Tk(k) 1]); 
        end
        t = linspace(0,5*sum(Tk),1e3);
        step_resp = step(Ks,T_conv,t);
        [~,tu,tg] = wendetng(t,step_resp);
        if tu/tg <= tu_tg_max(order-1)
            [e_sani,e_hudzo] = error_plant(tu,tg,Ks,step_resp,t);
            results(order).err_sani(it) = e_sani;
            results(order).err_hudzo(it) = e_hudzo;
        end
    end
end

for ord = 2:8
    sing_s = find(results(ord).err_sani>=0.5*Ks);
    results(ord).err_sani(sing_s) = [];
    sing_h = find(results(ord).err_hudzo>=0.5*Ks);
    results(ord).err_hudzo(sing_h) = [];
    
    rms_sani(ord-1) = rms(results(ord).err_sani);
    rms_hudzo(ord-1) = rms(results(ord).err_hudzo);
end

n = 2:8;
plot(n,rms_sani,n,rms_hudzo)
legend('Fehler Sani','Fehler Hudzovic')
xlabel('Ordnung n')
ylabel('normierte Abweichung')
% set(gca,'yscale','log')
xlim([1.5 8.5])
% ylim([0.1 0.5])
grid on 
grid minor