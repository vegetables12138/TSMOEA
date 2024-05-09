function f = evaluate_objective(x,AdjMatrix,ll,Over_node)

M=0;                       %%M=1表示为标签传播，M=0表示为邻接编码
f=[];

if  M==1
    clu_assignment=x(1:size(AdjMatrix,1));
end
if M==0 %对该基因进行解码分配社区
    clu_assignment = decode(AdjMatrix,x(1:size(AdjMatrix,1)),Over_node);     %%decode 有问题！
end

f(1)=compute_objective( AdjMatrix,clu_assignment,ll );
% f(1) = community_fitness_mod2(AdjMatrix,clu_assignment,ll);
%f(2)= -Calculate_EQ(clu_assignment,AdjMatrix);
 f(2) = community_score(AdjMatrix,clu_assignment,ll);

end