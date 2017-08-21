% 3D data filter edge- based on gradient approach (1st order sobel)%
% No convertion from 3D to 2D for edge filtering approach
% noted to manually need to cut 2 pixel around the frame
function [edge_data] = EdgeFilter3D(data)

% -------------------------------------------------------------------- %
%                 Define edge filter- Work all area                    %
% -------------------------------------------------------------------- %
gy = [-1 -2 -1;0 0 0;1 2 1];
gx = [-1 0 1;-2 0 2;-1 0 1];
Gy = conv2(data,gy);
Gx = conv2(data,gx);
G  = sqrt(Gx.^2+Gy.^2); 

% trim out the extra noise edge first for accurate threshold 
G_tm = trim(G,5);
% Automated thresholding
[threshold]= AutoThresholding(G_tm);
edge_p = G>threshold;

% -------------------------------------------------------------------- %
% need to trim the edge to original size 270x270 after the edge filter %
% -------------------------------------------------------------------- %
edge_data = trim_bwfilter(edge_p,1,1,1,1);
% -------------------------------------------------------------------- %
% removing noise around the edge by pathching with 0 all around        %
% -------------------------------------------------------------------- %
edge_data =  trim_bwedge(edge_data,5,5,5,5);
% then sent data to regionprops
end
