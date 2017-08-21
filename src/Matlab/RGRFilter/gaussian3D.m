function [data_out] = gaussian3D(data,d,s)
%d-defect size in pixel (e.g. 200 -400 max)
%s-amplitude percentage e.g. 50% will be removed
thresh_wind = 0.00005; %e.g. 0.00005 (smaller the better)
sigma_defect=round(((-2*log(s/100))^0.5)*d/pi); %standard deviation in the spatial domain for defect filtering
q_defect=round(sigma_defect*(-log(thresh_wind*(2*pi*sigma_defect)))^0.5);
H = fspecial('gaussian',[q_defect q_defect],sigma_defect);  % q=3 and std devn=0.5
data_out = imfilter(data,H,'replicate');
end



