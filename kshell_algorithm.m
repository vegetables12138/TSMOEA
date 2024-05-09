function kshell = kshell_algorithm(adjacency_matrix)
% 输入参数为邻接矩阵 adjacency_matrix
% 输出结果为每个节点的K-Shell值，保存在kshell变量中
% adjacency_matrix = [0 1 1 1 0 0;1 0 1 0 0 0;1 1 0 0 0 1;1 0 0 0 1 1;0 0 0 1 0 1;0 0 1 1 1 0;]
% N = size(adjacency_matrix, 1);  % 获取邻接矩阵的维度
% degrees = sum(adjacency_matrix, 2);  % 计算每个节点的度数
% kshell = zeros(1, N);  % 初始化每个节点的K-Shell值为0

while sum(degrees > 0) > 0
    min_degree = min(degrees(degrees > 0));  % 找到度数最小的节点
    min_nodes = find(degrees == min_degree);  % 找到所有度数相同的节点
    for node = min_nodes'
        neighbors = find(adjacency_matrix(node, :));  % 找到当前节点的邻居节点
        degrees(neighbors) = degrees(neighbors) - 1;  % 邻居节点的度数减1
        kshell(node) = min_degree;  % 为当前节点赋予K-Shell值
        degrees(node) = 0;  % 将当前节点的度数设为0，表示已处理
    end
end
%kshell;
end

