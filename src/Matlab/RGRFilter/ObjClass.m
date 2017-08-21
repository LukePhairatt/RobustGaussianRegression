% ---------Major defect area classification --------------- %
% selecting defects and classify as major reference defects %
% serching MaxArea defect within d pixel and group into one %
% serching until the last element                           %
% --------------------------------------------------------- %

function [ObjList Obj_n L_objx] = ObjClass(L_obj,STATS)

    L_objTemp = L_obj;  
    L_objx = struct('cell',[],'Box',zeros(8,2),'TotalArea',[]);
    k=1; %start indexing of L_objTemp
    d=10; %neighbour pixel criteria
    oneDefect = numel(L_objTemp);
    n = numel(L_objTemp);

    while(n~=0) 
       %initialise data - temp storage
       Master_list = [];
       p = 1;
       %starting the new list after deleting
       n = numel(L_objTemp);
       
       if n==0
           break
       end
       
       %i = value of the index- alway start from the first of the rest (1)
       i = L_objTemp(1); % size of L_objTemp is reducing every scan
       Master_list(1,1)= i; %initial reference/start pixel
       
       % checking if single or multi defects case
       if oneDefect == 1
           % Only one defect case
           disp('one defect found');
           L_objx(1).cell(1,1) = Master_list(1,1);
           % Total area
           SumArea=STATS(Master_list(1,1)).Area;
           L_objx(1).TotalArea = SumArea;
           % continue normally only once then quit
           n = 0;    
       end
       % check if all items are searched
       if (n==0)
           break;
       end
       
       % Multiple defect case

          % Extrema (x,y)
          %   |----------------------------------->x 
          %   |----------(1,1),(1,2)-------|
          %   |                            |
          %   |(7,1),(7,2)      (3,1),(3,2)|
          %   |----------(5,1),(5,2)-------|
          %   y 
          % refer to the valus of the STATS list
          cr_right = STATS(i).Extrema(3,1);
          cr_left  = STATS(i).Extrema(7,1);
          cr_top   = STATS(i).Extrema(1,2);
          cr_btm   = STATS(i).Extrema(5,2);
       
       % checking if it is the last item or not
       if (numel(L_objTemp)==1)
           % it is the last item-no searching required
           % processing the data
           disp('At last');
           L_objx(k).cell(1,1) = Master_list(1,1);
           % Total area
           SumArea=STATS(Master_list(1,1)).Area;
           L_objx(k).TotalArea = SumArea;
           % exit loop
           n = 0;
       else
         % there is more items to scan- start from 2nd as usual
         % starting searching near by poixels
         for j=2:1:n %next to last element
          % Scanning from the one after the current
            c_right = STATS(L_objTemp(j)).Extrema(3,1);
            c_left  = STATS(L_objTemp(j)).Extrema(7,1);
            c_top   = STATS(L_objTemp(j)).Extrema(1,2);
            c_btm   = STATS(L_objTemp(j)).Extrema(5,2);
          % reset for the next search item- assume it isn't connected first 
            pixel_close_horz = 0;
            pixel_close_vert = 0;
          % checking right-left side  
            d_rr = abs(cr_right - c_right);
            d_rl = abs(cr_right - c_left);
            d_lr = abs(cr_left - c_right);
            d_ll = abs(cr_left - c_left);
            
          % Checking EITHER right or left side connected
            if(d_rr<d || d_rl<d || d_lr<d || d_ll<d)
             % one or some dimensions are met
             % it is not a connected object
               pixel_close_horz = 1;
            end
              
          % checking top-bottom side  
            d_tt = abs(cr_top - c_top);  
            d_tb = abs(cr_top - c_btm);
            d_bt = abs(cr_btm - c_top);
            d_bb = abs(cr_btm - c_btm);
          
             % Checking EITHER right or left side connected
             if(d_tt<d || d_tb<d || d_bt<d || d_bb<d)
                % end of search- a close pixel
                pixel_close_vert = 1;
             end
       
            
          %if vertical AND horizontal are connected
          %then it is a neighbour pixel
          
            if(pixel_close_vert==1 && pixel_close_horz==1)
              %neighbour pixel is satisfied-adding to the master list
                Master_list(1,p+1) = L_objTemp(j);
                p = p+1;  
              %forming the new bounding box as new the reference  
                cr_right = max(cr_right,c_right);
                cr_left  = min(cr_left,c_left);
                cr_top   = min(cr_top,c_top);
                cr_btm   = max(cr_btm,c_btm);  
            end
          
          %continue the next object in for loop
         end
         %deleting the current object and adding to the master list
         m = numel(Master_list);
         SumArea = 0;
         for jj=1:1:m       
              %ignor the first value
              %find and del from the current element
              z= find(L_objTemp(1,:)== Master_list(1,jj));
              %storage- stop while loop when size 0 ([empty])
              L_objTemp(:,z)=[];  
              %adding to the master list (L_objx.cell) defect
              L_objx(k).cell(1,jj) = Master_list(1,jj);
              %Total area
              SumArea=SumArea+STATS(Master_list(1,jj)).Area;
         end
         % Total Area of all near by pixels combined
         L_objx(k).TotalArea = SumArea;
       end 
       %the next L_objTemp scan
       k = k+1;  
    end %end while-loop


% ------------------------------------------------------------- %        
% forming new BoundingBox of main Max_Area objs/cells.          %  
% Extream edge boundary of cells in Master defect               %
% Defect by Defect classification                               %
% ------------------------------------------------------------- %
  Obj_n = numel(L_objx);
  for q=1:1:Obj_n %all object>Max size+neigbour cells
           % individual cell size contained 
           n = numel(L_objx(q).cell); 
           % Extrema box values
           temp = struct('bb', zeros(8,2));
           % Assigning Extream of each cell to temp.bb variable
            for k=1:1:n %n = elements in the current Master cell
              temp(k).bb = STATS(L_objx(q).cell(k)).Extrema;     
            end 

           %finding the boundary obj- start at 1st element
                tt = temp(1).bb(1,2);
                rr = temp(1).bb(3,1);
                bb = temp(1).bb(5,2);
                ll = temp(1).bb(7,1);
                top_obj = 1;
                bottom_obj = 1;
                right_obj = 1;
                left_obj = 1;
           for k=1:1:n 
                if tt>= temp(k).bb(1,2)     
                    tt = temp(k).bb(1,2); 
                    top_obj = k;
                end
                if bb<= temp(k).bb(5,2) 
                    bb = temp(k).bb(5,2);
                    bottom_obj = k;
                end
                if rr<= temp(k).bb(3,1)     
                    rr = temp(k).bb(3,1); 
                    right_obj = k;
                end
                if ll>= temp(k).bb(7,1)     
                    ll = temp(k).bb(7,1); 
                    left_obj = k;
                end
           end

           for i=1:1:8 %row
              switch i
                case {1, 2}
                    obj=top_obj;
                case {3, 4}
                    obj=right_obj;
                case {5, 6}
                    obj=bottom_obj;
                case {7, 8}
                    obj=left_obj;
               end
               for j=1:1:2 %col 
                    L_objx(q).Box(i,j) = temp(obj).bb(i,j);    
               end
           end
           % now all all Extrema values stored in L_objx.Box struct
  end
%end L_obj classification

 % ------------------------------------------------------------------ %
 %     Forming new bounding box: eg extreme end                       %
 %     Better rule can be co-operated                                 %
 % ------------------------------------------------------------------ %
 
 ObjList = struct('top_box',[],'right_box',[],'bottom_box',[],'left_box',[],...
                  'Extremas',zeros(4,2),'X1',[],'X2',[],'d1',[],'d2',[],...
                  'zmin',[],'xmin',[],'ymin',[],'d1_2D',[],'d2_2D',[]); 
 for q=1:1:Obj_n   
   for i=1:1:8 %row
              switch i
                case {1, 2}
                  ObjList(q).top_box = [L_objx(q).Box(1,:);L_objx(q).Box(2,:)];
                case {3, 4}
                  ObjList(q).right_box = [L_objx(q).Box(3,:);L_objx(q).Box(4,:)];
                case {5, 6}
                  ObjList(q).bottom_box = [L_objx(q).Box(5,:);L_objx(q).Box(6,:)];
                case {7, 8}
                  ObjList(q).left_box = [L_objx(q).Box(7,:);L_objx(q).Box(8,:)];
              end
   end
 end

end
