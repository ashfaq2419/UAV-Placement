function St_Results = RunEDA(St_Data,St_Algo)

Generations = St_Algo.gSize;
initPop = St_Data.initPop;
PopSize = St_Algo.pSize;
SelProb = St_Algo.SelProb;
Dimension = St_Algo.Dimension;

bestFitnessVal = inf;
bestValue = 0;
bestValPerIter = zeros(1,Generations);
bestPopPerIter = zeros(Generations,Dimension);
bestGeneration = 0;
bestPop = zeros(1,Dimension);
DroneLocs = St_Data.totalDroneLocs;
n = St_Data.n;

nCount = 0;
preval = inf;

theta = zeros(1,PopSize);

%% main EDA simulation
for g = 1:Generations    
    for p = 1:PopSize
        St_Data.currPop = initPop(p,:);
        theta(p) = nonDeathPenaltyFun1(St_Data); % non-death penalty approach 1 (Evolutionary Optimization Algorithms Dan Simon page 486)
    end
    
    [val,indx] = sort(theta,'ascend');
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
    
    if(preval ~= bestFitnessVal)
        preval = bestFitnessVal;
        nCount = 0;
    else
        nCount = nCount + 1;
    end
    
    newProbabilities1 = sum(SelPop)/nSelPop;
    if St_Algo.isThresholding
        if nCount > St_Algo.nCountThreshold
            nCount = 0;
            Prob_H = 0.90;
            Prob_L = 0.10;
            for i = 1:Dimension
                if newProbabilities1(i) >= 0.99
                    newProbabilities1(i) = Prob_H;
                elseif newProbabilities1(i) <= 0.01
                    newProbabilities1(i) = Prob_L;
                end
            end  %% end i
        end        
    end
    
    newProbabilities2 = repmat(newProbabilities1,PopSize,1);
    initPop = rand(PopSize,Dimension) < newProbabilities2;
end

%-------------------------------------------------------------------------
tempynm1 = bestPop(DroneLocs + 1:end);
tempynm2 = (reshape(tempynm1,DroneLocs,n))';

xm = bestPop(1:DroneLocs);
ynm = tempynm2;

[xm,ynm,St_Data,~] = RepairBestSolution(xm,ynm,St_Data);
[ConstraintViolations,~] = OnlyCheckConstraints(St_Data,ynm,xm);

% final results
St_Results.xm = xm;
St_Results.ynm = ynm;
St_Results.bestGeneration = bestGeneration;
St_Results.bestValPerIter = bestValPerIter;
St_Results.ConstraintViolations = ConstraintViolations;
if St_Data.BestPopSaveFlag
    St_Results.BestPopPerIteration = bestPopPerIter;
end
St_Results.exitflag = [];

fx = sum(xm)/sum(sum(ynm));
St_Results.fval = fx;

