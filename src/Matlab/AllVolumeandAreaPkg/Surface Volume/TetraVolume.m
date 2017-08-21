function [V]=TetraVolume(p,tetr)
%returns the squared radius for a set of tetraedrons




% %points of tetraedron
p1=(p(tetr(:,1),:));
p2=(p(tetr(:,2),:));
p3=(p(tetr(:,3),:));
p4=(p(tetr(:,4),:));

%vectors of tetraedrom edges
v21=p1-p2;
v31=p3-p1;
v41=p4-p1;




%Solve the system using cramer method

det23=(v21(:,2).*v31(:,3))-(v21(:,3).*v31(:,2));
det13=(v21(:,3).*v31(:,1))-(v21(:,1).*v31(:,3));
det12=(v21(:,1).*v31(:,2))-(v21(:,2).*v31(:,1));

V=v41(:,1).*det23+v41(:,2).*det13+v41(:,3).*det12;

V=abs(V)/6;

end