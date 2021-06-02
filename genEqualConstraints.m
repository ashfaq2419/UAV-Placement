function [Aeq,beq] = genEqualConstraints(St_Data)

alpha = St_Data.alpha;
n = St_Data.n;
totalDroneLocs = St_Data.totalDroneLocs;

%% constraint#7: sum(wnm) = 1. forall m
TempXm  = zeros(1,totalDroneLocs);
TempYnm = zeros(1,n*totalDroneLocs);
TempZm  = zeros(1,totalDroneLocs);
TempWnm = alpha*ones(1,n*totalDroneLocs);
TempTm  = 0;

Aeq = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
beq = 1;