%% Circumcenters tetraedroms
function [cc,r]=CCTetra(p,tetr)
%finds circumcenters from a set of tetraedroms

%points of tetraedrom
p1=(p(tetr(:,1),:));
p2=(p(tetr(:,2),:));
p3=(p(tetr(:,3),:));
p4=(p(tetr(:,4),:));

%vectors of tetraedrom edges
v21=p(tetr(:,1),:)-p(tetr(:,2),:);
v31=p(tetr(:,3),:)-p(tetr(:,1),:);
v41=p(tetr(:,4),:)-p(tetr(:,1),:);

%preallocation
cc=zeros(size(tetr,1),3);


%Solve the system using cramer method
d1=sum(v41.*(p1+p4)*.5,2);
d2=sum(v21.*(p1+p2)*.5,2);
d3=sum(v31.*(p1+p3)*.5,2);

det23=(v21(:,2).*v31(:,3))-(v21(:,3).*v31(:,2));
det13=(v21(:,3).*v31(:,1))-(v21(:,1).*v31(:,3));
det12=(v21(:,1).*v31(:,2))-(v21(:,2).*v31(:,1));

Det=v41(:,1).*det23+v41(:,2).*det13+v41(:,3).*det12;


detx=d1.*det23+...
    v41(:,2).*(-(d2.*v31(:,3))+(v21(:,3).*d3))+...
    v41(:,3).*((d2.*v31(:,2))-(v21(:,2).*d3));

dety=v41(:,1).*((d2.*v31(:,3))-(v21(:,3).*d3))+...
    d1.*det13+...
    v41(:,3).*((d3.*v21(:,1))-(v31(:,1).*d2));

detz=v41(:,1).*((v21(:,2).*d3)-(d2.*v31(:,2)))...
    +v41(:,2).*(d2.*v31(:,1)-v21(:,1).*d3)...
    +d1.*(det12);

%Circumcenters
cc(:,1)=detx./Det;
cc(:,2)=dety./Det;
cc(:,3)=detz./Det;


%Circumradius
r=realsqrt((sum((p2-cc).^2,2)));%squared radius
end












