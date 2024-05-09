function [AdjMatrix,Community]=transport(name,real)
%%导入到内存


real_string=importdata(real,'r');

string=importdata(name,'r');
for i=1:length(string)
    a=char(string(i));
    for j=1:length(a)
       space_index=find(isspace(a));
       S{i,1}=a(1:space_index(1)-1);
       S{i,2}=a(space_index(end)+1:length(a));
    end
end
%%%转化成数字形式
A=unique(S);
edges=zeros(length(string),2);
for i=1:length(A)
     [index_i,index_j]=find(strcmp(S,char(A(i))));
     for j=1:length(index_i)
       edges(index_i(j),index_j(j))=i;
     end
end
AdjMatrix=zeros(length(A),length(A));
for i=1:length(edges)
    AdjMatrix(edges(i,1),edges(i,2))=1;
    AdjMatrix(edges(i,2),edges(i,1))=1;
end

for i=1:length(real_string)
    Community{i}=[];
    if i==81
        stop=1;
    end
      for j=1:length(A)
          if strfind(char(real_string(i)), char(A(j)));
              Community{i}=[Community{i} j];
          end
      end
    
end
end





