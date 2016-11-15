close all
clear all
tu_tg_max = [103.6338e-003 218.0123e-003 319.3480e-003 410.2920e-003 493.2909e-003 570.0276e-003 641.7107e-003];
it_max = 100;
results = struct('err_rms',0,'n_diff',0);
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
            [e_rms,n_diff] = error_plant(tu,tg,Ks);
            results(order).err_rms(it) = e_rms;
            results(order).n_diff(it) = n_diff;
        end
    end
end

for ord = 2:8
    sing = find(results(ord).err_rms>=0.5*Ks);
    results(ord).err_rms(sing) = [];
    mean_error(ord-1) = mean(results(ord).err_rms);
end

n = 2:8;
scatter(n,mean_error)
set(gca,'yscale','log')
xlim([1.5 8.5])
grid on 
grid minor