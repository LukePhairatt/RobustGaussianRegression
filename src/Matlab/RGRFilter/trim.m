% Triming the image nT unit all aroung matrix m of row and col
function [c]=trim(data,nT)
temp=data;
[mr nc]= size(data);
zr = mr-2*nT;
zc = nc-2*nT;
temp_out=zeros(zr,zc);
       for i=1:1:zr;
        for j=1:1:zc;
            temp_out(i,j) = temp(i+nT,j+nT);
        end
       end
       
c = temp_out;
end
