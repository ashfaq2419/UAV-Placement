function [A,b] = genUnEqualConstraints(St_Data)

n = St_Data.n;
DroneLocs = St_Data.totalDroneLocs;
MaxCost = St_Data.MaxCost;
gammaMin = St_Data.gammaMin;
gammaMax = St_Data.gammaMax;
costVec = St_Data.costVec;
beta = St_Data.beta;

%% constraint#1; sum(sum(ynm)) >= beta*n
TempXm  = zeros(1,DroneLocs);
TempYnm = -ones(1,n*DroneLocs);
TempZm  = zeros(1,DroneLocs);
TempWnm = zeros(1,n*DroneLocs);
TempTm  = 0;
A1 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b1 = -beta*n;

%% constraint#2: ynm <= xm, forall n,m
TempXm  = repmat(-eye(DroneLocs),n,1);
TempYnm = eye(n*DroneLocs);
TempZm  = zeros(n*DroneLocs,DroneLocs);
TempWnm = zeros(n*DroneLocs,n*DroneLocs);
TempTm  = zeros(n*DroneLocs,1);
A2 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b2 = zeros(n*DroneLocs,1);

%% constraint#3: sum(ynm) <= 1, forall n
tempYnm1 = zeros(n,n*DroneLocs);
offSet = 1;
for i = 1:n
    tempYnm1(i,offSet:offSet+DroneLocs-1) = ones(1,DroneLocs);
    offSet = offSet + DroneLocs;
end
TempXm  = zeros(n,DroneLocs);
TempYnm = tempYnm1;
TempZm  = zeros(n,DroneLocs);
TempWnm = zeros(n,n*DroneLocs);
TempTm  = zeros(n,1);
A3 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b3 = ones(n,1);

%% constraint#4: sum(ynm) <= xm*GammaMax, forall m
TempXm  = -gammaMax*eye(DroneLocs);
TempYnm = repmat(eye(DroneLocs),1,n);
TempZm  = zeros(DroneLocs,DroneLocs);
TempWnm = zeros(DroneLocs,n*DroneLocs);
TempTm  = zeros(DroneLocs,1);
A4 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b4 = zeros(DroneLocs,1);

%% constraint#5: sum(ynm) >= xm*GammaMin, forall m
TempXm  = gammaMin*eye(DroneLocs);
TempYnm = repmat(-eye(DroneLocs),1,n);
TempZm  = zeros(DroneLocs,DroneLocs);
TempWnm = zeros(DroneLocs,n*DroneLocs);
TempTm  = zeros(DroneLocs,1);
A5 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b5 = zeros(DroneLocs,1);

%% constraint#6: sum(xm*cm) <= Cmax
TempXm  = costVec;
TempYnm = zeros(1,n*DroneLocs);
TempZm  = zeros(1,DroneLocs);
TempWnm = zeros(1,n*DroneLocs);
TempTm  = 0;
A6 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b6 = MaxCost;

%% constraint#7
% Distant constraint is used as an upper bound to Ynm
% C8 and C9 are bounds of xm and ynm

%% constraint#10
% Equal constraint from other .m file

%% constraint#11: t - zm <= 1 - xm, forall m
TempXm  = eye(DroneLocs);
TempYnm = zeros(DroneLocs,n*DroneLocs);
TempZm  = -eye(DroneLocs);
TempWnm = zeros(DroneLocs,n*DroneLocs);
TempTm  = ones(DroneLocs,1);
A11 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b11 = ones(DroneLocs,1);

%% constraint#12: zm <= t, forall m
TempXm  = zeros(DroneLocs,DroneLocs);
TempYnm = zeros(DroneLocs,n*DroneLocs);
TempZm  = eye(DroneLocs);
TempWnm = zeros(DroneLocs,n*DroneLocs);
TempTm  = -ones(DroneLocs,1);
A12 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b12 = zeros(DroneLocs,1);

%% constraint#13: zm <= xm, forall m
TempXm  = -eye(DroneLocs);
TempYnm = zeros(DroneLocs,n*DroneLocs);
TempZm  = eye(DroneLocs);
TempWnm = zeros(DroneLocs,n*DroneLocs);
TempTm  = zeros(DroneLocs,1);
A13 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b13 = zeros(DroneLocs,1);

%% constraint#14: t - wmn <= 1 - ymn, forall m,n
TempXm  = zeros(n*DroneLocs,DroneLocs);
TempYnm = eye(n*DroneLocs);
TempZm  = zeros(n*DroneLocs,DroneLocs);
TempWnm = -eye(n*DroneLocs);
TempTm  = ones(n*DroneLocs,1);
A14 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b14 = ones(DroneLocs*n,1);

%% constraint#15: wmn <= t, forall m,n
TempXm  = zeros(n*DroneLocs,DroneLocs);
TempYnm = zeros(n*DroneLocs,n*DroneLocs);
TempZm  = zeros(n*DroneLocs,DroneLocs);
TempWnm = eye(n*DroneLocs);
TempTm  = -ones(n*DroneLocs,1);
A15 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b15 = zeros(DroneLocs*n,1);

%% constraint#16: wmn <= ymn, forall m,n
TempXm  = zeros(n*DroneLocs,DroneLocs);
TempYnm = -eye(n*DroneLocs);
TempZm  = zeros(n*DroneLocs,DroneLocs);
TempWnm = eye(n*DroneLocs);
TempTm  = zeros(DroneLocs*n,1);
A16 = [TempXm,TempYnm,TempZm,TempWnm,TempTm];
b16 = zeros(DroneLocs*n,1);

%% All constraints
A = [A1;A2;A3;A4;A5;A6;A11;A12;A13;A14;A15;A16];
b = [b1;b2;b3;b4;b5;b6;b11;b12;b13;b14;b15;b16];