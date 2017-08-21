% This function eliminate noise in noise elimination process
% by filling cells with 0

function [c]=trim_bwedge(data,top,bottom,left,right)
temp=data;
%top cut
temp(1:top,:)= 0;
%bottom cut
[m n]=size(temp);
k=(m-bottom)+1;
temp(k:m,:)= 0;
%left cut
temp(:,1:left)= 0;
%right cut
[m n]=size(temp);
k=(n-right)+1;
temp(:,k:n)= 0;
c = temp;
end