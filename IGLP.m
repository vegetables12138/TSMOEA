function gene = IGLP(numVar,AdjMatrix,U,Over_node)


degree=single(sum(AdjMatrix,1));
if U==0 %0为标签传播
   
num=1;

gene = single(1:numVar);
a=randperm(numVar);

for n = 1 : 3    
    for  i = 1 : numVar    
        
        NeighborSize = degree(i);
        if NeighborSize == 0   
            %			gene(i) = 0;            
        else            
            if NeighborSize == 1   
                neighbours=find(AdjMatrix(a(i),:)==1);
                gene(a(i)) = gene(neighbours(1));                
            else                
%                 sum = 0;
                maxr = -1;%//record index of i's neighbour which ...
                label = -1;
                temp = 1;                
                for j = 1 : NeighborSize                   
                    counter = 1; %//record no. of nodes that has same label with j 
                    for k = j + 1 : NeighborSize 
                        p = gene(neighbours(j));
                        q = gene(neighbours(k));
                        if p == q
                            counter = counter + 1;
                        end
                    end %//end k                    
                    if temp < counter                       
                        maxr = j;
                        temp = counter;
                    end
                end %//end j                
                for l =1 : NeighborSize                    
                    u = gene(neighbours(1));
                    v = gene(i);
                    if  u == v                        
                        label = u;
                    end
                end %//end l
                if label ~= -1 && maxr == -1                    
                    gene(a(i)) = label;                   
                else                    
                    if maxr ~= -1                        
                        gene(a(i)) = gene(neighbours(maxr)); 
                        if(length(neighbours)>=3) gene(a(i))=a(i); end
                    else                       
                        randneighbor = randi(NeighborSize);
                        %randneighbor = 2;%test
                        gene(a(i)) = gene(neighbours(randneighbor));  
                        if(length(neighbours)>=3) gene(a(i))=a(i); end
                    end
                end
            end % if NeighborSize == 1 
        end % if NeighborSize == 0
    end %//end i
end %//end n
else %1为随机初始化
    gene=zeros(1,numVar);
    t=1;
    index=1;
    for i=1:numVar
     if index<=length(Over_node)&&i==Over_node(index)
         gene(i)=-(rand<=0.5); %是重叠节点的对应基因位则gene(i) 就被赋值为一个随机生成的 -1 或 0，具体取决于生成的随机数是否小于等于 0.5。
         index=index+1;
     else
        gene(i)=i;
        t=t+1;
     end
    end




end