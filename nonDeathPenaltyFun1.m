% non-death penalty approach 1 (Evolutionary Optimization Algorithms Dan Simon page 486)
function [theta] = nonDeathPenaltyFun1(St_Data)

currPop = St_Data.currPop;
betaConst = St_Data.betaConst;
DroneLocs = St_Data.totalDroneLocs;
n = St_Data.n;
m = DroneLocs;

xm = currPop(1:DroneLocs);
tempynm = currPop(DroneLocs + 1:end);
ynm = (reshape(tempynm,DroneLocs,n))';
gammaMax = St_Data.gammaMax;
gammaMin = St_Data.gammaMin;
costVec = St_Data.costVec;
MaxCost = St_Data.MaxCost;
MaxDist = St_Data.MaxDist;
DistMatrix = St_Data.DistMatrix;
beta = St_Data.beta;

% Constraint 1: sum(sum(ynm)) >= beta*N
a = (max(0,beta*n - sum(sum(ynm))))^betaConst;

% Constraint 2: ynm <= xm
TempXm = repmat(xm,n,1);
TempZeros = zeros(n,m);
TempDiff = ynm - TempXm;
TempG = max(TempZeros,TempDiff).^betaConst;
b = reshape(TempG',n*m,1)';

% Constraint 3: sum(ynm) <= 1, forall n
TempYnm = sum(ynm,2);
TempOnes = ones(n,1);
TempZeros = zeros(n,1);
TempDiff = TempYnm - TempOnes;
TempG = max(TempZeros,TempDiff).^2;
c = TempG';

% Constraint 4: sum(ynm) <= gammaMax*xm, forall n
k = 1;
d = zeros(1,m);
for j = 1:m
    d(k) = (max(0,sum(ynm(:,j)) - gammaMax*xm(j)))^betaConst;
    k = k + 1;    
end

% Constraint 5: sum(ynm) >= gammaMin*xm, forall n
k = 1;
e = zeros(1,m);
for j = 1:m
    e(k) = (max(0,gammaMin*xm(j) - sum(ynm(:,j))))^betaConst;
    k = k + 1;    
end

% Constraint 6: sum(cm*xm) <= MaxCost
f = (max(0,sum(costVec.*xm) - MaxCost))^betaConst;

% Constraint 7: ynm <= max(0,DMax - dnm)
TempZeros = zeros(n,m);
TempMaxDist = repmat(MaxDist,n,m);
TempDiff1 = TempMaxDist - DistMatrix; 
xyz = TempDiff1 >= 0;
TempDiff1(xyz) = 1;
TempDiff2 = ynm - max(0,TempDiff1);
TempG = max(TempZeros,TempDiff2).^betaConst;
g = reshape(TempG',n*m,1)';

h = [a,b,c,d,e,f,g];
% disp(num2str(length(h)));


fx = sum(xm)/(sum(sum(ynm)));
theta = fx + sum(h);



