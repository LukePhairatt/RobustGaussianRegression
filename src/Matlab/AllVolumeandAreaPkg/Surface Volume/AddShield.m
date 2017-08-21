% AddShield
function [pnew,nshield]=AddShield(p)

%adds outside points to the given cloud forming outside tetraedroms

%shield points are very good in detectinf outside tetraedroms. Unfortunatly
%delunany triangulation with these points can be even of 50% slower.

%find the bounding box
maxx=max(p(:,1));
maxy=max(p(:,2));
maxz=max(p(:,3));
minx=min(p(:,1));
miny=min(p(:,2));
minz=min(p(:,3));

%give offset to the bounding box
% step=max(abs([maxx-minx,maxy-miny,maxz-minz]));

% step=max(abs([maxx,minx,maxy,miny,maxz,minz]));

offset=5;
stepx=(maxx-minx)*offset;
stepy=(maxy-miny)*offset;
stepz=(maxz-minz)*offset;

maxx=maxx+stepx;
maxy=maxy+stepy;
maxz=maxz+stepz;
minx=minx-stepx;
miny=miny-stepy;
minz=minz-stepz;

N=4;%number of points of the shield edge

stepx=stepx/(N);%decrease step, avoids not unique points
stepz=stepz/(N);%decrease step, avoids not unique points

nshield=N*N*6;

%creating a grid lying on the bounding box
vx=linspace(minx,maxx,N);
vy=linspace(miny,maxy,N);
vz=linspace(minz,maxz,N);




[x,y]=meshgrid(vx,vy);
facez1=[x(:),y(:),ones(N*N,1)*maxz];
facez2=[x(:),y(:),ones(N*N,1)*minz];
[x,y]=meshgrid(vy,vz-stepz);
facex1=[ones(N*N,1)*maxx,x(:),y(:)];
facex2=[ones(N*N,1)*minx,x(:),y(:)];
[x,y]=meshgrid(vx-stepx,vz);
facey1=[x(:),ones(N*N,1)*maxy,y(:)];
facey2=[x(:),ones(N*N,1)*miny,y(:)];

%add points to the p array
pnew=[p;
    facex1;
    facex2;
    facey1;
    facey2;
    facez1;
    facez2];

% figure(5)
% plot3(pnew(:,1),pnew(:,2),pnew(:,3),'.g')

end








