function [meanG]= dataGradient(I,res)
[h,w] = size(I);
rowC = 1:h;         rowN = [1 1:h-1];    rowS = [2:h h];
colC = 1:w;         colE = [1 1:w-1];    colW = [2:w w];

% res = xy resolution e.g 1 pixel = 2.2 um
% 2 row or 2 col = 4.4 um

% finding gradient I and trim edge of 1st and last of row and col to 0
% or [Ix,Iy] = gradient(I); without trimming
% gradient = z/x or z/y
Ix = (I(rowC,colW) - I(rowC,colE))/(2*res); Ix(:,1) = 0; Ix(:,end) = 0;
Iy = (I(rowS,colC) - I(rowN,colC))/(2*res); Iy(1,:) = 0; Iy(end,:) = 0;

% g(x,y) function = data gradient
g = (Ix.^2+Iy.^2).^(0.5);
N = numel(g); 
% finding number of NaN values
ind = find(isnan(g));
M = numel(ind);
% replace NaN with 0 for gradient calculation
g(ind)=0;

% average gradient without NaN 
meanG = sum(sum(g))/(N-M); 

end
