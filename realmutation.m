%% NBM mutation used in the paper
function f = realmutation(ind,mutate_posibility,AdjMatrix,Over_node)
f=ind;
numVar=size(AdjMatrix,1);
degree=sum(AdjMatrix,1);
for j =1:numVar
    if length(find(Over_node==j))==0
        neighbours=find(AdjMatrix(j,:)==1);
        neighbours=setdiff(neighbours,Over_node);
        degree(j)=length(neighbours);
        if rand <= mutate_posibility %非重叠节点，直接当前节点的标签将传播给它的邻居节点。
            %     if rnd_uni() <= mutate_posibility
            indentifier = ind(j); %在变异概率 mutate_posibility 下，对当前节点的邻居节点进行变异，将它们的标签更新为当前节点的标签。这样，通过变异操作，
            %         negative_n = node(j).neighbours_n.size();
            for i = 1:length(neighbours)
                neighborX = neighbours(i);
                ind(neighborX) = indentifier;
            end
        end
    elseif length(find(Over_node==j))==1
%在这个部分的代码中，对于重叠节点，它首先找到该节点的邻居（不包括重叠节点本身），然后在一定的变异概率下，从邻居节点中选择一个标签，并将该标签应用于所有邻居节点。这种变异操作的效果是，对于重叠节点，其邻居节点可能会受到相同的标签影响，以增加标签的一致性。
        neighbours=find(AdjMatrix(j,:)==1);
        %neighbours=setdiff(neighbours,Over_node);
       
        if rand <= mutate_posibility %%重叠节点，直接将出现次数最多的标签传播给它的邻居节点。
            %     if rnd_uni() <= mutate_posibility
            
             neighbours=setdiff(neighbours,Over_node);
             if length(neighbours)>0
            degree(j)=length(neighbours);
            Over_label=ind(neighbours);
            table=tabulate(Over_label);
            
            [F,I]=max(table(:,2));
            I=find(table(:,2)==F);
            result=table(I,1);
            indentifier=result(ceil(rand*length(result)));
            
            
            
           
            %         negative_n = node(j).neighbours_n.size();
            for i = 1:length(neighbours)
                neighborX = neighbours(i);
                ind(neighborX) = indentifier;
            end
             end
        end
    end
end
    f(setdiff(1:numVar,Over_node))=ind(setdiff(1:numVar,Over_node));
end