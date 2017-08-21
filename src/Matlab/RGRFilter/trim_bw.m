% trim bw image
% GUI approach- [x,y] = ginput(n)
% Manual approach
temp = minmax;

% D_1_1 defect %
r = 1:105; %Y
c = 1:210; %X
temp(r,c)=0;

r = 353:386;
c = 423:500;
temp(r,c)=0;

r = 34:111;
c = 580:640;
temp(r,c)=0;

r = 430:476;
c = 356:444;
temp(r,c)=0;
