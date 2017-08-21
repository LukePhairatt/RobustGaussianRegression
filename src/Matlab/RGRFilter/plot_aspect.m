function plot_aspect(data,res,color)
  if (nargin == 3) 
     line = color;
  else 
     line = 'r';
  end
  
  % plotting in the right scale
  Z= data;
  [y x] = size(Z);
  xx = 0:res:x*res-1;
  yy = 0:res:y*res-1;
  [X,Y] = meshgrid(xx,yy); 
  
  %ZLIM(manual);
  %set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
  %hold on
  % 2D or 3D profile
  if(y==1)
      plot(xx,Z,color);
  else
  mesh(X,Y,Z);
  end
  axis equal
  %title('TB5- Inclusion Concave','FontSize',20);
  %xlabel('X(\mum)','FontSize',20);
  %ylabel('Y(\mum)','FontSize',20);
  %zlabel('Z(\mum)','FontSize',20);
  %hold off

end
