function [w] = RGR0(data)
% -------------------------------------------------- %
% 3D Robust Gaussian- Zero Order on surface          %
% Version 2- Loop by relative error and iteration No %
% -------------------------------------------------- %
% see more info from W Zang paper- Robust gaussian regression
Z = data;

[ny nx] = size(Z);
const = sqrt(log(2)/2/pi/pi);
lambdax = 0.25;%0.4; %cut-off freq mm
lambday = 0.25;%0.2; %cut-off freq mm
dx = 0.01;
dy = 0.01;
%[X,Y] = meshgrid(0:0.01:2.70-0.01,0:0.01:2.70-0.01);

% Step 1:set delta = 1;
iterationNo = 0;                    %initialise step
delta = ones(ny,nx);                  %initialise delta for new S condition
CBx = 1;
CB_old = 1;
% Step 2:solving w_th

%hold on
while CBx > 0.00000003   
   for kx = 1:1:nx
       for ky = 1:1:ny
            px = 1:1:nx;
            py = 1:1:ny;
            %weighting function
            S = (1/sqrt(2*pi)/const^2/lambdax/lambday).* [[exp(-0.5*((py-ky)*dy/const/lambday).^2)]' *[exp(-0.5*((px-kx)*dx/const/lambdax).^2)]];
            SMOD = S/sum(sum(S));
            w4(ky,kx) = sum(sum(SMOD.*Z.*delta))/sum(sum(SMOD.*delta));

       end
   end
   
% Step 3: finding residual r = z-w_th
   
   r4 = Z-w4;
   CB = 4.4*median(abs(r4));       %Compute CB condition
   CB_next = sum(CB)/numel(CB);

% Step 4: Checking CB condition and continue with new delta
   CBx = abs((CB_old-CB_next)/CB_old);
   for i=1:1:nx
      for j=1:1:ny     
       
        if (abs(r4(j,i)/CB_next) < 1)    %check condition
            delta(j,i) = (1-(r4(j,i)/CB_next).^2).^2;
        else
            delta(j,i) = 0;
        end
      end
   end
   CB_old  = CB_next;
   
   iterationNo = iterationNo+1; 
   fprintf('iteration %d\n',iterationNo);
   if iterationNo>9
       break;
   end
   %imshow(Z<w4);
   %pause(2);
end
%hold off
w = w4;
end







