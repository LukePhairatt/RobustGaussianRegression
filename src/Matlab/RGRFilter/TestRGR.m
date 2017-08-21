% =========================================================== %
%   Copyright by P.Phaithoonbuathong, 8 June 2011,16.44pm     %
%                   Update 23/01/12, 15.00                    %
%            Automated defect size classification             %
% =========================================================== %
% Revision items
% 1:Adding number to defect boxes
% 2:Classify many defects with the obj list
% 3:Z depth is from local main defect
% 4:Merging the main defect from MaxArea list to a single defect
% 5:Implementing edge filtering on 3D data directly "sobel" approach
% 6:Defect matrix of any sizes

% Comment
% Equal scaling plot
% X-Y cut
% plot([1:1:270],zero_plane(203,1:270));
% axis equal;
% Mesh Plot
% mesh(zero_plane);
% axis equal;
% Comment- Non scaling tends to exaggerate the manual selection
%          So use with care
function [Z_defect D1F D2F W1 W2 A SA V] = TestRGR(filename) 
% ----------------------------------------------- %
%  Reading 3D data- Heliotis 270x270 matrix       %
% ----------------------------------------------- %
% load data from text file
%data = LoadTxTFile(filename);

% Save data to mat file
% save('x_TB42_inclusion_tip_p1_4um.mat','data');

% load data from mat file
% filename = '16_indent_2um_3.mat'

close all;

load (filename);
Z=data;
[col row] = size(Z);

% rotate to zero
Z0 = rot_defect(Z);
% filter noise
Hd = fspecial('gaussian',[3 3],3);
Z0f = imfilter(Z0,Hd,'replicate'); 
Z = Z0f;

% ------------------------------------ %
%    3D DATA PROCESSING                %
% ------------------------------------ %
    
% 3D Edge detection filtering-based on 'sobel' operater  
    %[edge_s] = EdgeFilter3D(zero_plane);  
    [w CBx Z2 W2] = RGR2_FFT(Z);
    
end

    
    
    
    