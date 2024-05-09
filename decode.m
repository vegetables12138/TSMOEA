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
        neighbours=setdiff(neighbours,Over_node); %���ص��ڵ������ھӣ��������ص������еĽڵ㣨��Ϊ���ı�ǩΪ0��-1����
    if g(Over_node(i))==0 && length(neighbours)>0 
    %if g(Over_node(i))==-1 || length(neighbours)==0     %������������                 
        Over_label=g(neighbours);
        table=tabulate(Over_label);
  
        [F,I]=max(table(:,2)); %ѡȡ���ִ������ı�ǩ
        I=find(table(:,2)==F); 
        result=table(I,1);
        g(Over_node(i))=result(ceil(rand*length(result)));
        
    else 
        node(t)=a; %������(-1? or 0)�Ľڵ㶼�ռ�����
        neighbours=find(AdjMatrix(a,:)==1);            %%�����ھ�Ҳ���ص���
        neighbours=setdiff(neighbours,Over_node);
        Over_label=unique(g(neighbours)); %��ȡ�˻��� g ����Щ�ھӽڵ�ı�ǩ��ȥ��
        c_node{t}=Over_label; %�ص��ڵ�ļ�����ǩ�ռ�����
        t=t+1;
    end
end
if length(node)>0  
     g(node)=-1;  %���һ�٣�
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

    a=cell2mat(cellfun(@(s)length(find(s==i)),c_node,'UniformOutput',false)); %map������������cell�����ÿ��Ԫ��
    index=find(a==1);  %���а�����ǩi���ص��ڵ�����
    if length(index)>0
        community{t}=[community{t} node(index)];
    end
    end
    t=t+1;
    end
    
end

end

