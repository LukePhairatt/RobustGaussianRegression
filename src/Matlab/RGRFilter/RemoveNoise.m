% above corner cut %
% ---------------- %


% start point
x1 = 66;
y1 = 1;
% end point
x2 = 184;
y2 = 270;

% slope 
m = (y2-y1)/(x2-x1);
% cut point
c = y1-m*x1;

% linear function
x = x1:1:x2;
y = m*x + c;
temp = Z;
j = 1;
% x-col
% y-row

for i = x1:1:x2
         
        temp(floor(y(j)):270,i)= NaN;
        j = j+1;
end


% next point if required
% below corner cut %
% ---------------- %
clear x;
clear y;
clear m;
clear c;


x3 = 200;
y3 = 1;
% end point
x4 = 270;
y4 = 169;

% slope 
m = (y4-y3)/(x4-x3);
% cut point
c = y3-m*x3;
% linear function
x = x3:1:x4;
y = m*x + c;
j = 1;
% x-col
% y-row

for i = x3:1:x4
         
        temp(1:floor(y(j)),i)= NaN;
        j = j+1;
end


% remove vertical lines- col
x5 = 1;
y5 = 1;
x6 = 100;
y6 = 270;
j=1;
for i = x5:1:x6
         
        temp(y5:y6,i)= NaN;
        j = j+1;
end

% remove horizontal lines- row
x7 = 101; 
y7 = 170;
x8 = 270;
y8 = 270;
for i = y7:1:y8    
        temp(i,x7:x8)= NaN;
        j = j+1;
end


% interoperate NaN values
 data=inpaint_nans(temp,1);


% Save data to mat file
 save('x_TB42_inclusion_tip_p1_4um.mat','data');

% converting matrix to vector x,y,z col
% for gridfit function
%{
clear i
clear j
x_vec = zeros(270*270,1);
y_vec = zeros(270*270,1);
z_vec = zeros(270*270,1);
kx=1;
for i=1:1:270
    for j=1:1:270
     x_vec(kx,1) = i;
     y_vec(kx,1) = j;
     z_vec(kx,1) = temp(j,i);
     kx=kx+1;
    end
end
%}
