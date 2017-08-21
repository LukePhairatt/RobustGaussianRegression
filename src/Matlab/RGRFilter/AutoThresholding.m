
% This program performs img binary using local auto threasholding %
% Calculate from standard deviation of [0 1] image range for im2bw fcn
% Copyright P.Phaithoonbuathon 7/7/11
% update 7/7/11

% Standard deviation approach

function [threshold]= AutoThresholding(region)   
    J = stdfilt(region);
    %factor is depended on gradient parameter used 
    threshold = mean(mean(J))*10;             
end
