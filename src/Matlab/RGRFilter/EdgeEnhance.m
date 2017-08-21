% This function enhances edge detection on the curve surface by flating 
% the plane using guassian plane subtraction from original
% geometry is a true size by first rotating the plane before substraction
% !region rotation can be done with the same rot_surface function

function sub_plane = EdgeEnhance(data_in)
Z = data_in;
ref_plane = gaussian3D(Z,25,3); % was 25,5
Hd = fspecial('gaussian',[5 5],2);
def_plane = imfilter(Z,Hd,'replicate');
sub_plane= def_plane- ref_plane;
end