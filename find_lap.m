function over_node=find_lap(AdjMatrix,u)

%候选节点过多
over_node=[];
numVar=length(AdjMatrix);
degree=sum(AdjMatrix,1);
for i=1:numVar
   %点 ni 的任意两个关键邻近子图之间的连接应该是稀疏的。找到最稀疏的两个子图然后和阈值比较
    if i==25
        stop=1; %???
    end
    neighbours=find(AdjMatrix(i,:)==1);
    if length(neighbours)==1 % 如果节点只有一个邻居，则跳过
        continue;
    end
    [C, edge] = find_subgraph(neighbours);
    len = length(over_node);
    if length(C)==1
        continue;
    end
    for j=1:length(C)
        for k=j+1:length(C)
            g1 = C{j};
            g2 = C{k};
            edges_out=0; %两个社区间的连接边数
            for h=1:length(g1)  % 统计节点在第一个社区中的邻居，然后计算外部边数
                
                n=find(AdjMatrix(g1(h),:)==1);
                edges_out=edges_out+length(intersect(n,g2));
            end
             % 根据条件判断是否将节点添加到候选重叠点列,邻居子图中的节点间没有边相连，邻居子图节点所占比例过大
            if edge(j)==0&&length(g1)/length(find(AdjMatrix(i,:)==1))>0.3||edge(k)==0&&length(g2)/length(find(AdjMatrix(i,:)==1))>=0.5
                if edges_out==0
                    over_node=[over_node i];
                    %fprintf('1:%s\n',num2str(i));
                    break;
                end
            end
             % 在两个社区都存在的情况下，根据条件判断是否将节点添加到候选重叠点列表
            if edge(j)~=0&&edge(k)~=0
                if edges_out/edge(j)<u || edges_out/edge(k)<u
               
                    
                    over_node=[over_node i];
                    break;
                end
            end
        end 

        if length(over_node)~=len
            break;
        end
    end
end

function [C,edge] = find_subgraph(neighbours)
cnt = 1;
C={};edge=[];
while length(neighbours) >= 1
    M=AdjMatrix(neighbours,neighbours);  %切出一个邻居节点矩阵
    degree_N=sum(M,1);
    [index1,index]=max(degree_N);%选择邻居中度数最大的节点 ，如果只有两个max相同就over，否则，
     % 处理度数相等的情况
    if length(find(degree_N==index1))>1
        I=degree(neighbours(find(degree_N==index1)));
        [index1,index]=max(I); %选择在整体网络中度数最大的节点
    end
    C{cnt}=[neighbours(index) neighbours(find(M(index,:)==1))];
    neighbours=setdiff(neighbours,C{cnt});  
    edge(cnt)=sum(sum(AdjMatrix(C{cnt},C{cnt})))/2;
    cnt = cnt + 1;
    if length(C) == 6
        break;
    end

end
end

end