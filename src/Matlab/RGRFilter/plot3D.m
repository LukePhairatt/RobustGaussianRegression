% plot with good scale and big texts

function plot3D(data)
h= axes('FontSize', 20);
mesh(h,data);
axis equal
title('TB1- Plus Metal Root Tan','FontSize',20);
xlabel('X(x10\mum)','FontSize',20);
ylabel('Y(x10\mum)','FontSize',20);
zlabel('Z(\mum)','FontSize',20);

end

