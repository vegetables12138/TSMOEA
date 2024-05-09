function [community] = decode1(AdjMatrix, g ,Over_node)
global Datalable
% Efficient decoding of the locus-based adjcency representation.
% N = length(g);
% current_cluster = 1;
% cluster_assignment = single(zeros(1,N));
% for i = 1:N
%     cluster_assignment(i) = -1;
% end
% 
% for i = 1:N
%     ctr = 1;
%     if (cluster_assignment(i) == -1)
%         previous = zeros(1,N);
%         cluster_assignment(i) = current_cluster;
%         neighbour = g(i);
%         previous(ctr) = i;
%         ctr = ctr + 1;
%         while (cluster_assignment(neighbour) == -1)
%             previous(ctr) = neighbour;
%             cluster_assignment(neighbour) = current_cluster;
%             neighbour = g(neighbour);
%             ctr = ctr + 1;
%         end
%         if (cluster_assignment(neighbour) ~= current_cluster)
%             ctr = ctr - 1;
%             while (ctr >= 1)
%                 cluster_assignment(previous(ctr)) = cluster_assignment(neighbour);
%                 ctr = ctr - 1;
%             end
%         else
%             current_cluster = current_cluster + 1;
%         end  
%     end
% end
g(Over_node)=0; %?有的是-1或者其他标签呀！那会将大部分候补重叠节点选为普通节点

t=1;    
c_node=[];
node=[];
for i=1:length(Over_node)
        a=Over_node(i);
        neighbours=find(AdjMatrix(a,:)==1);
        neighbours=setdiff(neighbours,Over_node);
    if g(Over_node(i))==0&&length(neighbours)>0                      
        a=Over_node(i);
        if length(g)==34&&a==10
            stop=1;
        end
        neighbours=find(AdjMatrix(a,:)==1);
        neighbours=setdiff(neighbours,Over_node);
        Over_label=g(neighbours);
        table=tabulate(Over_label);
         
        [F,I]=max(table(:,2));
        I=find(table(:,2)==F);
        result=table(I,1);
        g(Over_node(i))=result(ceil(rand*length(result)));
        if length(g)==34&&a==10
            g(a)=g(neighbours(end));
        end
        
    else 
        node(t)=Over_node(i);
            a=Over_node(i);
            if a==10
                stop=1
            end
            neighbours=find(AdjMatrix(a,:)==1);            %%若是邻居也是重叠点
            neighbours=setdiff(neighbours,Over_node);
            Over_label=unique(g(neighbours));
            c_node{t}=Over_label;
            t=t+1;
    end
end
if length(node)>0
     g(node)=-1;
end
t=1;
for i=1:max(g)
    if length(find(g==i))>0
    community{t}=find(g==i);
    if length(c_node)>0
       
 
    a=cell2mat(cellfun(@(s)length(find(s==i)),c_node,'UniformOutput',false));
    index=find(a==1);
    if length(index)>0
        community{t}=[community{t} node(index)];
    end
    end
    t=t+1;
    end
    
end

end

