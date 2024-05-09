function [weights neighbours] = init_weight(popsize, niche)
% init_weights and neighbors.

weights = [];
for i=0:popsize-1 %weights存储了每个个体的两个目标的权重
    weight=zeros(1,2);
    weight(1)=i/(popsize-1);
    weight(2)=(popsize-i-1)/(popsize-1);
    weights = [weights;weight];
end
weights=single(weights);

%Set up the neighbourhood.
leng=size(weights,1);
distanceMatrix=zeros(leng, leng);
for i=1:leng
    for j=i+1:leng %其中存储了每对权重之间的欧氏距离的平方。
        A=weights(i,:)';B=weights(j,:)';
        distanceMatrix(i,j)=(A-B)'*(A-B);
        distanceMatrix(j,i)=distanceMatrix(i,j);
    end
    [s,sindex]=sort(distanceMatrix(i,:));
    neighbours(i,:)=sindex(1:niche); %与个体i的权重最接近的前niche个邻居
end
   neighbours=single(neighbours);
end