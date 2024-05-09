function chromosomes=update_problem(idealp,chromosomes,child,i_neighbour_index,index,weight,numVar) 


niche=length(i_neighbour_index);
for i=1:niche
    neighbours=i_neighbour_index(i);
    f1=scalar_func(chromosomes(neighbours,numVar+1:numVar+2),idealp,weight(neighbours,:));
    f2=scalar_func(child(numVar+1:numVar+2),idealp,weight(neighbours,:));
  if f2<f1
      chromosomes(neighbours,:)=child; %果子代的目标函数值更好（小于邻居的目标函数值），则将子代的基因应用到该邻居粒子上，从而更新种群

  end
end
      