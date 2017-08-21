% MyCrustOpen
% 
% 
% This version has been developped for open surface with no sharp edges. 
% 
% Differently from crust based algorithm does not ensure a tight
%   triangluation and sometimes self-intersecant triangles are generated,
%   it is also generally slower. The final surface may need some repair
%   work which this utilitie does not offer.
% 
% But there are two great advantages, this one can be applied on any kind
%   of open surface for which the Crust fails, supports not regular surface
%   like the Moebius ribbon, and most of all, the surface can have any kind
%   of holes, open feature shouldn't create problem.
% You can see   the demo models for examples.
% 
% If any problems occurs in execution, or if you found a bug, have a
%   suggestion or question just contact me at:
% 
% giaccariluigi@msn.com
% 
% 
% 
% Here is a simple example:
% 
% load Nefertiti.mat%load input points from mat file
% 
% [t]=MyCrustOpen(p);
% 
% figure(1)
%         hold on title('Output Triangulation','fontsize',14) axis equal
%         trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','c','edgecolor','b')
% 
% Input:
%              p is a Nx3 array containing the 3D set of points
% Output:
%              t are points id contained in triangles nx3 array .
% 
% See also qhull, voronoin, convhulln, delaunay, delaunay3, tetramesh.
% 
% Author:Giaccari Luigi
% Last Update: 28/01/2009
% Created: 15/4/2008
%
%
% This work is free thanks to our sponsors and users graditude:
% 
% <a href="http://www.wordans.com/affiliates/?s=2664&amp;a=904">-WORDANS: Make you own T-Shirt</a>	
% 
% <a href="http://www.odicy.com/affiliates/?s=2662&amp;a=903">-ODICY: affordable luxury made easy</a>
% 
% <a href="http://www.gigasize.com/affiliates/?s=2665&amp;a=902">-GIGASIZE: the easiest way to upload and share files</a>
% 
% <a href="http://www.advancedmcode.org/">-Advanced M-code</a>
% 
% <a
% href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_i d=8412682">-Donate </a>
% 
% Thank you!
%


function [t]=MyCrustOpen(p)
%error check

if nargin>1
    error('The only input must be the Nx3 array of points');
end

[m,n]=size(p);
if n ~=3
    error('Input 3D points must be stored in a 3D array');
end 
clear m n


%%   Main

starttime=clock;


%add points to the given ones, this is usefull
%to create outside tetraedroms
tic
[p,nshield]=AddShield(p);
fprintf('Added Shield: %4.4f s\n',toc)


%delaunay 3D triangulation
tic
tetr=delaunayn(p);%creating tedraedron
tetr=int32(tetr);%save memory
fprintf('Delaunay Triangulation Time: %4.4f s\n',toc)

%Get connectivity relantionship among tetraedroms
tic
[tetr2t,t2tetr,t]=Connectivity(tetr);
fprintf('Connectivity Time: %4.4f s\n',toc)


%get Circumcircle of tetraedroms
tic
[cctetr,rtetr]=CCTetra(p,tetr);
fprintf('Circumcenters Tetraedroms Time: %4.4f s\n',toc)


%Get  intersection factor
tic
Ifact=IntersectionFactor(tetr2t,cctetr,rtetr);
fprintf('Intersection factor Time: %4.4f s\n',toc)

clear tetr tetr2t cctetr rtetr




%extract the manifold

tic
tkeep=Walking(p,t,Ifact);
fprintf('Walking Time: %4.4f s\n',toc)


%final traingulation
t=t(tkeep & all(t<=size(p,1)-nshield,2),:);%delete shield triangles


tic
t=ManifoldExtraction(t,p);
fprintf('Manifold extraction Time: %4.4f s\n',toc)



time=etime(clock,starttime);
fprintf('Total Time: %4.4f s\n',time)



end






