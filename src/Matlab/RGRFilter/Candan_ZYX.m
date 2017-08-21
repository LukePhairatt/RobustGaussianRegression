%% fix rotation XYZ = current rotation ZYX
% ZYX =  c1c2  c1s2s3-s1c3  s1s3+c1s2c3
%        s1c2  s1s2s3+c1c3  s1s2c3-c1s3
%        -s2   c2s3         c2c3
%       --------------------------------
%        c(z)c(y)  c(z)s(y)s(x)-s(z)c(x)  s(z)s(x)+c(z)s(y)c(x)
%        s(z)c(y)  s(z)s(y)s(x)+c(z)c(x)  s(z)s(y)c(x)-c(z)s(x)
%        -s(y)     c(y)s(x)               c(y)c(x)
%%

y = -2*pi/180;
z =   0*pi/180;
x = -4.5*pi/180;

C  =    [cos(z)*cos(y)  cos(z)*sin(y)*sin(x)-sin(z)*cos(x)  sin(z)*sin(x)+cos(z)*sin(y)*cos(x);
         sin(z)*cos(y)  sin(z)*sin(y)*sin(x)+cos(z)*cos(x)  sin(z)*sin(y)*cos(x)-cos(z)*sin(x);
         -sin(y)              cos(y)*sin(x)                 cos(y)*cos(x)                    ];

     
w3 = C(3,1);
w2 = C(2,1);
w1 = C(1,1);

yy = -asin(w3)
zz = asin (w2/cos(yy));
if(w1>=0)
    zz = zz
else
    zz = pi - zz
end

u3 = C(3,2);
v3 = C(3,3);

xx = asin(u3/cos(yy));

if(v3>=0)
    xx = xx
else
    xx = pi - xx
end
%reverse checking%
q = [0.5;0;0];
qd = C*q;
r = [0;0;0.5];
rd = C*r;

u = qd;
v = rd;
w = cross(v,u);
norm_u = u/norm(u);
norm_v = v/norm(v);
norm_w = w/norm(w);
CC = [norm_u norm_w norm_v];





