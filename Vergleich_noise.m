close all
clear all

% Tk = [1 1 1];
noise_max = 0.3;
it_max = 100;
n_noise = 500;

for order = 2:8
    for it = 1:it_max
        Tk = 1*rand(1,order);
        T_conv = 1;
        for k = 1:order
            T_conv = conv(T_conv,[Tk(k) 1]); 
        end
        [e_sani(:,it),e_hudzo(:,it),noise] = error_noise(Tk,noise_max,n_noise);
        disp(['iteration ' num2str(it) ', order ' num2str(order) ' done'])
    end
    error_sani(:,order-1) = rms(e_sani')';
    error_hudzo(:,order-1) = rms(e_hudzo')';
    error_sani_hudzo(:,order-1) = rms(e_sani'-e_hudzo')';
end

rms_sani = rms(error_sani')';
rms_hudzo = rms(error_hudzo')';
rms_sani_hudzo = rms(error_sani_hudzo')';

cd matrices
save('error_sani')
save('error_hudzo')
save('error_sani_hudzo')
save('rms_sani')
save('rms_hudzo')
save('rms_sani_hudzo')
cd ..
% semilogy(noise,rms_sani,noise,rms_hudzo);