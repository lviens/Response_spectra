function [S] = RS_code(data, delta, T, xi, Resp_type)
% L. Viens 09/11/2018
% This function computes the spectral response of a time-series using the
% Duhamel integral technique.

%Inputs:
%   - data: acceleration data in the time domain
%   - delta: Sampling rate of the time-series (in Hz)
%   - T: Output period range (Example: if delta > 50 Hz: T=[0.05:0.005:0.1 0.11:0.01:0.4 0.42:0.02:0.5 0.525:0.025:0.6 0.65:0.05:1 1.1:0.1:5 5.5:0.5:10])
%   - xi: Damping factor (Standard: 5% -> 0.05)
%   - Resp_type: Response type, choose between:
%                - 'SA'  : Acceleration Spectra
%                - 'PSA' : Pseudo-acceleration Spectra
%                - 'SV'  : Velocity Spectra
%                - 'PSV' : Pseudo-velocity Spectra
%                - 'SD'  : Displacement Spectra

% Output:
%     - Response spectra in the unit specified by 'Resp_type'


if ~(strcmp(Resp_type, 'SA') || strcmp(Resp_type, 'PSA') || strcmp(Resp_type, 'SV') || strcmp(Resp_type, 'PSV') || strcmp(Resp_type, 'SD'))
	error('Resp_type is not valid (choose between SA, PSA, SV, PSV, or SD)')
end

% calculate frequency vector
dt = 1/delta;
w = 2*pi./T;

mass = 1; %  constant mass (=1)
c = 2*xi*w*mass;
wd = w*sqrt(1-xi^2);
p1 = -mass*data;

% predefine output matrices
S = zeros(size(T));
D1 = S;

% Loop over the different periods
for j=1:length(T)
    % Duhamel time domain matrix form
    I0 = 1/w(j)^2*(1-exp(-xi*w(j)*dt)*(xi*w(j)/wd(j)*sin(wd(j)*dt)+cos(wd(j)*dt)));
    J0 = 1/w(j)^2*(xi*w(j)+exp(-xi*w(j)*dt)*(-xi*w(j)*cos(wd(j)*dt)+wd(j)*sin(wd(j)*dt)));
    
    AA = [exp(-xi*w(j)*dt)*(cos(wd(j)*dt)+xi*w(j)/wd(j)*sin(wd(j)*dt)) ...
        exp(-xi*w(j)*dt)*sin(wd(j)*dt)/wd(j);...
        -w(j)^2*exp(-xi*w(j)*dt)*sin(wd(j)*dt)/wd(j) ...
        exp(-xi*w(j)*dt)*(cos(wd(j)*dt)-xi*w(j)/wd(j)*sin(wd(j)*dt))];
    
    BB = [I0*(1+xi/w(j)/dt)+J0/w(j)^2/dt-1/w(j)^2 ...
        -xi/w(j)/dt*I0-J0/w(j)^2/dt+1/w(j)^2;...
        J0-(xi*w(j)+1/dt)*I0 I0/dt];
        
    u1 = zeros(size(data));
    ud1 = u1;

    for xx = 2:length(data)
        u1(xx) = AA(1,1)*u1(xx-1)+AA(1,2)*ud1(xx-1)+BB(1,1)*p1(xx-1)+BB(1,2)*p1(xx);
        ud1(xx) = AA(2,1)*u1(xx-1)+AA(2,2)*ud1(xx-1)+BB(2,1)*p1(xx-1)+BB(2,2)*p1(xx);
    end
  
    % Spectral values
    if strcmp(Resp_type, 'SA')
        udd1 = -(w(j).^2.*u1+c(j).*ud1)-data;  % calculate acceleration
        S(j) = max(abs(udd1+data));
    elseif strcmp(Resp_type, 'PSA')
        D1(j) = max(abs(u1));
        S(j) = D1(j)*w(j)^2;
    elseif strcmp(Resp_type, 'SV')
        S(j) = max(abs(ud1));
    elseif strcmp(Resp_type, 'PSV')
        D1(j) = max(abs(u1));
        S(j) = D1(j)*w(j);
    elseif strcmp(Resp_type, 'SD')
        S(j) = max(abs(u1)); 
    end
    
end
end



