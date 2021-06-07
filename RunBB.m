function St_Results = RunBB(St_Data)


%%
% variables: 
% | x1 ... xm | y11 ... ynm | z1 ... zm | w11 ... wnm | t |

n = St_Data.n;
DroneLocs = St_Data.totalDroneLocs;
alpha = St_Data.alpha;

totalVars = DroneLocs + n*DroneLocs + DroneLocs + n*DroneLocs + 1;

%==================================================================
% L_E = 1; % Last Index;
%==================================================================
St_Data.xS = 1; 
St_Data.xE = 1*DroneLocs; 
St_Data.LE = St_Data.xE; 
%--------------------------------------------------------
St_Data.yS = St_Data.LE + 1;       
St_Data.yE = St_Data.yS + (n*DroneLocs)-1; 
St_Data.LE = St_Data.yE;
%--------------------------------------------------------
St_Data.zS = St_Data.LE + 1;       
St_Data.zE = St_Data.zS + DroneLocs - 1; 
St_Data.LE = St_Data.zE;
%--------------------------------------------------------
St_Data.wS = St_Data.LE + 1;       
St_Data.wE = St_Data.wS + (n*DroneLocs) - 1; 
St_Data.LE = St_Data.wE;
%--------------------------------------------------------
St_Data.tS = St_Data.LE + 1;      
St_Data.tE = St_Data.tS + 1 - 1; 
St_Data.LE = St_Data.tE;

%% Branch & Bound

objFun = [zeros(1,DroneLocs),zeros(1,n*DroneLocs),alpha*ones(1,DroneLocs),...
    zeros(1,n*DroneLocs),0];
[A,b] = genUnEqualConstraints(St_Data);
[Aeq,beq] = genEqualConstraints(St_Data);

DMax = St_Data.MaxDist;
DMaxMat = repmat(DMax,n,DroneLocs);
YMatTmp = (DMaxMat-St_Data.DistMatrix) >= 0; 
YVec = reshape(YMatTmp',1,n*DroneLocs);

%---------------------------
% 0 < t <= 1
t_lb = 0.001;
%---------------------------

intcont = 1:(DroneLocs+n*DroneLocs);
lb = [zeros(1,DroneLocs),zeros(1,n*DroneLocs),zeros(1,DroneLocs),...
    zeros(1,n*DroneLocs),t_lb];
ub = [ones(1,DroneLocs),YVec,inf*ones(1,DroneLocs),...
    inf*ones(1,n*DroneLocs),1];

opts = optimoptions('intlinprog','Display','off','MaxTime',120);
%opts = optimoptions(opts,'LPMaxIter',100,'MaxNodes',10000,'Display','off');
%opts = optimoptions('intlinprog','LPMaxIter',100,'MaxNodes',1000,'Display','off','MaxTime',120);
%[x,fval,exitflag,~] = intlinprog(objFun,intcont,A,b,Aeq,beq,lb,ub,opts);
[x,fval,exitflag,~] = intlinprog(objFun,intcont,A,b,Aeq,beq,lb,ub,opts);

% test
if exitflag >= 1
    x = x(1:(DroneLocs+n*DroneLocs))';
    xm  = x(1,St_Data.xS:St_Data.xE);
    ynm = x(1,St_Data.yS:St_Data.yE);
    ynm2 = reshape(ynm,DroneLocs,n)';

    %% Plot results
    St_Results.xm = xm;
    St_Results.ynm = ynm2;
    St_Results.fval = fval;
    St_Results.exitflag = exitflag;
    St_Results.bestGeneration = [];
    St_Results.bestValPerIter = [];
    St_Results.ConstraintViolations = [];
    St_Results.BestPopPerIteration = [];
else
    St_Results.xm = [];
    St_Results.ynm = [];
    St_Results.fval = [];
    St_Results.exitflag = exitflag;
    St_Results.bestGeneration = [];
    St_Results.bestValPerIter = [];
    St_Results.ConstraintViolations = [];
    St_Results.BestPopPerIteration = [];
end





