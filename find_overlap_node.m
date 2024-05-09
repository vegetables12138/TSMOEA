% 
 function [Clique] =find_overlap_node(community,numVar)
% 
% t=length(community);
% for i=1:t
%     
%    for j=1:t
%        if i~=j
%         A=community{i};
%         B=community{j};
%         t1=length(B);
%        
%         t2=length(A);
%         if t2<t1
%             t1=t2;
%         end
%         M=intersect(A,B);
%         t3=length(M);
%         if t3/t1>=0.5
%             community{i}=unique([community{i} community{j}]);
%         end
%        end
%    end
% 
% end
%   C=[];
% for i=1:t
%   A=community{i};
%    for j=1:t
%        if i~=j
%         B=community{j};
%         M=intersect(A,B);
%         t1=length(B);
%         t2=length(A);
%         if t2<t1
%             t1=t2;
%         end
%         
%         t3=length(M);
%         if t3>0
%             stop=1;
%         end
%         
%         if t3/t1>=0.5
%             community{i}=unique([community{i} community{j}]);
%             community{j}=[];
%         else
%             C=[C M];
%         end
%         end
%        
%    end
% end
% C=unique(C);
% m=1;
% for i=1:t
%     if ~isempty(community{i})
%         Clique{m}=setdiff(community{i},C);
%         m=m+1;
%     end
% end
% c=length(C);
% for i=1:c
%     Clique{m}=C(i);
%     m=m+1;
% end
% t=length(Clique);




%%�Ż���Ĵ���
M=zeros(length(community),numVar);       %��Ϊ��������Ϊ������ͨ���ξ�������֪����Щ�����ص��㣬Ҳ֪����Щ�����ص�����
for i=1:length(community)
    M(i,community{i})=i;
end
over_node=[]
for i=1:numVar
    if length(find(M(:,i)>0))>1
      over_node=[over_node i];
      community=cellfun(@(S)setdiff(S,i),community,'UniformOutput',false);         %Ԫ�����������
    end
end

Clique=community(find(cell2mat(cellfun(@(S)length(S),community,'UniformOutput',false))~=0));  %%�޳�����Ϊ0�����ţ�
j=length(Clique);
for i=1:length(over_node)
    Clique{j+1}=over_node(i);
    j=j+1;
end



end
    
    
    
    




