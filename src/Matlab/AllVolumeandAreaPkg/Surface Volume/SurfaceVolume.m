function V=SurfaceVolume(p,t,tnorm)
% Gets the Volume enclosed by the surface defined by p,t,tnorm.
% All we need is to compute the volume of 3 tetraedrons for each triangle.
% 
% Input:
%    p: nx3 array containing 3D set of points
%    t: triangles ids referring to p array. First points flagged as one.
%    tnorm: outwards traignles normals orientation
%    
% Output:
%  
%     V: the Volume enclosed by the surface    
%     
% For bugs,infos: giaccariluigi@msn.com
% Visit: http://giaccariluigi.altervista.org/blog/
% 
% This work is free thanks to users gratitude. If you find it usefull please 
% consider making a donation on my website.


%Errors check
[np,m]=size(p);
if m ~=3
    error('Only 3D points supported')
end

[m]=size(t,2);
if m ~=3
    error('t must be a nx3 array')
end

[m]=size(tnorm,2);
if m ~=3
    error('tnorm must be a nx3 array')
end

m=max(t(:));
if m ~=np
    error('Invalid triangles array')
end


minz=min(p(:,3));


%traslo in alto la figura in modo da evitare intersezioni con il piano xy
p(:,3)=p(:,3)-minz+1;

%proietto e duplico i punti sul piano xy
p=[p;[p(:,1:2),zeros(np,1)]];

 %[t(:,[1,3]),t(:,[2,3]+np); t(:,[1,3]),t(:,[2,3]+np)]

ntetr=size(t,1);

%trovo le normali che puntano in alto
ind=tnorm(:,3)>0;

%FIrst set of tetraedrons
cutsize=100000;
i1=1;i2=cutsize;
v=zeros(ntetr,1);
V=zeros(ntetr,1);

tetr=[t+np,t(:,1)];
while i2<ntetr
[V(i1:i2)]=TetraVolume(p,tetr(i1:i2,:));
i1=i1+cutsize;
i2=i2+cutsize;
end
%last is special
[V(i1:end)]=TetraVolume(p,tetr(i1:end,:));


V(~ind)=-V(~ind);


%Second set of tetraedrons

i1=1;i2=cutsize;



tetr=[t(:,[1,3]),t(:,[2,3])+np];
while i2<ntetr
[v(i1:i2)]=TetraVolume(p,tetr(i1:i2,:));
i1=i1+cutsize;
i2=i2+cutsize;
end
%last is special
[v(i1:end)]=TetraVolume(p,tetr(i1:end,:));

V(ind)=V(ind)+v(ind);
V(~ind)=V(~ind)-v(~ind);


%third set of tetraedrons

i1=1;i2=cutsize;



tetr=[t,t(:,2)+np];
while i2<ntetr
[v(i1:i2)]=TetraVolume(p,tetr(i1:i2,:));
i1=i1+cutsize;
i2=i2+cutsize;
end
%last is special
[v(i1:end)]=TetraVolume(p,tetr(i1:end,:));

V(ind)=V(ind)+v(ind);
V(~ind)=V(~ind)-v(~ind);



%get the sum

V=sum(V);



end


