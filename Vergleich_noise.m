close all
clear all

% Tk = [1 1 1];
noise_max = 0.3;
n_noise = 10;
it_max = 10;
for order = 2:8
    for it = 1:it_max
        Tk = 1*rand(1,order);
        T_conv = 1;
        for k = 1:order
            T_conv = conv(T_conv,[Tk(k) 1]); 
        end
        [e_sani(:,it),e_hudzo(:,it),noise] = error_noise(Tk,noise_max,n_noise);
    end
    error_sani(:,order-1) = rms(e_sani')';
    error_hudzo(:,order-1) = rms(e_hudzo')';
end

rms_sani = rms(error_sani')';
rms_hudzo = rms(error_hudzo')';

semilogy(noise,rms_sani,noise,rms_hudzo);