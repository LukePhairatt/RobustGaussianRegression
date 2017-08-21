
function [edge_p]= expProcess(Z,t_plate)
B = inpaint_nans(t_plate,4);
C = Z-B;
data = abs(C);

% Automated thresholding- on local defect
cx = uint8(data);
vImage = cx(:);
m =numel(vImage);
[n xout]=hist(vImage, 1:1:m);
threshold = isodata(n, xout);
edge_p = cx>threshold;
end