function  MRMOEA(path,name,real_path,change,Noture,edge_add)
global Datalable idealp

%% Read network  
networkfile1={'test100','lfr5','lfr6','lfr8','lfr9','karate','dolphin','football','polbooks','jazz','netscience','blogs','Y2H','PPI_D2','protein-protein',};
fid = fopen('result_NMI.txt','w');

for iii=1:1
    Qov=[];
    gNMI=[]; 
    time=[];
    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
    networkfile = sprintf('RealWorld/%s.txt',networkfile1{iii});
    real_path=sprintf('RealWorld/real_%s.txt',networkfile1{iii}); %真实网络划分

    
    AdjMatrix=load(networkfile);
    if min(min(AdjMatrix))==0
        add=1; %?
    else
        add=0;
    end
    if size(AdjMatrix,2)==2 %这个条件判断是为了检查邻接矩阵的维度是否为2。
        % 如果邻接矩阵的列数为2，说明它可能是一种边列表的表示方式，而不是常规的邻接矩阵。
        M=load(networkfile)+add; %?
        numVar=single(max(M(:,2)));
        AdjMatrix=Adjreverse(M,numVar,0);
        degree=sum(AdjMatrix);
        index=find(degree==0);
        a=setdiff(1:length(AdjMatrix),index);
        AdjMatrix=AdjMatrix(a,a);
        numVar=length(AdjMatrix);
    end
    if length(importdata(real_path,'r')) == 1 || ismember(networkfile1{iii}, {'Y2H'}) 
    if ~ismember(networkfile1{iii}, {'Y2H'}) 
        Datalable=load(real_path);
    else
        Datalable=zeros(1,numVar);
    end
    numVar=length(AdjMatrix);
    if length(find(Datalable==0))==0
        clu_file_real=zeros(max(Datalable),numVar);
        for i=1:max(Datalable)
            real_community{i}=find(Datalable==i);%每列分配一个数组cell
            clu_file_real(i,1:length(real_community{i}))=real_community{i};%向clu_file_real每行每列挨个分配单个元素
        end
    else if ~ismember(networkfile1{iii}, {'Y2H'}) 
            clu_file_real=zeros(1,numVar);
            real_community{1}=1:numVar;
            clu_file_real(1,1:length(real_community{1}))=real_community{1};
        else
            
            real_string=importdata(real_path,'r');
            clu_file_real=zeros(length(real_string),numVar);
            comIndex = 1;
            for i=1:length(real_string)
                tem = str2num(char((real_string(i))))+1;
                A = tem(find(tem>0));
                if length(A)>0
                    real_community{comIndex}=A;
                    clu_file_real(comIndex,1:length(real_community{comIndex}))=real_community{comIndex};
                    comIndex = comIndex + 1;
                end
            end
        end
    end
    else
            [real_community,lapnode] = get_lap_community(real_path);
    end 

    % record = {};
    % set = [];
    % for i = 1:numVar
    %     record{i,1} = [i];
    %     record{i,2} = [];
    %     for j = 1:length(real_community)
    %         set = [set real_community{j}];
    %         if ismember(i, real_community{j})
    %             record{i,2} = [record{i,2} j];
    %         end
    %     end
    % end
    % set = unique(set);
    

    for n=1:5 %!!
    %% 设置最终保存路径
    name1=networkfile1{iii}; %real_label_ 自己程序划分的网络,社区划分的另一种方式
    real_netwrok= ['./RealWorld/real_label_',networkfile1{iii},'.txt'];
    numVar=length(AdjMatrix);
    name=sprintf('%s_%d',networkfile1{iii},1);
    strNetwork=name;
    root = sprintf('results1/%s/%s/ParetoFront',name1,strNetwork);  %%建个文件保存实验数据
    if ~isdir(root) %判断路径是否存在
        mkdir(root);
    end
    root = sprintf('results1/%s/%s/metrics',name1,strNetwork);
    if ~isdir(root) %判断路径是否存在
        mkdir(root);
    end
    
    %% MRMOEA算法参数设置
    starttime = clock; %记录算法开始的时间，以便后续计算运行时间。
    M = 2;%指定优化问题的目标数量。在这里，有两个目标。
    popsize = 100;%群体的大小，即粒子的数量。在这里，有 100 个粒子。
    niche =40;%每个粒子的邻域大小。这是一个影响算法收敛性和多样性的参数
    max_gen=100;%算法的最大迭代次数，即进化的代数。
    pc=1;%交叉概率，表示在交叉操作中，两个个体进行交叉的概率。
    mutate_posibility=0.15;%变异概率，表示每个个体进行变异的概率。
    pg=0.9;%局部搜索概率，表示在局部搜索操作中，个体进行局部搜索的概率。
    kk=2;%邻域大小的倍数，用于确定邻域的大小。
    u=0.1;%未使用的节点权重，用于确定候选重叠节点。
    ll=sum(sum(AdjMatrix,1));%度的总和，用于计算未使用节点的权重。

   
        %% MRMOEA算法预处理
        idealp = -Inf*ones(1,M); 
        %fprintf('%d:%s\n',iii,num2str(length(Over_node))); %!!!
        
       % Over_node = lapnode;
        %{
        ls=[];
        while length(ls)<10
            ls = [ls randi(length(Over_node))];
            ls = unique(ls);
        end
        Over_node = Over_node(ls);
        %}
        %fprintf('%d\n',length(Over_node))
        %%{
        %Over_node=[33 144 246 89 73 29 88 20 299 109 1 2 3 4 5 6 7 8 9 ];
        %Over_node=[ 15      63    72    78        159   ];
        
        %Over_node=[Over_node 5 10 90 130 200 250 150 130 30 89 3 288 199 151 34];
        Over_node=[];
        [weights,neighbors] = init_weight(popsize, niche); %neighbors：%与个体i的权重最接近的前niche个邻居
        [idealp,chromosomes]= initialize_variables(popsize,AdjMatrix,M,numVar,ll,Over_node,Datalable);  % 初始化种群，最小的两个目标，种群所有个体基因和对应目标值
        pbest=chromosomes;  %历史最优解
        velocity=zeros(popsize,numVar);
        tic=clock;
        
        %% 进化过程中的处理
        for Gene = 1:max_gen
            for i=1:popsize
                i_neighbor_index = neighbors(i,:);
                i_neighbor_weight = weights(i_neighbor_index,:);
                i_neighbor_chromosome = chromosomes(i_neighbor_index,:);
                old_objective = i_neighbor_chromosome(:,numVar+1:numVar+M);
                [velocity, child]= compute_velocity(i,chromosomes,pbest,velocity,AdjMatrix,neighbors,Over_node);  %%产生子代
                if(Gene<popsize*mutate_posibility) %在早期的进化阶段，进行变异操作，这是为了提高种群的多样性。
                    child= realmutation(child,mutate_posibility,AdjMatrix,Over_node); %实施实际的变异操作。                                                               %震荡
                end
                child(numVar+1:numVar+2)=evaluate_objective(child,AdjMatrix,ll,Over_node); %计算子代的目标函数值。
                for h=1:2
                    if child(numVar+h)<idealp(h)
                        idealp(h)=child(numVar+h);       %更新参考点，这是整个群落的最佳方向
                    end
                end

                chromosomes=update_problem(idealp,chromosomes,child,i_neighbor_index,i,weights,numVar) ;  %更新当前种群    
                
                pbest(i,:)=update_pbests(i,pbest(i,:),chromosomes(i,:),numVar,weights); %更新个体历史最优解（非支配适合纵向）        
      
            end
            Problem='聚类问题';
            M=2;
        %clc; % 清除命令窗口
            if mod(Gene, 10) == 0
            fprintf('NSGA-II,%s网络, 第%d次运行,第%2s轮,%5s问题,%2s维,已完成%4s%%,耗时%5s秒\n',networkfile1{iii},n,num2str(Gene),Problem,num2str(M),num2str(roundn(Gene/max_gen*100,-1)),num2str(etime(clock,tic)));
            end
        end



        %Draw(chromosomes,numVar);
        for i = 1:popsize

            community{i}=decode(AdjMatrix,chromosomes(i,1:numVar),Over_node);


            modnmi(i) = Calculate_EQ(community{i},AdjMatrix);
            NMI(i)=Calculate_NMI(community{i},real_netwrok,real_community);
       
        end
        %time=[time etime(clock,tic)];


        %% 遗传算法选择更优重叠点
    Over_node=find_lap(AdjMatrix,u);      % 候选重叠点???在未对社区网络有充分计算的情况下就在最初确定了候选重叠节点，并且以后只能从这里选出重叠节点，这样是否有所欠缺？
    [~,index] = sort(modnmi,'descend');

    elites = chromosomes(index(1:3),1:numVar);
    %elite = chromosomes(index(1),1:numVar);

    pop = nsga2(Over_node,elites(1,:),AdjMatrix);
    for p=1:size(pop,1)
        for e=1:3
            tem_g = elites(e,:);
            ovnode = Over_node(find(pop(p,:)==1));
            tem_g(ovnode) = -1;
            community = decode(AdjMatrix,tem_g,ovnode);
            %community{p,e} = decode(AdjMatrix,tem_g,ovnode);
            Qovs(e) = Calculate_EQ(community,AdjMatrix);
            gNMIs(e) =Calculate_NMI(community,real_netwrok,real_community);
        end
        modnmi(popsize+p) = max(Qovs);
        NMI(popsize+p) = max(gNMIs);
    end
        %time=[time etime(clock,tic)];
        Qov=[Qov max(modnmi)]
        gNMI=[gNMI max(NMI)] 

        filename=sprintf('result/%s_imp_%d.txt',networkfile1{iii}, n); 
        all(1,:) = max(modnmi);all(2,:) = max(NMI);
        savedata1(filename,all);

    clearvars -except networkfile1 iii   Qov  gNMI time AdjMatrix numVar Datalable real_community lapnode;
    end
    %%{
    time=[time max(time) mean(time)]; Qov=[Qov max(Qov) mean(Qov)];gNMI=[gNMI max(gNMI) mean(gNMI)]; %最后两列是最大值、均值
 filename=sprintf('result/%s_imp.txt',networkfile1{iii});  
 %all(1,:) = time;
 all(2,:) = Qov;all(3,:) = gNMI;
 savedata1(filename,all);


    %}
end
%{
Q=[];
g=[];
for i=0:1
Q = [Q sum(Qov(i*5+1:i*5+5))/5];
g = [g sum(gNMI(i*5+1:i*5+5))/5];
end
fprintf('Qov(五次均值):')
disp(Q);
fprintf('gNMI(五次均值):')
disp(g);
%}

end


