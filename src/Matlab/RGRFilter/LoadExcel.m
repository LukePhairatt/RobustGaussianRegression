function data = LoadExcel(filename)
% Reading vector x y z from excel sheet
[num] = xlsread(filename);
% x = num(:,1)
% y = num(:,2)
% z = num(:,3)
len = size(num(:,1));

i = 1;% i= row -> vector(y)
j = 1;% j= col -> vector(x) 
% ----------------------------------------------- %
%  Transforming 3D vector data to a matrix data   %
% ----------------------------------------------- % 
% reading vector 1:len and put into matrix (i,j)
for index = 1:1:len

     if (index ~= 1) % problem with the first index 
         if(num(index,2)~= num(index-1,2))
           
           % new row
           i = i+1;
           % re-start col
           j = 1;
         end
     end
         data(i,j) = num(index,3);
         % and carry on j until end (not equal) and reset
         j = j+1;
    
    
end

end