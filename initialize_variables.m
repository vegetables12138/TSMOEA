function [idealp,f]= initialize_variables(N,AdjMatrix,M,V,ll,Over_node,Datalable)

%N：种群数 M:优化目标数 V：节点数
%% 
U=1 ;  %用来控制标签传播还是随机初始化，1为随机初始化，0为标签传播
%% 

K = M + V;

for i = 1 : N
    
    f(i,1:V)=IGLP(V,AdjMatrix,U,Over_node); %生成每个个体基因（只有重叠节点位点（0激活，-1抑制）会有区别，别的基因位点相同）
   
   
    f(i,V + 1: K) = evaluate_objective(f(i,1:V),AdjMatrix,ll,Over_node);%计算该个体基因对应目标值
end

 idealp = min(f(:,V+1:K)); %idealp 则是目标函数值的理想点，通常是每个目标函数的最小值。
 
end
