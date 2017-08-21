% Created by P.Phaithoonbuathong 10 June 2011
% Active axis ZYX convention (Z-Y'-X'')
% x,y,z = radian
function [Z_NEW] = rot_data(data,x,y,z) 
Z=data;
[m n]=size(Z);

R  =    [cos(z)*cos(y)  cos(z)*sin(y)*sin(x)-sin(z)*cos(x)  sin(z)*sin(x)+cos(z)*sin(y)*cos(x);
         sin(z)*cos(y)  sin(z)*sin(y)*sin(x)+cos(z)*cos(x)  sin(z)*sin(y)*cos(x)-cos(z)*sin(x);
         -sin(y)              cos(y)*sin(x)                 cos(y)*cos(x)                            ];
     
R(4,4)=0;
C = [0 0 0 0;
     0 0 0 0;
     0 0 0 0
     0 0 0 1];
 
T = R+C;
for i=1:1:m %row = y axis
    for j=1:1:n %col = x axis
        p = [j;i;Z(i,j);1];
        pnew=T * p; 
        Z_ort(i,j)=pnew(3,1);
        
        % problem with 2D matrix that cannot record new x-y coor.
        % put new x-y-z point in the vector form vx vy vz
    end
end

Z_NEW = Z_ort;

end %end function

