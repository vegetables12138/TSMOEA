function [idealp,f]= initialize_variables(N,AdjMatrix,M,V,ll,Over_node,Datalable)

%N����Ⱥ�� M:�Ż�Ŀ���� V���ڵ���
%% 
U=1 ;  %�������Ʊ�ǩ�������������ʼ����1Ϊ�����ʼ����0Ϊ��ǩ����
%% 

K = M + V;

for i = 1 : N
    
    f(i,1:V)=IGLP(V,AdjMatrix,U,Over_node); %����ÿ���������ֻ���ص��ڵ�λ�㣨0���-1���ƣ��������𣬱�Ļ���λ����ͬ��
   
   
    f(i,V + 1: K) = evaluate_objective(f(i,1:V),AdjMatrix,ll,Over_node);%����ø�������ӦĿ��ֵ
end

 idealp = min(f(:,V+1:K)); %idealp ����Ŀ�꺯��ֵ������㣬ͨ����ÿ��Ŀ�꺯������Сֵ��
 
end
