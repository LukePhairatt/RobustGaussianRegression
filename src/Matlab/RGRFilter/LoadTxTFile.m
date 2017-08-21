function Z_Data = LoadTxTFile(filename)

id = fopen(filename);
num_temps = fscanf(id,'%f');
fclose(id);
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
  
end