% L. Viens 09/11/2018
% Example of response spectra 
% The code reads 3 KiK-net data files using the read_KiK_net.m function and
% uses the function in RS_code.m to compute the response spectra.
% The KiK-net data are the waveforms of the 2011 Tohoku-Oki earthquake
% recorded at the surface by the TKYH12 station:
%      NS2 -> Surface North-South component
%      EW2 -> Surface East-West component
%      UD2 -> Surface Up-Down component
%
% The following variables can be changed:
%   - Resp_type: Response type, choose between:
%                - 'SA'  : Acceleration Spectra (Default)
%                - 'PSA' : Pseudo-acceleration Spectra
%                - 'SV'  : Velcity Spectra
%                - 'PSV' : Pseudo-velocity Spectra
%                - 'SD'  : Displacement Spectra
%   - T: Period vector
%   - xi: Damping factor (0.05 -> 5%)

clear all
close all
clc

addpath('../Data')
% Components of the ground motion
components = {'NS2' ; 'EW2' ; 'UD2'};

% Parameters of the response spectra
Resp_type = 'SV';
T = [0.05:0.005:0.1 0.11:0.01:0.4 0.42:0.02:0.5 0.525:0.025:0.6 0.65:0.05:1 1.1:0.1:5 5.5:0.5:10];
xi = .05;

% Define size of the output response spectra matrix
Sfin = zeros(3, length(T));

% Loop over the NS, EW, and UD components, read the KiK-net data and
% compute the response spectra.
for i = 1 : length(components)
    [data(i,:), t, delta] = read_KiK_net(['./TKYH121103111446.' components{i}] );
    [Sfin(i,:)] = RS_code(data(i,:), delta, T, xi, Resp_type);
end


figure
% Plot acceleration waveforms
subplot(2,1,1)
for i = 1 : length(components)
    plot(t,data(i,:)+ (i-1) * 200) 
    hold on
end
grid on
title({'2011/03/11 - 14:46, Mw 9.0 Tohoku-Oki Earthquake' ; 'TKYH12 KiK-net station' })
legend(cell2mat(components))
ylabel('Acceleration (cm/s/s)')
xlabel('Time (s)')
set(gca, 'fontsize' , 12)



% Plot response spectra
subplot(2,1,2)
semilogy(T,Sfin, 'linewidth', 2)
grid on

legend(cell2mat(components))
title({['Damping = ' num2str(xi*100) ' %'] })

if strcmp(Resp_type,'SA')
    ylabel('Acceleration response (cm/s/s)')
    ylim([1 1000])
elseif  strcmp(Resp_type,'SV')
    ylabel('Velocity response (cm/s)')
    ylim([.1 100])
else
    ylabel(Resp_type)
end
xlabel('Period (s)')

set(gca, 'fontsize' , 12)
