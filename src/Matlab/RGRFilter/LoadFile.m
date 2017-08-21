function Z_Data = LoadFile(filename)

id = fopen(filename);
num_temps = fscanf(id,'%f');
fclose(id);

m = numel(num_temps);
j = 1;
for i = 1:120:m-120
   num(j,1) = num_temps(i,1);
   num(j,2) = num_temps(i+1,1);
   num(j,3) = num_temps(i+2,1);
   j=j+1;
end

n = size(num);
s = 120;
for i = 1:1:n(1)
     

end

len = numel(num(:,1));

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

%{
v = num_temps;
data= zeros(270,270);

k = 1;

% ----------------------------------------------- %
%  Transforming 3D data to a matrix data          %
% ----------------------------------------------- % 
% i= row vector, %j= col vector 
  for i=1:1:270
    for j=1:1:270    
        data(i,j)=v(k,1);
        k=k+1;
    end
  end
  
Z_Data = data;
%} 


end