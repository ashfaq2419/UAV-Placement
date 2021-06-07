function St_Results = RunGA(St_Data,St_Algo)

Generations = St_Algo.gSize;
initPop = St_Data.initPop;
PopSize = St_Algo.pSize;
SelProb = St_Algo.SelProb;
Dimension = St_Algo.Dimension;
Penalty = St_Data.Penalty;

costVec = St_Data.costVec;
beta = St_Data.beta;

bestFitnessVal = 1e6;
bestValue = 0;
bestValPerIter = zeros(1,Generations);
bestPopPerIter = zeros(Generations,Dimension);
bestGeneration = 0;
bestPop = zeros(1,Dimension);
DroneLocs = St_Data.totalDroneLocs;
n = St_Data.n;
m = DroneLocs;
realYnm = St_Data.realYnm;

%% main GA simulation
for g = 1:Generations
    for p = 1:PopSize
        St_Data.currPop = initPop(p,:);
        tempynm1 = St_Data.currPop(DroneLocs + 1:end);
        tempynm2 = (reshape(tempynm1,DroneLocs,n))'.*realYnm;
        ynm = reshape(tempynm2',1,DroneLocs*n);
        St_Data.currPop(DroneLocs + 1:end) = ynm;
        theta(p) = nonDeathPenaltyFun1(St_Data); % non-death penalty approach 1 (Evolutionary Optimization Algorithms Dan Simon page 486)
    end
    
    [val indx] = sort(theta,'ascend');
    nSelPop = round(SelProb*PopSize);
    SelPop = initPop(indx(1:nSelPop),:);
    
    if val(1) < bestFitnessVal
        bestGeneration = g;
        bestPop = SelPop(1,:);
        bestValue = val(1);
        bestFitnessVal = val(1);
    end
    
    bestPopPerIter(g,:) = bestPop;
    bestValPerIter(g) = bestValue;
    
    j = 1;
    for i = 1:PopSize
        selParents = randi(nSelPop,1,2);
        crossOverPoint = randi(Dimension,1,1);
        parent1 = SelPop(selParents(1),:);
        parent2 = SelPop(selParents(2),:);
        child(j,:)   = [parent1(1:crossOverPoint) parent2(crossOverPoint+1:end)];
        child(j+1,:) = [parent2(1:crossOverPoint) parent1(crossOverPoint+1:end)];
        j = j + 2;
    end
    
    for i = 1:PopSize
        ifMutate = rand < 0.4;
        MutPoint = randi(Dimension,1,1);
        if ifMutate
            child(i,MutPoint) = ~child(i,MutPoint);
        end
    end
    
    initPop = child(1:PopSize,:);
end

tempynm1 = bestPop(DroneLocs + 1:end);
T1 = (reshape(tempynm1,DroneLocs,n))';
tempynm2 = (reshape(tempynm1,DroneLocs,n))'.*realYnm;

ynm = reshape(tempynm2',1,DroneLocs*n);
bestPop(DroneLocs + 1:end) = ynm;

xm = bestPop(1:DroneLocs);

% repair routine
ConstCheck = RepairBestSolution(xm,tempynm2,St_Data);

% final results
St_Results.xm = xm;
St_Results.ynm = tempynm2;
St_Results.bestGeneration = bestGeneration;
St_Results.bestPop = bestPop;
St_Results.bestValPerIter = bestValPerIter;
St_Results.ConstCheck = ConstCheck;

