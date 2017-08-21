% 3D- Robust Gaussian 2 zero order
% Optimise speed with FFT Convolution on GPU!
% -------------------------------------------------- %
% 3D Robust Gaussian- 2 Order on surface             %
% Version 2- Loop by relative error and iteration No %
% -------------------------------------------------- %
% see more info from W Zang paper- Robust gaussian regression
function [w CBx Z2 W2]= RGR2_FFT(data)
[ny nx] = size(data);
dx = 1;%0.01;
dy = 1;%0.01;
Z  = data;

% Step 1:set initialise delta = 1, and S- weight function
iterationNo = 0;                    %initialise step
delta = ones(ny,nx);                %initialise delta for new S condition
CBx = 1;
CB_old = 1;

% X-Y weighting function 
alpha = sqrt(log(2)/pi);
lamdacX = nx*dx/1;%0.2;%0.016; %cut-off freq mm
lamdacY = ny*dy/1;%0.2;%0.128; %cut-off freq mm
x = (-lamdacX:dx:lamdacX-dx)'; % generate x array
y = (-lamdacY:dy:lamdacY-dy)'; % generate y array
mx = size(x,1); % number of points along x
my = size(y,1); % number of points along y
for i = 1:mx
   for j = 1:my
   % sample the Gaussian function equation
    S(j,i) = (1/(alpha^2*lamdacX*lamdacY))*exp(-pi*(x(i)/alpha/lamdacX)^2-pi*(y(j)/alpha/lamdacY)^2);
   end
end
S=S/sum(sum(S)); % normalize to zero sum

tic;
% Step 2:solving w(x,y) of i-th iteration
   while CBx > 1e-5 
    
            % non-linear quadratic w- threshold surface 
            % Solving Numerically for w(x,y) in FFT domain
                % finding Aij
                A00 = convnfft(delta,S.*((y.^0)*(x.^0)'),'same');%A00;
                A10 = convnfft(delta,S.*((y.^0)*(x.^1)'),'same');%A10;
                A01 = convnfft(delta,S.*((y.^1)*(x.^0)'),'same');%A01;
                A20 = convnfft(delta,S.*((y.^0)*(x.^2)'),'same');%A20;
                A11 = convnfft(delta,S.*((y.^1)*(x.^1)'),'same');%A11;
                A02 = convnfft(delta,S.*((y.^2)*(x.^0)'),'same');%A02;
                A30 = convnfft(delta,S.*((y.^0)*(x.^3)'),'same');%A30;
                A21 = convnfft(delta,S.*((y.^1)*(x.^2)'),'same');%A21;
                A12 = convnfft(delta,S.*((y.^2)*(x.^1)'),'same');%A12;
                A03 = convnfft(delta,S.*((y.^3)*(x.^0)'),'same');%A03;
                A40 = convnfft(delta,S.*((y.^0)*(x.^4)'),'same');%A40;
                A31 = convnfft(delta,S.*((y.^1)*(x.^3)'),'same');%A31; 
                A22 = convnfft(delta,S.*((y.^2)*(x.^2)'),'same');%A22;
                A13 = convnfft(delta,S.*((y.^3)*(x.^1)'),'same');%A13;
                A04 = convnfft(delta,S.*((y.^4)*(x.^0)'),'same');%A04;
                
                
                % finding Fmn
                F00 = convnfft(delta.*Z,S.*((y.^0)*(x.^0)'),'same');%F00
                F10 = convnfft(delta.*Z,S.*((y.^0)*(x.^1)'),'same');%F10
                F01 = convnfft(delta.*Z,S.*((y.^1)*(x.^0)'),'same');%F01
                F20 = convnfft(delta.*Z,S.*((y.^0)*(x.^2)'),'same');%F20
                F11 = convnfft(delta.*Z,S.*((y.^1)*(x.^1)'),'same');%F11
                F02 = convnfft(delta.*Z,S.*((y.^2)*(x.^0)'),'same');%F02
                
                % solving point by point w
                for kx=1:1:nx
                    for ky=1:1:ny
                       M = [A00(ky,kx) A10(ky,kx) A01(ky,kx) A20(ky,kx) A11(ky,kx) A02(ky,kx);
                            A10(ky,kx) A20(ky,kx) A11(ky,kx) A30(ky,kx) A21(ky,kx) A12(ky,kx);
                            A01(ky,kx) A11(ky,kx) A02(ky,kx) A21(ky,kx) A12(ky,kx) A03(ky,kx);
                            A20(ky,kx) A30(ky,kx) A21(ky,kx) A40(ky,kx) A31(ky,kx) A22(ky,kx);
                            A11(ky,kx) A21(ky,kx) A12(ky,kx) A31(ky,kx) A22(ky,kx) A13(ky,kx);
                            A02(ky,kx) A12(ky,kx) A03(ky,kx) A22(ky,kx) A13(ky,kx) A04(ky,kx)];
                        
                       Q = [F00(ky,kx);
                            F10(ky,kx);
                            F01(ky,kx);
                            F20(ky,kx);
                            F11(ky,kx);
                            F02(ky,kx)];
                        
                       P = inv(M) * Q;
                       w5(ky,kx) = P(1);
                    end
                end
                
            

% Step 3: finding residual r = z-w_th
   
   r4 = Z-w5;
   %CB1 = 4.4478*median(abs(r4));       %Compute CB condition
   %CB_next = 4.4478*median(abs(CB1))/numel(CB1);%sum(CB)/numel(CB);
   CB_next = 4.4478*median(median(abs(r4)));
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
   if iterationNo>4
       break;
   end   
     
   end
  t = toc
  zm = min(min(Z));
  [ym xm] = find(Z==zm);
  % plot 3D surface 
  w = w5;
  
  % Display
  % 3D surface
  %set(figure(3), 'Position', [1150 600 700 400])
  %subplot(2,2,1),plot_aspect(Z,10);
  subplot(2,2,1),mesh(Z);
  title('Zoom Single defect zone');
  xlabel('pixel');
  ylabel('pixel');
  zlabel('\mum');


  subplot(2,2,3),mesh(w);
  title('Zoom Interporate nerve surface');
  xlabel('pixel');
  ylabel('pixel'); 
  zlabel('\mum');
  % plot 2D profile
  
  Z2 = Z(ym,1:nx);
  W2 = w(ym,1:nx);
  
  %subplot(2,2,[2 4]),plot_aspect(Z2,10,'r');
  subplot(2,2,[2 4]),mesh(r4);
  title('Normalised surface data');
  xlabel('pixel');
  ylabel('pixel'); 
  zlabel('\mum');

  
end

