%% Connectivity

function [tetr2t,t2tetr,t]=Connectivity(tetr)
%Finds ptest for delaunay criterion and tetredral connectivity




numt = size(tetr,1);
vect = 1:numt;
t = [tetr(:,[1,2,3]); tetr(:,[2,3,4]); tetr(:,[1,3,4]);tetr(:,[1,2,4])];
[t,j,j] = unique(sort(t,2),'rows');
t2tetr = [j(vect), j(vect+numt), j(vect+2*numt),j(vect+3*numt)];


% triang-to-tetr connectivity
% Each row has two entries corresponding to the triangle numbers
% associated with each edge. Boundary edges have e2t(i,2)=0.
nume = size(t,1);
tetr2t  = zeros(nume,2,'int32');
count= ones(nume,1,'int32');
for k = 1:numt

    for j=1:4
        ce = t2tetr(k,j);
        tetr2t(ce,count(ce)) = k;
        count(ce)=count(ce)+1;
    end

end


end      % connectivity()




