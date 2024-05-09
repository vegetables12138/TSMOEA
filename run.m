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
    real_path=sprintf('RealWorld/real_%s.txt',networkfile1{iii}); %��ʵ���绮��

    
    AdjMatrix=load(networkfile);
    if min(min(AdjMatrix))==0
        add=1; %?
    else
        add=0;
    end
    if size(AdjMatrix,2)==2 %��������ж���Ϊ�˼���ڽӾ����ά���Ƿ�Ϊ2��
        % ����ڽӾ��������Ϊ2��˵����������һ�ֱ��б�ı�ʾ��ʽ�������ǳ�����ڽӾ���
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
            real_community{i}=find(Datalable==i);%ÿ�з���һ������cell
            clu_file_real(i,1:length(real_community{i}))=real_community{i};%��clu_file_realÿ��ÿ�а������䵥��Ԫ��
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
    %% �������ձ���·��
    name1=networkfile1{iii}; %real_label_ �Լ����򻮷ֵ�����,�������ֵ���һ�ַ�ʽ
    real_netwrok= ['./RealWorld/real_label_',networkfile1{iii},'.txt'];
    numVar=length(AdjMatrix);
    name=sprintf('%s_%d',networkfile1{iii},1);
    strNetwork=name;
    root = sprintf('results1/%s/%s/ParetoFront',name1,strNetwork);  %%�����ļ�����ʵ������
    if ~isdir(root) %�ж�·���Ƿ����
        mkdir(root);
    end
    root = sprintf('results1/%s/%s/metrics',name1,strNetwork);
    if ~isdir(root) %�ж�·���Ƿ����
        mkdir(root);
    end
    
    %% MRMOEA�㷨��������
    starttime = clock; %��¼�㷨��ʼ��ʱ�䣬�Ա������������ʱ�䡣
    M = 2;%ָ���Ż������Ŀ�������������������Ŀ�ꡣ
    popsize = 100;%Ⱥ��Ĵ�С�������ӵ�������������� 100 �����ӡ�
    niche =40;%ÿ�����ӵ������С������һ��Ӱ���㷨�����ԺͶ����ԵĲ���
    max_gen=100;%�㷨���������������������Ĵ�����
    pc=1;%������ʣ���ʾ�ڽ�������У�����������н���ĸ��ʡ�
    mutate_posibility=0.15;%������ʣ���ʾÿ��������б���ĸ��ʡ�
    pg=0.9;%�ֲ��������ʣ���ʾ�ھֲ����������У�������оֲ������ĸ��ʡ�
    kk=2;%�����С�ı���������ȷ������Ĵ�С��
    u=0.1;%δʹ�õĽڵ�Ȩ�أ�����ȷ����ѡ�ص��ڵ㡣
    ll=sum(sum(AdjMatrix,1));%�ȵ��ܺͣ����ڼ���δʹ�ýڵ��Ȩ�ء�

   
        %% MRMOEA�㷨Ԥ����
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
        [weights,neighbors] = init_weight(popsize, niche); %neighbors��%�����i��Ȩ����ӽ���ǰniche���ھ�
        [idealp,chromosomes]= initialize_variables(popsize,AdjMatrix,M,numVar,ll,Over_node,Datalable);  % ��ʼ����Ⱥ����С������Ŀ�꣬��Ⱥ���и������Ͷ�ӦĿ��ֵ
        pbest=chromosomes;  %��ʷ���Ž�
        velocity=zeros(popsize,numVar);
        tic=clock;
        
        %% ���������еĴ���
        for Gene = 1:max_gen
            for i=1:popsize
                i_neighbor_index = neighbors(i,:);
                i_neighbor_weight = weights(i_neighbor_index,:);
                i_neighbor_chromosome = chromosomes(i_neighbor_index,:);
                old_objective = i_neighbor_chromosome(:,numVar+1:numVar+M);
                [velocity, child]= compute_velocity(i,chromosomes,pbest,velocity,AdjMatrix,neighbors,Over_node);  %%�����Ӵ�
                if(Gene<popsize*mutate_posibility) %�����ڵĽ����׶Σ����б������������Ϊ�������Ⱥ�Ķ����ԡ�
                    child= realmutation(child,mutate_posibility,AdjMatrix,Over_node); %ʵʩʵ�ʵı��������                                                               %��
                end
                child(numVar+1:numVar+2)=evaluate_objective(child,AdjMatrix,ll,Over_node); %�����Ӵ���Ŀ�꺯��ֵ��
                for h=1:2
                    if child(numVar+h)<idealp(h)
                        idealp(h)=child(numVar+h);       %���²ο��㣬��������Ⱥ�����ѷ���
                    end
                end

                chromosomes=update_problem(idealp,chromosomes,child,i_neighbor_index,i,weights,numVar) ;  %���µ�ǰ��Ⱥ    
                
                pbest(i,:)=update_pbests(i,pbest(i,:),chromosomes(i,:),numVar,weights); %���¸�����ʷ���Ž⣨��֧���ʺ�����        
      
            end
            Problem='��������';
            M=2;
        %clc; % ��������
            if mod(Gene, 10) == 0
            fprintf('NSGA-II,%s����, ��%d������,��%2s��,%5s����,%2sά,�����%4s%%,��ʱ%5s��\n',networkfile1{iii},n,num2str(Gene),Problem,num2str(M),num2str(roundn(Gene/max_gen*100,-1)),num2str(etime(clock,tic)));
            end
        end



        %Draw(chromosomes,numVar);
        for i = 1:popsize

            community{i}=decode(AdjMatrix,chromosomes(i,1:numVar),Over_node);


            modnmi(i) = Calculate_EQ(community{i},AdjMatrix);
            NMI(i)=Calculate_NMI(community{i},real_netwrok,real_community);
       
        end
        %time=[time etime(clock,tic)];


        %% �Ŵ��㷨ѡ������ص���
    Over_node=find_lap(AdjMatrix,u);      % ��ѡ�ص���???��δ�����������г�ּ��������¾������ȷ���˺�ѡ�ص��ڵ㣬�����Ժ�ֻ�ܴ�����ѡ���ص��ڵ㣬�����Ƿ�����Ƿȱ��
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
    time=[time max(time) mean(time)]; Qov=[Qov max(Qov) mean(Qov)];gNMI=[gNMI max(gNMI) mean(gNMI)]; %������������ֵ����ֵ
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
fprintf('Qov(��ξ�ֵ):')
disp(Q);
fprintf('gNMI(��ξ�ֵ):')
disp(g);
%}

end


