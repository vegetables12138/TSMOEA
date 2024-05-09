function [ cf ] = community_fitness_mod2( adj_mat,clu_assignment,ll)
% Compute the community fittness for each partition.
% adj_mat: the adjacency matrix of the network.
% clu_assignment: the cluster label vector.

a = 1;  % a parameter in the formula of community fittness.
cf = 0;
clu_num = max(clu_assignment);
for i = 1:clu_num
    s_index = find(clu_assignment == i);
    s = adj_mat(s_index,s_index);
    s_cardinality = length(s_index);
    kins_sum = 0;
    kouts_sum = 0;
    for j = 1:s_cardinality
        kins = sum(s(j,:));
        ksum = sum(adj_mat(s_index(j),:));
        kouts = ksum - kins;
        kins_sum = kins_sum + kins;
        kouts_sum = kouts_sum + kouts;        
    end
    cf_s = kins_sum/(kins_sum + kouts_sum)^a;
    cf = cf + cf_s;
end
cf = -cf/clu_num;
end

