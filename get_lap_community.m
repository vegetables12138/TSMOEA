function [community,lapnode] = get_community(path)
% 打开文件
%path = 'RealWorld/real_lfr7.txt'
fid = fopen(path, 'r');


% 初始化一个 cell 数组用于存储每行数据
community = {};
tem = [];
% 逐行读取数据
tline = fgetl(fid);
node_num = 0;
while ischar(tline)
    % 将当前行的数据添加到 cell 数组
    node_num = node_num+1;
    lables = str2num(tline);
    if length(lables)>2
        tem = [tem node_num];
    end
    for lab=2:length(lables)
        if lables(lab) > length(community)
            community{lables(lab)} = [node_num];
        else
            community{lables(lab)} = [community{lables(lab)} node_num];
        end
    end

    tline = fgetl(fid);
    
end
lapnode = tem;
% 关闭文件
fclose(fid);


end