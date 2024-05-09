function [a ,real,cNum]=zhuanhuashuju(p1 ,p2)
nodes=max(max(p1(:,2)),max(p1(:,1)));
a=zeros(nodes);
hang=size(p1,1);
for i=1:hang
    a(p1(i,1),p1(i,2))=1;
    a(p1(i,2),p1(i,1))=1;
end
% commnunitynum=max(p2(:,2));
% true_partion=zeros(1,nodes);
% truecommunity=zeros(commnunitynum,nodes);
% for i=1:nodes
%     true_partion(1,i)=p2(i,2);
% end
% for j=1:commnunitynum
% n=1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ;
%     for i=1:nodes
%         if p2(i,2)==j
%             truecommunity(j,n)=p2(i,1);
%             n=n+1;
%         end
%     end
% end
p2(:,1)=[];
cNum=max(max(p2));
real=zeros(cNum,nodes);
[x,y]=size(p2);
for i=1:x
    for j=1:y
       if p2(i,j)~=0
           p=1;
           while(real(p2(i,j),p))
               p=p+1;
           end
           real(p2(i,j),p)=i;
       end
    end
end



 

