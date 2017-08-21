%% Intersection factor
function Ifact=IntersectionFactor(tetr2t,cc,r)
nt=size(tetr2t,1);
Ifact=zeros(nt,1);%intersection factor
%it is computed from radius of the tetraedroms circumscribed sphere
% and the distance between their center
i=tetr2t(:,2)>0;
 distcc=sum((cc(tetr2t(i,1),:)-cc(tetr2t(i,2),:)).^2,2);%distance between circumcenters
  Ifact(i)=(-distcc+r(tetr2t(i,1)).^2+r(tetr2t(i,2)).^2)./(2*r(tetr2t(i,1)).*r(tetr2t(i,2)));

% for i=1:nt
%     if tetr2t(i,2)>0 %jump boundary tetraedrom
%         distcc=sum((cc(tetr2t(i,1),:)-cc(tetr2t(i,2),:)).^2,2);%distance between circumcenters
%         %intersection factor
%         Ifact(i)=(-distcc+r(tetr2t(i,1))^2+r(tetr2t(i,2))^2)/(2*r(tetr2t(i,1))*r(tetr2t(i,2)));
%     end
% end
end