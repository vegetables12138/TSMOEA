function v_n = readOb_v_n(FileName)
%FileName Ӧ����ȫ·������

[fid, message] = fopen(FileName,'r');

if (fid == -1)
disp(message); %��ʧ�ܵĻ������ش���
return;
end

while 1
[prefix,count]=fscanf(fid,'%s',1);%1 ����ֻ��һ������
tline=fgetl(fid);
v_n=dlmread(FileName,'');
if count==0
break;
end
end 
