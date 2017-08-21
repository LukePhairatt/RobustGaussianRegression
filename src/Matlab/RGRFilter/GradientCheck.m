% Surface gradient 
% see http://www.mathworks.com/help/techdoc/ref/gradient.html

v = -2:0.2:2;
[x,y] = meshgrid(v);
z = x .* exp(-x.^2 - y.^2);
[px,py] = gradient(z,.2,.2);
contour(v,v,z), hold on, quiver(v,v,px,py), hold off
%{
v = 1:1:91;
[x,y] = meshgrid(v);
!reading Z data first
[px,py] = gradient(Z_def,1,1);
contour(v,v,Z_def), hold on, quiver(v,v,px,py), hold off
%}

