% =========================================================== %
%   Copyright by P.Phairatt, 8 June 2011,16.44pm              %
%                   Update 23/01/12, 15.00                    %
%            Automated defect size classification             %
% =========================================================== %

function []= DefectObjClass(filename) 

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
%          RGR PROCESSING              %
% ------------------------------------ %
 
% Before enhance image
cc_original = Data2Image(Z);
  
[w CBx Z2 W2] = RGR2_FFT(Z);


% ------------------------------------ %
%        POST RGR PROCESSING           %
% ------------------------------------ %
    
% After enhance image
cc = Data2Image(Z-w);      

% Auto- surface thresholding from surface roughness
nr = Z-w;
% Assume negative metal- find positive roughness
ind  = find(nr>0);
rg = nr(ind);
% Compensate with negative roughness
threshold = 2*sum(rg)/numel(rg);
edge_s = nr<-threshold; 

% start image application when image is clean
L = logical(edge_s);%64-bits
STATS=regionprops(L, 'Extrema', 'PixelList', 'BoundingBox', 'MajorAxisLength','MinorAxisLength','Area','Centroid');
% pick up large areas for defect prediction or using the max value to
allArea = [STATS.Area]; %1xn metrix (Area-> n x 1 matrix)
% Defect size criteria in classification 
Max_Area = 150; %pixel
% find the x-y coordinate (pixel)
L_obj = find(allArea>Max_Area);
   
% ------------------------------------------------------------- %        
% Forming new BoundingBox of main Max_Area objs/cells.          %  
% Extream edge boundary of cells in Master defect               %
% Defect by Defect classification                               %
% ------------------------------------------------------------- %

% new ObjList->merging all near by pixels to one
[ObjList Obj_n ObjCell] = ObjClass(L_obj,STATS); 


% ------------------------------------------------ %
%   Forming a new bounding box for a group defect  %
%      (Region of interest for 3D analysis)        %
% ------------------------------------------------ %
% using the round mean value (coordinates XY) to find Z from 3D data
% !take care of matrix index to real x-y plot data
% !it is on the OPPOSITE way of thinking
% !x-dis is COL and y is ROW
% !from image matrix finding Z = data(y_pixel,x_pixel)
% !locating vector out a little out of edge area for accuracy
% ! Z data coordinate convention ~ pixel convention
% ! Z data edge meaning
%     +y
%     ^ 
%     |------BOTTOM------|
%     |                  |
% LEFT+      3D data     +Right
%     |                  |
%     |-------TOP--------|------>+x

%--------------------------------------------%
%         3D Space Width x Height            % 
%--------------------------------------------%
% (3D formula d = ||(x2-x1)cross(x1-x0)||/||x2-x1|| where
% (x is a vextor of x,y,z --> [x;y;z]


for q=1:1:Obj_n    
   %  xyz at top extream data(X,Y)
   %T_XY = round(mean(ObjList(q).top_box,1));
   T_XY(1,1)= floor(min(ObjList(q).top_box(:,1)));
   T_XY(1,2)= floor(min(ObjList(q).top_box(:,2)));
   %T_Z = data(T_XY(1,2),T_XY(1,1));
   %  xyz at right extream
   %R_XY = round(mean(ObjList(q).right_box,1));
   R_XY(1,1)= floor(max(ObjList(q).right_box(:,1)));
   R_XY(1,2)= floor(max(ObjList(q).right_box(:,2)));
   %R_Z = data(R_XY(1,2),R_XY(1,1));
   %  xyz at bottom extream data(X,Y)
   %B_XY = round(mean(ObjList(q).bottom_box,1));
   B_XY(1,1)= floor(max(ObjList(q).bottom_box(:,1)));
   B_XY(1,2)= floor(max(ObjList(q).bottom_box(:,2)));
   %B_Z = data(B_XY(1,2),B_XY(1,1));
   %  xyz at left extream data(X,Y)
   %L_XY = round(mean(ObjList(q).left_box,1));
   L_XY(1,1)= floor(min(ObjList(q).left_box(:,1)));
   L_XY(1,2)= floor(min(ObjList(q).left_box(:,2)));
   %L_Z = data(L_XY(1,2),L_XY(1,1));
   % finding crossection length (sqrt[x2+y2])
   X1_pixel = sqrt((R_XY(1,1)-L_XY(1,1))^2 + (R_XY(1,2)-L_XY(1,2))^2);%pixel
   X2_pixel = sqrt((T_XY(1,1)-B_XY(1,1))^2 + (T_XY(1,2)-B_XY(1,2))^2);%pixel
   % compensation 3 pixel for small defect-> edge<200 um
   ObjList(q).X1 = X1_pixel *10+30;%micron
   ObjList(q).X2 = X2_pixel *10+30;%micron
   
   % record new Extrema in a group ObjList
   ObjList(q).Extremas(1,1) = T_XY(1,1);
   ObjList(q).Extremas(1,2) = T_XY(1,2);
   ObjList(q).Extremas(2,1) = R_XY(1,1);
   ObjList(q).Extremas(2,2) = R_XY(1,2);
   ObjList(q).Extremas(3,1) = B_XY(1,1);
   ObjList(q).Extremas(3,2) = B_XY(1,2);
   ObjList(q).Extremas(4,1) = L_XY(1,1);
   ObjList(q).Extremas(4,2) = L_XY(1,2);
end

   
% -------------------------------------------------------- %
%                  Ploting 2D and 3D data                  %
% -------------------------------------------------------- %
%3D meshplot with proper aspect ratio
set(figure(1), 'Position', [50 600 400 400])
subplot(1,1,1),plot_aspect(Z,10);
title('Defect 3D data scan');
%xlabel('X(\mum)','FontSize',10);
xlabel('X(\mum)');
ylabel('Y(\mum)');
zlabel('Z(\mum)');
%figure(1),plot_aspect(Z,10);
%2D Gray and Edge with bounding boxes
set(figure(2), 'Position', [500 600 600 400])
subplot(1,2,1),imshow(cc);
title('2D Image');
xlabel('pixel');
ylabel('pixel');
%figure(2),imshow(cc);

hold on
for q=1:1:Obj_n 
	xb = ObjList(q).Extremas(4,1);%-3;
	yb = ObjList(q).Extremas(1,2);%-3;
	wd = abs(ObjList(q).Extremas(4,1)-ObjList(q).Extremas(2,1));%+3;
	hd = abs(ObjList(q).Extremas(1,2)-ObjList(q).Extremas(3,2));%+3;
	% checking out of bound value and handle
	if (xb<0 || xb>row)
	  if (xb<0)
	      xb=0;
	  end
	  if (xb>row)
	      xb=row;
	  end
	end
	if (yb<0 || yb>col)
	  if (yb<0)
	      yb=0;
	  end
	  if (yb>col)
	      yb=col;
	  end
	end
	% Adding boxes to the image
	box = [xb,yb,wd,hd]; 
	rectangle('Position', box, 'LineWidth',1, 'EdgeColor','r');
end 
hold off

subplot(1,2,2),imshow(edge_s);
title('Preliminary defect boundary');
xlabel('pixel');
ylabel('pixel');

hold on
for q=1:1:Obj_n 
	% locating extream points- boundary boxes   
	box = [ObjList(q).Extremas(1,1),ObjList(q).Extremas(1,2),3,3];
	rectangle('Position', box, 'LineWidth',1, 'EdgeColor','r');
	box = [ObjList(q).Extremas(2,1),ObjList(q).Extremas(2,2),3,3];
	rectangle('Position', box, 'LineWidth',1, 'EdgeColor','r');
	box = [ObjList(q).Extremas(3,1),ObjList(q).Extremas(3,2),3,3];
	rectangle('Position', box, 'LineWidth',1, 'EdgeColor','r');
	box = [ObjList(q).Extremas(4,1),ObjList(q).Extremas(4,2),3,3];
	rectangle('Position', box, 'LineWidth',1, 'EdgeColor','r');
end
hold off
 
end %function


