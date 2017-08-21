% Copyright P.Phaithoonbauthong 17/01/2012,17.00
% Loughborough University
% Calculate Depth and Width perception approach
% Update with nerve surface


function [d_n1 d_n2 w1 w2 A P] = defectQuantifyCells(Z,final_bw,zx_o,zy_o)


%finding PCA vectors orientation
[angle] = PCA2DVector(final_bw,zx_o,zy_o);
theta = atan(angle)*180/pi;
bw_r = imrotate(final_bw,theta);

%work on original data size to get full data for interoperation
data_r = imrotate(Z,theta);
data_w = imrotate(w,theta);
%eliminating non interoperation data around data edge(0)
zero_r = find(data_r == 0);
data_r(zero_r) = NaN;
zero_w = find(data_w == 0);
data_w(zero_w) = NaN;


%original data bounding box- recalculate regionprops
L = logical(bw_r);
STATS = regionprops(L,'BoundingBox', 'Area', 'Perimeter'); 
bb_x1 = STATS(1).BoundingBox(1);%-5;
bb_y1 = STATS(1).BoundingBox(2);%-5;
PCA1_ln = STATS(1).BoundingBox(3);%+10;
PCA2_ln = STATS(1).BoundingBox(4);%+10;
bb_x2 = bb_x1+PCA1_ln;
bb_y2 = bb_y1+PCA2_ln;

xPCA1_ln = 0.2 * PCA1_ln;
xPCA2_ln = 0.2 * PCA2_ln;

% find lowest single point- only one point
% for X-cut(PCA2 axis) and Y-cut(PCA1 axis)
[r c] = find(data_r == min(min(data_r)));
z_y = r(1);
z_x = c(1);
z_min = data_r(z_y,z_x);
% find highest single point
[r c] = find(data_r == max(max(data_r)));
z_ym = r(1);
z_xm = c(1);
z_max = data_r(z_ym,z_xm);


% Extracting defect profile X-Y at the lowest point
% PCA1-cut Y=constant, fix row, + 20% edge data
Y = z_y;
X = floor(bb_x1-xPCA1_ln):floor(bb_x2+xPCA1_ln);
Z_2DX = data_r(Y,X);
BW_2DX = bw_r(Y,X);
W_2DX = data_w(Y,X);

% Eliminating out of bound values (NaN) if present
% (delete)
% finding data start-end profile for calculation (from bw data)
temp2 = find(BW_2DX == 1);
nl1 = temp2(1);
nl2 = temp2(numel(temp2));

hold on
plot(Z_2DX,'r');
plot(W_2DX,'g');
plot(nl1,Z_2DX(nl1),'o');
plot(nl2,Z_2DX(nl2),'o');
hold off

% finding gradient only above threshold (near 0)



% defining Cr depth- Method: from provisional depth
diff = floor(abs(z_max-z_min)*0.5);
    % positive and negative metal
    if(z_min <= 0)
        cr = diff;
    else
        cr = -diff;
    end


temp = find(Z_2DX < z_min+cr);
%first below point
cr_1 = temp(1);
%last below point
cr_2 = temp(numel(temp));

%Flag error if cr_1==1 and cr_2==end of the profile

figure,plot(Z_2DX)
title('PCA1 Axis cross-section profile');
hold on
% least square regression line (best fit)
% line-p1
xf1=1:floor(nl1);
zf1=Z_2DX(1,xf1);
p1 = polyfit(xf1,zf1,1);
p1p = 1:nl1+5;
plot(p1p,p1(1)*p1p+p1(2),'r');
% line-p2
xf2=floor(nl1):cr_1;
zf2=Z_2DX(1,xf2);
p2 = polyfit(xf2,zf2,1);
p2p = nl1-5:cr_1;
plot(p2p,p2(1)*p2p+p2(2),'r');

% p1-p2 intersect point
% x = (c2-c1)/(m1-m2)
c12_x = (p2(2)-p1(2))/(p1(1)-p2(1));
c12_y = p1(1)*c12_x + p1(2);



% line-p3
xf3=cr_2:floor(nl2);
zf3=Z_2DX(1,xf3);
p3 = polyfit(xf3,zf3,1);
p3p = cr_2:floor(nl2)+5;
plot(p3p,p3(1)*p3p+p3(2),'r');

% line-p4

xf4=floor(nl2):floor(numel(Z_2DX));
zf4=Z_2DX(1,xf4);
p4 = polyfit(xf4,zf4,1);
p4p = floor(nl2)-5:floor(numel(Z_2DX));
plot(p4p,p4(1)*p4p+p4(2),'r');


% p3-p4 intersect point
% x = (c4-c3)/(m3-m4)
c34_x = (p4(2)-p3(2))/(p3(1)-p4(1));
c34_y = p3(1)*c34_x + p3(2);

% finding lowest point in PCA1 plane
z_min = min(Z_2DX);
x_min = find(Z_2DX == min(Z_2DX));

plot(c12_x,c12_y,'ro',c34_x,c34_y,'ro',x_min,z_min,'ro')

hold off

% Calculating norm distance in plane (set z=0)
  %Z first
  xx1 = [c12_x*10;c12_y;0];
  %Z lowest
  xx0 = [x_min(1)*10;z_min(1);0];
  %Z second
  xx2 = [c34_x*10;c34_y;0];
  d_n1 = norm(cross((xx2-xx1),(xx1-xx0)))/norm(xx2-xx1);
  
  

% ========================================== %
% PCA2 Section-  X=constant, fix col

Y2 = floor(bb_y1-xPCA2_ln):floor(bb_y2+xPCA2_ln);
X2 = z_x;
Z_2DY_ALL = data_r(Y2,X2);
Z_2DY_ALL = Z_2DY_ALL';
BW_2DY_ALL = bw_r(Y2,X2);
BW_2DY_ALL = BW_2DY_ALL';
% Eliminating out of bound value (NaN)
outy = isnan(Z_2DY_ALL);
Z_2DY = Z_2DY_ALL(outy~=1);
BW_2DY = BW_2DY_ALL(outy~=1);

% finding linear regression line fit points (from bw data)
clear temp;
clear temp2;
clear nl1;
clear nl2;

temp2 = find(BW_2DY == 1);
nl1 = temp2(1);
nl2 = temp2(numel(temp2));

temp = find(Z_2DY < z_min+cr);
%first below point
cr_1 = temp(1);
%last below point
cr_2 = temp(numel(temp));

figure,plot(Z_2DY)
title('PCA2 Axis cross-section profile');
hold on
% least square regression line (best fit)
% line-p5
yf5=1:floor(nl1);
zf5=Z_2DY(1,yf5);
p5 = polyfit(yf5,zf5,1);
p5p = 1:nl1+5;
plot(p5p,p5(1)*p5p+p5(2),'r');
% line-p6
yf6=floor(nl1):cr_1;
zf6=Z_2DY(1,yf6);
p6 = polyfit(yf6,zf6,1);
p6p = nl1:cr_1;
plot(p6p,p6(1)*p6p+p6(2),'r');

% p5-p6 intersect point
c56_x = (p6(2)-p5(2))/(p5(1)-p6(1));
c56_y = p5(1)*c56_x + p5(2);



% line-p7
yf7=cr_2:floor(nl2);
zf7=Z_2DY(1,yf7);
p7 = polyfit(yf7,zf7,1);
p7p = cr_2:floor(nl2)+5;
plot(p7p,p7(1)*p7p+p7(2),'r');

% line-p8
yf8=floor(nl2):floor(numel(Z_2DY));
zf8=Z_2DY(1,yf8);
p8 = polyfit(yf8,zf8,1);
p8p = floor(nl2)-5:floor(numel(Z_2DX));
plot(p8p,p8(1)*p8p+p8(2),'r');
 
% p7-p8 intersect point
c78_x = (p8(2)-p7(2))/(p7(1)-p8(1));
c78_y = p7(1)*c78_x + p7(2);

% finding lowest point in PCA1 plane
z_min = min(Z_2DY);
y_min = find(Z_2DY == min(Z_2DY));

plot(c56_x,c56_y,'ro',c78_x,c78_y,'ro',y_min,z_min,'ro')
hold off


% Calculating norm distance in plane (set z=0)
  %Z first
  xx1 = [c56_x*10;c56_y;0];
  %Z lowest
  xx0 = [y_min(1)*10;z_min(1);0];
  %Z second
  xx2 = [c78_x*10;c78_y;0];
  d_n2 = norm(cross((xx2-xx1),(xx1-xx0)))/norm(xx2-xx1);


% 3D length between 2 points!
% Calculating norm distance in 3D space- through CG planes
% finding CG
  [y,x]=find(bw_r>0.5);
  cgx = round(mean(x));
  cgy = round(mean(y));
  
% width along PCA1- fixed row - fix y
  x1 = [round(bb_x1)*10;round(cgy)*10;data_r(round(cgy),round(bb_x1))];
  x2 = [round(bb_x2)*10;round(cgy)*10;data_r(round(cgy),round(bb_x2))];
  dp = (x2-x1).^2; 
  w1 = sqrt(sum(dp));
% width along PCA2- fix col- fix x
  x1 = [round(cgx)*10;round(bb_y1)*10;data_r(round(bb_y1),round(cgx))];
  x2 = [round(cgx)*10;round(bb_y2)*10;data_r(round(bb_y2),round(cgx))];
  dp = (x2-x1).^2; 
  w2 = sqrt(sum(dp));
  
  
% 2D Parameter
% Area- um x um
A = STATS(1).Area*10*10;
% Perimeter- um
P = STATS(1).Perimeter*10;
  
  
  
  
  
  
  
end