function [community] = decode(AdjMatrix, g ,Over_node)
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

t=1;
c_node=[];
node=[];
for i=1:length(Over_node)
        a=Over_node(i);
        neighbours=find(AdjMatrix(a,:)==1);
        neighbours=setdiff(neighbours,Over_node); %该重叠节点所有邻居（不包括重叠序列中的节点（因为它的标签为0，-1））
    if g(Over_node(i))==0 && length(neighbours)>0 
    %if g(Over_node(i))==-1 || length(neighbours)==0     %！！！！！！                 
        Over_label=g(neighbours);
        table=tabulate(Over_label);
  
        [F,I]=max(table(:,2)); %选取出现次数最多的标签
        I=find(table(:,2)==F); 
        result=table(I,1);
        g(Over_node(i))=result(ceil(rand*length(result)));
        
    else 
        node(t)=a; %被激活(-1? or 0)的节点都收集起来
        neighbours=find(AdjMatrix(a,:)==1);            %%若是邻居也是重叠点
        neighbours=setdiff(neighbours,Over_node);
        Over_label=unique(g(neighbours)); %获取了基因 g 中这些邻居节点的标签并去重
        c_node{t}=Over_label; %重叠节点的几个标签收集起来
        t=t+1;
    end
end
if length(node)>0  
     g(node)=-1;  %多此一举？
end
t=1;
for i=1:max(g)
    if length(find(g==i))>0
    community{t}=find(g==i);
    if length(c_node)>0
       
 %{
c_node = {[1 2 3],[2 3],[1 3]};
a=cell2mat(cellfun(@(s)length(find(s==1)),c_node,'UniformOutput',false))

a =

     1     0     1
 %}

    a=cell2mat(cellfun(@(s)length(find(s==i)),c_node,'UniformOutput',false)); %map函数，作用在cell数组的每个元素
    index=find(a==1);  %所有包含标签i的重叠节点索引
    if length(index)>0
        community{t}=[community{t} node(index)];
    end
    end
    t=t+1;
    end
    
end

end

