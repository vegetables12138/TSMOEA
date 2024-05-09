function v_n = readOb_v_n(FileName)
%FileName 应该是全路径名字

[fid, message] = fopen(FileName,'r');

if (fid == -1)
disp(message); %打开失败的话，返回错误
return;
end

while 1
[prefix,count]=fscanf(fid,'%s',1);%1 代表只读一个数据
tline=fgetl(fid);
v_n=dlmread(FileName,'');
if count==0
break;
end
end 
