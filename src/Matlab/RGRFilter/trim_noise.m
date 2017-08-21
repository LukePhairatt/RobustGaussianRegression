% Triming the noise array units(e.g. pixel)all aroung matrix of m
% and resizing the 3D data set
   % ! Z data edge meaning
   %     +y
   %     ^ 
   %     |------BOTTOM------|
   %     |                  |
   % LEFT+      3D data     +Right
   %     |                  |
   %     |-------TOP--------|------>+x
   
function [c]=trim_noise(data,top,bottom,left,right)
temp=data;
m = size(data);
%[X,Y] = meshgrid(0:1:269);

%left cut
q=0;
for j=left:-1:1 %270 pixel   
    for i=1:1:m
      temp(i,j)= data(i,left)+q;  
    end
    q=q+2.5;
end
%right cut
k=m(1,1)-right;
q=0;
for j=k:1:m %270 pixel 
    for i=1:1:m 
      temp(i,j)= data(i,k)-q;    
    end
    q=q+2.5;
end
%------Transfer old data to new data set after left-right cut
data=temp;
%top cut
q=0;
for i=top:-1:1
    for j=1:1:m %270 pixel
       temp(i,j)= data(top,j)-q;
       %temp(i,j)= interp2(X,Y,data,j,i,'cubic')+10;
    end
    q=q+0;
end
%bottom cut
k=m(1,1)-bottom;
q=0;
for i=k:1:m
    for j=1:1:m %270 pixel
       temp(i,j)= data(k,j)-q;
    end
    q=q+0;
end
%top cut
%temp(1:top,:)= [];
%bottom cut
%[m n]=size(temp);
%k=m-bottom;
%temp(k:m,:)= [];
%left cut
%temp(:,1:left)= [];
%right cut
%[m n]=size(temp);
%k=n-right;
%temp(:,k:n)= [];
c = temp;
end