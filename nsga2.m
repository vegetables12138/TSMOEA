function results = nsga2(Over_node,elite_g,AdjMatrix)
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, NSGA-II in MATLAB (URL: https://yarpiz.com/56/ypea120-nsga2), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%
%{
Qov =

    0.3491


gNMI =

    0.7548



randomNumbers = randperm(100, 31);
Over_node = load('Over_node.mat').Over_node;
elite_g = load('elites.mat').elites(1,:);
AdjMatrix = load('AdjMatrix.mat').AdjMatrix;
%}

%% Problem Definition

% 定义一个单独的函数来处理操作
function result = deal(x)
    tem_g = elite_g;
    result.ovnode = Over_node(find(x == 1));
    tem_g(result.ovnode) = -1;
    result.g = tem_g;
end

%CostFunction = @(x) evaluate_objective(deal(x).g,AdjMatrix,sum(sum(AdjMatrix,1)),deal(x).ovnode)';      % Cost Function
function objs = CostFunction(x)
    tem_g = elite_g;
    ovnode = Over_node(find(x == 1));
    objs(1) = -length(ovnode);
    tem_g(ovnode) = -1;
    community=decode(AdjMatrix,tem_g,ovnode);
    objs(2) = -Calculate_EQ(community,AdjMatrix); 
    objs = objs';
end

%a = evaluate_objective(elite_g,AdjMatrix,sum(sum(AdjMatrix,1)),[]);
nVar = 1;             % Number of Decision Variables

VarSize = [1 nVar];   % Size of Decision Variables Matrix


% Number of Objective Functions
nObj = 2;


%% NSGA-II Parameters

MaxIt = 100;      % Maximum Number of Iterations

nPop = 50;        % Population Size

pCrossover = 0.7;                         % Crossover Percentage
nCrossover = 2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

pMutation = 0.4;                          % Mutation Percentage
nMutation = round(pMutation*nPop);        % Number of Mutants

mu = 0.02;                    % Mutation Rate

%sigma = 0.1*(VarMax-VarMin);  % Mutation Step Size
chromlength = length(Over_node);


%% Initialization

empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.CrowdingDistance = [];

pop = repmat(empty_individual, nPop, 1);

for i = 1:nPop
    
    pop(i).Position = round(rand(1,chromlength));
    
    pop(i).Cost = CostFunction(pop(i).Position);
    
end

% Non-Dominated Sorting
[pop, F] = NonDominatedSorting(pop);

% Calculate Crowding Distance
pop = CalcCrowdingDistance(pop, F);

% Sort Population
[pop, F] = SortPopulation(pop);


%% NSGA-II Main Loop
tic=clock;
for it = 1:MaxIt
    
    % Crossover
    popc = repmat(empty_individual, nCrossover/2, 2);
    for k = 1:nCrossover/2
        
        i1 = randi([1 nPop]);
        p1 = pop(i1);
        
        i2 = randi([1 nPop]);
        p2 = pop(i2);
        
        [popc(k, 1).Position, popc(k, 2).Position] = crossover(p1.Position, p2.Position);
        
        
        popc(k, 1).Cost = CostFunction(popc(k, 1).Position);
        popc(k, 2).Cost = CostFunction(popc(k, 2).Position);
        
    end
    popc = popc(:);
    
    % Mutation
    popm = repmat(empty_individual, nMutation, 1);
    for k = 1:nMutation
        
        i = randi([1 nPop]);
        p = pop(i);
        
        popm(k).Position = mutation(p.Position);

        popm(k).Cost = CostFunction(popm(k).Position);
        
    end
    
    % Merge
    pop = [pop
         popc
         popm]; %#ok
     
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    pop = SortPopulation(pop);
    
    % Truncate
    pop = pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    [pop, F] = SortPopulation(pop);
    
    % Store F1
    F1 = pop(F{1});
    
    % Show Iteration Information
    %disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    % Plot F1 Costs
    %figure(1);
    %PlotCosts(F1);
    %pause(0.01);
    if mod(it, 5) == 0
    fprintf('NSGA-II_lapnode, 第%2s轮,已完成%4s%%,耗时%5s秒\n',num2str(it),num2str(roundn(it/MaxIt*100,-1)),num2str(etime(clock,tic)));
    end
end
%figure(1);
%PlotCosts(F1);
%pause(0.01);
for i=1:nPop
    results(i,:) = pop(i).Position;
end

%% 交叉操作
function [np1,np2] = crossover(p1,p2)
np1=p1;np2 = p2;
r = randperm( chromlength , 2 ) ; %返回范围内两个整数
r1 = min(r); r2 =max(r) ; % 交叉复制的位点
np1= [p1( 1 : r1-1),p2(r1:r2) , p1(r2+1: end)];
np2= [p2( 1 : r1-1),p1(r1:r2) , p2(r2+1: end)];

end

%% 变异
function np = mutation(p)

if rand < 0.1
     r = randperm( chromlength , 1 ) ; 
     p(r) = ~p(r);
end

np = p; %将变异后的结果返回。

end

%% Results
end
