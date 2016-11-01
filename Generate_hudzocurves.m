clear all
close all

r_res = 5;
for n = 2:8
    clear H_sys Tk
    for ind = 1:n
        r(n-1,:) = linspace(0,1/(ind-1)-1e-10,r_res);
    end
    
    for k = 1:n
        Tk(:,k) = 1./(1-(k-1)*r(n-1,:));
    end

    steprep = 1;
    for ind_r = 1:r_res
        for ind = 1:n
            steprep = conv(steprep,[Tk(ind_r,ind) 1]);
        end
        H_sys(ind_r,:) = steprep;
        steprep = 1;
    end

    for ind_r = 1:r_res
        t = linspace(0,sum(Tk(ind_r,:)),1e3);
        G_sys = step(1,H_sys(ind_r,:),t);
        [~,tu(n-1,ind_r),tg(n-1,ind_r)] = wendetng(t,G_sys);
    end
end

tu_tg = tu./tg;
t_tg = 1./tg;

subplot(211)
plot(r',tu_tg')
subplot(212)
plot(r',t_tg')

