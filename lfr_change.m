

% 指定原始文件路径和文件名
originalFilePath = 'RealWorld/community.txt';

% 读取原始文件
data = dlmread(originalFilePath);

% 提取第二列数字
secondColumn = data(:, 2);

% 指定新文件路径和文件名
newFilePath = 'RealWorld/real_lfr4.txt';

% 将提取的数字按行输出到新文件
fid = fopen(newFilePath, 'w');
fprintf(fid, '%d ', secondColumn);
fclose(fid);
