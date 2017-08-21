function img = Data2Image(data_in)
  %img_data = zeros(270,270);
  [mz nz]=size(data_in);
  img_data = zeros(mz,nz);
  data_0 = data_in;
  Z_MIN = min(data_0(:));
  Z_MAX = max(data_0(:));
    for i=1:1:mz
        for j=1:1:nz
            y = data_0(i,j);
            img_data(i,j) = 255*(y-Z_MIN)/(Z_MAX-Z_MIN); 
        end
    end
   img = uint8(img_data); 
end
