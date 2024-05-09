function [ adj_mat,clu_assignment ] = convert_extgn_to_adjmat( community,network )
% Convert the network saved data in DAT format to adjacency matrix
% Two input matrix:community and network,are reading from community.dat and
% network.dat,respectively.

[nodes,temp] = size(community);
[edges,temp] = size(network);
clear temp;

adj_mat = zeros(nodes,nodes);
for i = 1:edges
    adj_mat(network(i,1),network(i,2)) = 1;
end

clu_assignment = community(:,2)';

end