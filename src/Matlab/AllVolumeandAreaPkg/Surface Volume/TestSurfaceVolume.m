%clc
%clearvars
%close all
%dbstop error
function [V totalArea] = TestSurfaceVolume(p)
% UNCOMMENT ONE OF THE FOLLOWING LINES AND RUN
% this load include data p,t and tnorm
% see below how to derive one!

% load TubularCuboidSurface.mat
% load SphereSurface.mat
% load CylinderSurface.mat
% load StubAxleSurface.mat
% load Cube_Surface.mat
% load Block_Surface.mat

% Luke- !using [tm tnorm] = ManifoldExtraction(t,p) to find tnorm
% if it is not avaliable in the data
% Calculating t (original) % see fcn in 3DSurfaceArea folder
[t]=MyCrustOpen(p);

% Recalculating t and find Tnorm % see fcn in Surface Volume
[t tnorm]=ManifoldExtraction(t,p);



V=SurfaceVolume(p,t,tnorm);

% Calcurating Area (different Author)- Dont use totalVolume, it is wrong
% use V from previous line, it is correct !
% see [totalVolume,totalArea] = stlVolume(p,t)
[totalVolume,totalArea] = stlVolume(p',t');



%close all
%figure(1)


%hold on
% set(gcf,'position',[100 100 1000 600])
set(figure(5), 'Position', [800 100 700 400])
trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','c','edgecolor','b')
axis equal
title(['Volume(um3)= ',num2str(V),' Area(um2)=',num2str(totalArea)],'Fontsize',14)

xlabel('\mum');
ylabel('\mum');
zlabel('\mum');
% cc=(p(t(:,1),:)+p(t(:,2),:)+p(t(:,3),:))/3;
% quiver3(cc(:,1),cc(:,2),cc(:,3),tnorm(:,1),tnorm(:,2),tnorm(:,3))
%hold off
end
