% 1D- 2nd Order Gaussian Regression Filter
% w(k,p)= Ax2 + Bx+C where x = (k-p)dx
% -------------------------------------------- %

function [w1 CBx]= RGR2_1D(data)
n = numel(data); %data points
const = sqrt(log(2)/2/pi/pi);
lambdac = 0.8; %cut-off freq mm
dx = 0.001; %sampling 1 um = 0.001 mm
x = (0:1:n-1)'*dx;  %x = 0-8mm
Z = data';


% Step 1:set delta = 1;
iterationNo = 0;                    %initialise step
delta = ones(n,1);                  %initialise delta for new S condition
CBx = 1;
CB_old = 1;
while CBx > 0.00000003 
    for k=1:n %n interval
        %for each interval k (center of the filter)
        p = (1:1:n)'; 
        %weighting function
        S = (1/sqrt(2*pi*pi)/const/lambdac).*exp(-0.5*((k-p)*dx/const/lambdac).^2);
        %normalised weight fcn
        S = S/sum(S);
    
        x = (k-p)*dx;
        M(1,1) = sum(delta.*S.*x.^0); %A0
        M(1,2) = sum(delta.*S.*x.^1); %A1
        M(1,3) = sum(delta.*S.*x.^2); %A2
        M(2,1) = M(1,2); %A1
        M(2,2) = M(1,3); %A2
        M(2,3) = sum(delta.*S.*x.^3); %A3
        M(3,1) = M(1,3); %A2
        M(3,2) = M(2,3); %A3
        M(3,3) = sum(delta.*S.*x.^4); %A4
    
        Q(1,1) = sum(delta.*Z.*S);     %F0
        Q(2,1) = sum(delta.*Z.*S.*x);  %F1
        Q(3,1) = sum(delta.*Z.*S.*x.^2);%F2
    
        P = inv(M) * Q;
        w1(k,1) = P(1);
    end
 
   % Step 3: finding residual r = z-w_th
   
   r1 = Z-w1;
   CB = 4.4*median(abs(r1));       %Compute CB condition
   CB_next = sum(CB)/numel(CB);
  % Step 4: Checking CB condition and continue with new delta
   CBx = abs((CB_old-CB_next)/CB_old);

    for j=1:1:n     
       
        if (abs(r1(j,1)/CB_next) < 1)    %check condition
            delta(j,1) = (1-(r1(j,1)/CB_next).^2).^2;
        else
            delta(j,1) = 0;
        end
    end

   CB_old  = CB_next;
   iterationNo = iterationNo+1; 
   fprintf('iteration %d\n',iterationNo);
   
   if iterationNo>29
       break;
   end
   
   
end

plot(x,Z,'r',x,w1,'g');
xlabel('Distance (mm)');
ylabel('Amplitude(\mum)');

end
