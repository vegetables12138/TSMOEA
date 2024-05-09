function pop = choose_overnode(candidate_Over_node,elite_g,AdjMatrix)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
chromlength = length(candidate_Over_node);
popsize = 20;
niche = 8;
pc=0.6; %交叉概率
pm=0.1; %变异概率
xlim = [0,50];
G = 100 ; %迭代次数
ll=sum(sum(AdjMatrix,1));
pop = round(rand(popsize,chromlength));


for g=1:G
    
    fitvalue = calfitvalue(pop);
    newpop = copyx(pop,fitvalue,popsize); %复制
    newpop = crossover(newpop, pc, popsize,chromlength ); %交叉
    newpop = mutation(newpop,pm, popsize,chromlength); %变异
    % 这时的newpop是经过复制交叉变异产生的新一代群体
    %     下边进行选择择优保留（即实现保底机制）
    new_fitvalue = calfitvalue(newpop); %计算新群体中每个个体的适应度
    index = find(new_fitvalue > fitvalue) ; %!!!a better way : 
    %index = find(new_fitvalue > mean(fitvalue));
    
    pop(index, : ) = newpop(index,:) ; % 更新得到最新解
      
end

%% 计算适应度
function fitvalue = calfitvalue(pop)
    for p=1:popsize
        tem_g = elite_g;
        ovnode = candidate_Over_node(find(pop(p,:)==1));
        tem_g(ovnode) = -1;
        fitvalue(p) = sum(evaluate_objective(tem_g,AdjMatrix,ll,ovnode)); 
    end
end

%% 复制操作
function newx = copyx(pop, fitvalue,popsize ) %传进来二进制串和对应适应度
% 按照PPT的轮盘赌策略对个体复制
    newx = pop; %只是起到申请一个size为pop大小空间的作用，newx之后要更新的
    i = 1;  j = 1;
    p = fitvalue / sum(fitvalue) ; 
    Cs = cumsum(p) ; 
    R = sort(rand(popsize,1)) ; %每个个体的复制概率
    while j <= popsize 
        if R(j) < Cs(i)
            newx(j,:) = pop(i,:) ;
            j = j + 1;
        else
            i = i + 1;
        end
    end
end

%% 交叉操作
function newx = crossover(pop, pc, popsize,chromlength )
% 12 34 56交叉方式，随机选择交叉位点
% 注意个体数为奇数偶数的区别
i = 2 ;
newx = pop ; %申请空间
while i + 2 <= popsize
    %将第i 与 第 i -1 进行随机位点交叉
    if rand < pc
        x1 = pop(i-1,:);
        x2 = pop(i,:) ; 
        r = randperm( chromlength , 2 ) ; %返回范围内两个整数
        r1 = min(r); r2 =max(r) ; % 交叉复制的位点
        newx(i-1,:) = [x1( 1 : r1-1),x2(r1:r2) , x1(r2+1: end)];
        newx(i , : ) = [x2( 1 : r1-1),x1(r1:r2) , x2(r2+1: end)];
    end
    i = i + 2 ; %更新i
end

end

%% 变异
function newx = mutation(pop,pm, popsize,chromlength)
i = 1 ;
while i <= popsize
    if rand < pm
        r = randperm( chromlength , 1 ) ; 
        pop(i , r) = ~pop(i, r);
    end
    i = i + 1;
end

newx = pop; %将变异后的结果返回。

end

end