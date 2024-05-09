function community = file2community( filename )
%%�������ܣ�ͨ������һ��filename�������file���������ת��Ϊcommunity��ʽ���
%community��һ��ϸ���ṹ

% %���Զ��ķ�ʽ��ȡtxt�ļ�
fid = fopen(filename,'r');
f = textscan(fid,'%s %s %s');
if fid == -1
    error('��ȡ�ļ�ʧ��');
end;

ordered_names = union(f{1},f{1});
[bool,ordered_node_num] = ismember(f{1},ordered_names);%% ordered_node_numΪ�ڵ��Ӧ�ı��
fclose(fid);

row = length(ordered_node_num);
com1 = f{2};
com2 = f{3};
c1=[];
c2=[];
for i=1:row
    c = com2{i};
    if isempty(c)
        c1=[c1;str2num(com1{i})];
        c2=[c2;0];
    else
        c1=[c1;str2num(com1{i})];
        c2=[c2;str2num(c)];
    end;
end
matrix=[ordered_node_num c1 c2];
row=size(matrix,1);
col=size(matrix,2);

%�Ȼ���ɶ��ٸ�����
communitynum=[];
for i=1:row
    temp=matrix(i,2:col);
    temp=temp(find(temp));
    
    communitynum=union(communitynum,temp);
end;

maxnum=length(communitynum);
community=cell(1,maxnum);

for i=1:row
    node_num = matrix(i,1);
    
    temp=matrix(i,2:col);
    temp=temp(find(temp));
    
    for j=1:length(temp)
        num1=temp(j);
        tt=community{num1};
        community{num1}=[tt i];
    end;
end;
end

