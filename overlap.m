function  over_node= overlap(community)

over_node=[];
for i=1:length(community)
    A=community{i};
 for j=i+1:length(community)
     B=community{j};
     if length(intersect(A,B))>0
         over_node=[over_node intersect(A,B)];
     end
 end
end
over_node=unique(over_node);
end