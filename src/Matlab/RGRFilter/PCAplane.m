function [x0, a, d, normd] = PCAplane(XYZ)
% Principle Component Analysis best fit plane
% Ax+By+Cz+D=0
% z = (-D-Ax-By)/C
% Least-squares plane (orthogonal distance regression). 
% a = Direction cosines of the normal to the best-fit plane.

% checking data format required in [X Y Z] column vector
[m n] = size(XYZ);
if n ~=3
 XYZ = XYZ';
end
 
% check number of data points 
[m] = size(XYZ, 1); 
if m < 3 
error('At least 3 data points required: ' ) 
end 

% calculate centroid 
x0 = mean(XYZ)'; 
% 
% form matrix A of translated points 
A = [(XYZ(:, 1) - x0(1)) (XYZ(:, 2) - x0(2)) (XYZ(:, 3) - x0(3))]; 
% 
% calculate the SVD of A 
[U, S, V] = svd(A, 0); 
% 
% find the smallest singular value in S and extract from V the 
% corresponding right singular vector 
[s, i] = min(diag(S)); 
 
% a Direction cosines of the normal to the best-fit plane.
a = V(:, i); 
 
% calculate residual distances, if required 
if nargout > 2 
d = U(:, i)*s; 
normd = norm(d); 
end

% solving D from known coficient -(Ax+ By+ Cz)
% a(1) = A, a(2) = B, a(3) = C then solving D

% average D from solving each nth order 

end


%{

randn('state',0);
X = mvnrnd([0 0 0], [1 .2 .7; .2 1 0; .7 0 1],50);
plot3(X(:,1),X(:,2),X(:,3),'bo');
grid on;
maxlim = max(abs(X(:)))*1.1;
axis([-maxlim maxlim -maxlim maxlim -maxlim maxlim]);
axis square
view(-23.5,5);

The cosines of the plane are the A,B,C coefficients if you are talking 
about the *normalized* plane equation.  You can determine D from 
plugging in the centroid of the data for the equation

[x y] = meshgrid(1:1:10,1:1:10);
z = -1*(D+A*x+B*y)/C;
surf(z)
%}

