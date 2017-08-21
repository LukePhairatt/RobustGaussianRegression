
% This program performs img binary using local auto threasholding %
% Copyright P.Phaithoonbuathon 7/7/11
% update 7/7/11
function [bn]= LocalThresholding(region)

    [mx nx] = size(region); 
    
    Z_MIN = min(region(:));
    Z_MAX = max(region(:));
    for i=1:1:nx %col
        for j=1:1:mx %row
                y = region(i,j);
                in_data(i,j) = 255*(y-Z_MIN)/(Z_MAX-Z_MIN); 
        end
    end

   cc = uint8(in_data);

   wn = 50;
   for ii=1:wn:mx %row
       for jj=1:wn:nx %col
            tempx = cc(ii:(ii+wn-1),jj:(jj+wn-1));  
            vImage = tempx(:);
            [n xout]=hist(vImage, 1:1:numel(vImage));
            threshold = isodata(n, xout);
            bn(ii:ii+wn-1,jj:jj+wn-1) = cc(ii:ii+wn-1,jj:jj+wn-1)<threshold;

            
       end

   end
end
