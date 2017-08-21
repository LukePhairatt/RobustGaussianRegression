% Manifold Extraction

function [t tnorm]=ManifoldExtraction(t,p)
%Given a set of trianlges,
%Buils a manifolds surface with the ball pivoting method.



% building the etmap

numt = size(t,1);
vect = 1:numt;                                                             % Triangle indices
e = [t(:,[1,2]); t(:,[2,3]); t(:,[3,1])];                                  % Edges - not unique
[e,j,j] = unique(sort(e,2),'rows');                                        % Unique edges
te = [j(vect), j(vect+numt), j(vect+2*numt)];
nume = size(e,1);
e2t  = zeros(nume,2,'int32');

clear vect j
ne=size(e,1);
np=size(p,1);


count=zeros(ne,1,'int32');%numero di triangoli candidati per edge
etmapc=zeros(ne,4,'int32');
for i=1:numt

    i1=te(i,1);
    i2=te(i,2);
    i3=te(i,3);



    etmapc(i1,1+count(i1))=i;
    etmapc(i2,1+count(i2))=i;
    etmapc(i3,1+count(i3))=i;


    count(i1)=count(i1)+1;
    count(i2)=count(i2)+1;
    count(i3)=count(i3)+1;
end

etmap=cell(ne,1);
for i=1:ne

    etmap{i,1}=etmapc(i,1:count(i));

end
clear  etmapc

tkeep=false(numt,1);%all'inizio nessun trinagolo selezionato


%Start the front

%building the queue to store edges on front that need to be studied
efront=zeros(nume,1,'int32');%exstimate length of the queue

%Intilize the front


         tnorm=Tnorm(p,t);%get traingles normals
         
         %find the highest triangle
         [foo,t1]=max( (p(t(:,1),3)+p(t(:,2),3)+p(t(:,3),3))/3);

         if tnorm(t1,3)<0
             tnorm(t1,:)=-tnorm(t1,:);%punta verso l'alto
         end
         
         %aggiungere il ray tracing per verificare se il triangolo punta
         %veramente in alto.
         %Gli altri triangoli possono essere trovati sapendo che se un
         %triangolo ha il baricentro più alto sicuramente contiene il punto
         %più alto. Vanno analizzati tutto i traingoli contenenti questo
         %punto
         
         
            tkeep(t1)=true;%primo triangolo selezionato
            efront(1:3)=te(t1,1:3);
            e2t(te(t1,1:3),1)=t1;
            nf=3;%efront iterato
      

while nf>0


    k=efront(nf);%id edge on front

    if e2t(k,2)>0 || e2t(k,1)<1 || count(k)<2 %edge is no more on front or it has no candidates triangles

        nf=nf-1;
        continue %skip
    end
  
   
      %candidate triangles
    idtcandidate=etmap{k,1};

    
     t1=e2t(k,1);%triangle we come from
    
   
        
    %get data structure
%        p1
%       / | \
%  t1 p3  e1  p4 t2(idt)
%       \ | /  
%        p2
         alphamin=inf;%inizilizza
          ttemp=t(t1,:);
                etemp=e(k,:);
                p1=etemp(1);
                p2=etemp(2);
                p3=ttemp(ttemp~=p1 & ttemp~=p2);%terzo id punto
        
                
         %plot for debug purpose
%          close all
%          figure(1)
%          axis equal
%          hold on
%          
%          fs=100;
%         
%          cc1=(p(t(t1,1),:)+p(t(t1,2),:)+p(t(t1,3),:))/3;
%          
%          trisurf(t(t1,:),p(:,1),p(:,2),p(:,3))
%          quiver3(cc1(1),cc1(2),cc1(3),tnorm(t1,1)/fs,tnorm(t1,2)/fs,tnorm(t1,3)/fs,'b');
%                 
       for i=1:length(idtcandidate)
               t2=idtcandidate(i);
               if t2==t1;continue;end;
                
               %debug
%                cc2=(p(t(t2,1),:)+p(t(t2,2),:)+p(t(t2,3),:))/3;
%          
%                 trisurf(t(t2,:),p(:,1),p(:,2),p(:,3))
%                 quiver3(cc2(1),cc2(2),cc2(3),tnorm(t2,1)/fs,tnorm(t2,2)/fs,tnorm(t2,3)/fs,'r');
%                
%                

               
                ttemp=t(t2,:);
                p4=ttemp(ttemp~=p1 & ttemp~=p2);%terzo id punto
        
   
                %calcola l'angolo fra i triangoli e prendi il minimo
              
                
                [alpha,tnorm2]=TriAngle2(p(p1,:),p(p2,:),p(p3,:),p(p4,:),tnorm(t1,:));
                
                if alpha<alphamin
                    
                    alphamin=alpha;
                    idt=t2;  
                    tnorm(t2,:)=tnorm2;%ripristina orientazione   
                     
                    %debug
%                      quiver3(cc2(1),cc2(2),cc2(3),tnorm(t2,1)/fs,tnorm(t2,2)/fs,tnorm(t2,3)/fs,'c');
                    
                end
                %in futuro considerare di scartare i trianoli con angoli troppi bassi che
                %possono essere degeneri
                
       end


   
   
    
    
   %update front according to idttriangle
          tkeep(idt)=true;
        for j=1:3
            ide=te(idt,j);
           
            if e2t(ide,1)<1% %Is it the first triangle for the current edge?
                efront(nf)=ide;
                nf=nf+1;
                e2t(ide,1)=idt;
            else                     %no, it is the second one
                efront(nf)=ide;
                nf=nf+1;
                e2t(ide,2)=idt;
            end
        end
        
     
        

         nf=nf-1;%per evitare di scappare avanti nella coda e trovare uno zero
end
t=t(tkeep,:);
end