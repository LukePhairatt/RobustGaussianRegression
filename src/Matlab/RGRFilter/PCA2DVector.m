
function [m2] = PCA2DVector(final_bw,zx_o,zy_o)

bw = final_bw;
L = regionprops(logical(bw), 'BoundingBox');
%point(x,y)
Lx = L(1).BoundingBox(1);
Ly = L(1).BoundingBox(2);
%w in x and length in y direction
Lw = L(1).BoundingBox(3);
Lh = L(1).BoundingBox(4);

[rowY colX] = size(bw);


[y,x]=find(bw>0.5);    %get coordinates of non-zero pixels

%1-mean centroid
%centroid=mean([x y]); %Get (centroid) of data 

%2-centroid from lowest depth
centroid(1) = zx_o;
centroid(2) = zy_o;



C=cov([x y]);           %calculate covariance of coordinates
[U,S]=eig(C);           %Find principal axes and eigenvalues

%Plot the principal axes                                                                
m=U(2,1)./U(1,1);                                                     	
const=centroid(2)-m.*centroid(1);

%PCA lines from x range
if(floor(Lx)-5<1)
    x_start = 1;
else 
    x_start = floor(Lx)-5;
end

if(x_start+Lw+5> colX)
    x_end = colX;
else
    x_end = x_start+Lw+5;
end

%Display
%figure, imshow(bw,[]); 
subplot(2,2,[1 3]),imshow(bw,[]);
title('Principal axes');
hold on
xl = x_start:x_end;
yl=m.*xl+const;
h=line(xl,yl);                                   %Display.......
set(h,'Color',[1 0 0],'LineWidth',2.0)
m2=U(2,2)./U(1,2);
const=centroid(2)-m2.*centroid(1);

x2=x_start:x_end; 
y2=m2.*x2+const;
h=line(x2,y2); 
set(h,'Color',[0 1 0],'LineWidth',2.0)

% Display
plot(centroid(1),centroid(2),'*');            %Plot shape centroid

hold off
end
