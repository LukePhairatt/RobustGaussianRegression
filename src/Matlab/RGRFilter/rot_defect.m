% Created by P.Phaithoonbuathong 10 June 2011
% This function rotates the surface of any matrix size in degrees
% Active axis ZYX convention (Z-Y'-X'')
function [Z_NEW y x] = rot_defect(data) 
Z=data;
[m n]=size(Z);
% Calculating the plane angles (estimate)
% using the edge of the plane for average angle (1 and 2700 or any two points)

  % Z= Z(y,x) in matrix form
  % rot Y degree at 1
  thetaY1 = atan((Z(1,1)-Z(1,n))/(n*10));  
  % rot Y degree at row m
  thetaYm = atan((Z(m,1)-Z(m,n))/(n*10)); 
  % rot Y average angle
  thetaY = (thetaY1 + thetaYm)/2;
  
  % rot X degree at 1
  thetaX1 = -atan((Z(1,1)-Z(m,1))/(m*10)); 
  % rot X degree at col n  
  thetaXn = -atan((Z(1,n)-Z(m,n))/(m*10));
  % rot X average angle
  thetaX = (thetaX1 + thetaXn)/2;
  
    
z = 0;
y = thetaY;
x = thetaX;

R  =    [cos(z)*cos(y)  cos(z)*sin(y)*sin(x)-sin(z)*cos(x)  sin(z)*sin(x)+cos(z)*sin(y)*cos(x);
         sin(z)*cos(y)  sin(z)*sin(y)*sin(x)+cos(z)*cos(x)  sin(z)*sin(y)*cos(x)-cos(z)*sin(x);
         -sin(y)              cos(y)*sin(x)                 cos(y)*cos(x)                            ];
     
R(4,4)=0;
C = [0 0 0 0;
     0 0 0 0;
     0 0 0 0
     0 0 0 1];
 
T = R+C;
invT = inv(T);
for i=1:1:m %row
    for j=1:1:n %col
        p = [j*10;i*10;Z(i,j);1];
        pnew=invT * p; 
        Z_ort(i,j)=pnew(3,1);
    end
end

Z_NEW = Z_ort;

end %end function

