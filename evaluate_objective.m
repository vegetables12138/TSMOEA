function f = evaluate_objective(x,AdjMatrix,ll,Over_node)

M=0;                       %%M=1��ʾΪ��ǩ������M=0��ʾΪ�ڽӱ���
f=[];

if  M==1
    clu_assignment=x(1:size(AdjMatrix,1));
end
if M==0 %�Ըû�����н����������
    clu_assignment = decode(AdjMatrix,x(1:size(AdjMatrix,1)),Over_node);     %%decode �����⣡
end

f(1)=compute_objective( AdjMatrix,clu_assignment,ll );
% f(1) = community_fitness_mod2(AdjMatrix,clu_assignment,ll);
%f(2)= -Calculate_EQ(clu_assignment,AdjMatrix);
 f(2) = community_score(AdjMatrix,clu_assignment,ll);

end