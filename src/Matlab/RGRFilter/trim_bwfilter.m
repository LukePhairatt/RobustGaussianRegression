% This function eliminate noise in the data after using edge filtering
% by cutting extra pixel from 272x272 to 270x 270 matrix

function [c]=trim_bwfilter(data,top,bottom,left,right)
temp=data;
%top cut
temp(1:top,:)= [];
%bottom cut
[m n]=size(temp);
k=(m-bottom)+1;
temp(k:m,:)= [];
%left cut
temp(:,1:left)= [];
%right cut
[m n]=size(temp);
k=(n-right)+1;
temp(:,k:n)= [];
c = temp;
end
