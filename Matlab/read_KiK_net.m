
% Read KiK-net data
% Input: 
% Output:
%     - h: detrend/demean data time series
%     - t: Time series 

function [h, t, delta] = read_KiK_net(filename)

[x1, x2, x3, x4, x5, x6, x7, x8] = importfile_KiK_net(filename);
[~,~,VarName3,~] = importfile_KiK_header(filename);

fac_str = VarName3{14};
fac = str2num(strrep(fac_str,'(gal)',''));

del = VarName3{11};
delta = str2num(strrep(del,'Hz',''));

x=[x1,x2,x3,x4,x5,x6,x7,x8];

k=1;
for j=1:length(x1)
    for i=1:8
        h(k,:)=x(j,i);
        k=k+1;
    end
end
h(isnan(h)) = [];
h = detrend(h);
h = h-mean(h);

t = 0: 1/delta:length(h)/delta -1/delta;
h = h.*fac;

h = detrend(h);
h = h - mean(h);