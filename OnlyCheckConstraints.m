function [constraint,constNum] = OnlyCheckConstraints(St_Data,ynm,xm)

DroneLocs = St_Data.totalDroneLocs;
n = St_Data.n;
m = DroneLocs;
beta = St_Data.beta;

gammaMax = St_Data.gammaMax;
gammaMin = St_Data.gammaMin;
costVec = St_Data.costVec;
MaxCost = St_Data.MaxCost;
MaxDist = St_Data.MaxDist;
DistMatrix = St_Data.DistMatrix;



% Constraint 1
const1 = sum(sum(ynm)) < beta*n;

% Constraint 2
TempXm = repmat(xm,n,1);
TempConst2 = ynm > TempXm;
const2 = reshape(TempConst2',n*m,1)';

% Constraint 3
k = 1;
const3 = zeros(1,n);
for i = 1:n
    const3(k) = sum(ynm(i,:)) > 1;
    k = k + 1;
end

% Constraint 4
k = 1;
const4 = zeros(1,m);
for j = 1:m
    const4(k) = sum(ynm(:,j)) > gammaMax*xm(j);
    k = k + 1;
end

% Constraint 5
k = 1;
const5 = zeros(1,m);
for j = 1:m
    const5(k) = sum(ynm(:,j)) < gammaMin*xm(j);
    k = k + 1;
end

% Constraint 6
const6 = sum(xm.*costVec) > MaxCost;

% Constraint 7
TempMaxDist = repmat(MaxDist,n,m);
TempDiff1 = TempMaxDist - DistMatrix; 
xyz = TempDiff1 >= 0;
TempDiff1(xyz) = 1;
TempDiff2 = ynm > max(0,TempDiff1);
const7 = reshape(TempDiff2',n*m,1)';

%--------------------------------------------------------------
% Return
%--------------------------------------------------------------
constraint = [const1,const2,const3,const4,const5,const6,const7];
constNum = [sum(const1),sum(const2),sum(const3),sum(const4)...
,sum(const5),sum(const6),sum(const7)];
%--------------------------------------------------------------


