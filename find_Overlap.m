function Over_node=find_Overlap(AdjMatrix,u)

numVar=size(AdjMatrix,1);
for i=1:numVar
    node(i).neighbours=find(AdjMatrix(i,:)==1);
    node(i).degree=length(node(i).neighbours);
end
degree=sum(AdjMatrix,1);
K=[];
%
%% 思想：随机从邻居中选取个点判断是否和他邻居的点相连
Over_node=[];
for i=1:numVar
    a_neighbours=node(i).neighbours;
%     a=ceil(rand()*node(i).degree);
 [~,index]=max(degree(a_neighbours));
    
    a=a_neighbours(index);
    Matrix=AdjMatrix(a_neighbours,a_neighbours);
    degree_matrix=sum(Matrix,1);
    [~,index]=max(degree_matrix);
    a=a_neighbours(index);
    link=find(AdjMatrix(a,a_neighbours)==1);
    
    if length(link)==0
        Over_node=[Over_node i];
    else
        link=find(AdjMatrix(a,a_neighbours)==0);
        b_No_link=a_neighbours(link);
        M=AdjMatrix(b_No_link,b_No_link);
      
        
        m=sum(sum(M))/2;
        K=[K m];
        if m/length(M)>=u
          Over_node=[Over_node i];
        end
    end
end
Over_node=setdiff(Over_node,find(degree==1));
end














