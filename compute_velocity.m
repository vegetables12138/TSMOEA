%% Compute new velocity and position of each particle in the population
function [velocity child] = compute_velocity(index,population,pbest,velocity,AdjMatrix,neighbors,Over_node)

global niche numVar  

 i_neighbor_index = neighbors(index,:);

 i_neighbor_chromosome = population(i_neighbor_index,:); %�ھӵĻ��������
numVar=size(population,2)-2;
niche=size(i_neighbor_chromosome,1);
child=population(index,:);
son=child;
%RandNum=ceil(rnd_uni()*niche);
RandNum=randi(niche);    %���ɾ��ȵ�α�������
NeighborBest = i_neighbor_chromosome(RandNum,:);  %�ھӼ����������

%% Calculate new velocity for the indexth particle  %�ٶȸ���
for j=1:numVar
    if pbest(index,j) == population(index,j) %��ǰ�������λ��j������ʷ�����壡��ѻ�����ͬ���ٶ�0
        v1=0;
    else
        v1=1;
    end
    if NeighborBest(j) == population(index,j) %��ǰ�������λ��j������ʷ����Ⱥ����ѻ�����ͬ���ٶ�0
        v2=0;
    else
        v2=1;
    end
    velocity(index,j) = rand*velocity(index,j)+1.494*rand*v1+1.494*rand*v2;
%     velocity(index,j) = rnd_uni()*velocity(index,j)+1.494*rnd_uni()*v1+1.494*rnd_uni()*v2;
    sigmoid = 1.0/(1.0+exp(-velocity(index,j)));
%     if rnd_uni()<sigmoid
    if rand<sigmoid
        velocity(index,j) = 1;
    else
        velocity(index,j) = 0;
    end
end

%velocity=[0 1 1 1 0 0 1];%test

%% Calculate new position for the indexth particle  %����λ�ø���
%select the dominated label indentifier
degree=sum(AdjMatrix,1);
for j=1:numVar
    neighbours=find(AdjMatrix(j,:)==1); %�϶��������Լ�
    neighbours=setdiff(neighbours,Over_node);
    degree(j)=length(neighbours);
    if velocity(index,j) == 1
        
        
        if length(find(Over_node==j))==0  %���j�����ص��ڵ���
        maxr = -1;   % //record index of i's neighbour which ...
        label = -1;
        temp = 1;
        
        %%find the most lable which is equal to temp;
        if degree(j) > 1
            %{
            most_frequent_element = mode(child(neighbours));
            most_lable = find(row_vector == most_frequent_element);
            if temp < length(most_lable)
                maxr = m;
                temp = counter;
            end
            %}
            for m = 1:degree(j) %ѡ���ִ������ı�ǩ
                counter = 1; % //record no. of nodes that has same label with j
                for k = (m + 1):degree(j) 
                    p = child(neighbours(m)); 
                    q = child(neighbours(k));
                    if p == q
                        counter=counter+1;
                    end
                end
                if temp < counter
                    maxr = m;
                    temp = counter;
                end
            end
            
            %%just  both consider the lable of j and the max_lable
            for l = 1:degree(j)
                u = child(neighbours(l));   % find other lable which is equal to the lable of j.
                v = child(j);
                if u == v                          
                    label = u;
                end
            end
            if label ~= -1 && maxr == -1   % No max_lable and find a lable in neighbours which is equal to the lable of j 
                child(j) = label;
              
            else
                if maxr ~= -1                     %find the max_lable
                    child(j) = child(neighbours(maxr)); 
        
                else                                   
                    randneighbor = randi(degree(j));
%                     randneighbor = ceil(rnd_uni()*node(j).degree);
                    child(j) = child(neighbours(randneighbor));

                end
            end
            %//end if node[i].neighbours.size() > 1
        else
            if degree(j) == 1
                child(j) =  child(neighbours(1));

            end
        end

% count=zeros(1,node(j).degree);
% for l=1:node(j).degree
%     for k=1:node(j).degree
%         if child(node(j).neighbours(l))==child(node(j).neighbours(k))
%             count(l)=count(l)+1;
%         end
%     end
% end
% [~,maxr]=max(count);
% child(j)=child(node(j).neighbours(maxr));
        
        %//end if velocity[i](j) == 1
      
                
                
        else   %?������ص���ֱ��ȡ���������⣡������
                
                child(j)=-~child(j);
                
                

        end 
    end
end

end % function
















