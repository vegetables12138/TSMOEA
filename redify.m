function T=redify(community)
index=[];
for i=1:length(community)
   A=community{i};
   for j=1:length(community)
       if i~=j
       B=intersect(A,community{j});
       if length(B)==length(A)
           index=unique([index i]);
       end
       end
   end

end
index=setdiff(1:length(community),index);


T=community(index);

end