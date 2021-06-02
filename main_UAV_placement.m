% Problem : UAV placement problem 
% Written by : Ashfaq Ahmed
% Year : 2019-20

clear;
close all;
clc;

%% Common variables
fileSave = 0;
MonteCarloIterations = 2;
St_Data.BestPopSaveFlag = 1;

%-------------------------------------------------------------
% Scenario constants
%-------------------------------------------------------------

Scenarios = [
    1 20 2 0.4;
    1 20 3 0.4;
    1 40 2 0.4;
    1 40 3 0.4;
    1 60 2 0.4;
    1 60 3 0.4;
    1 80 2 0.4;
    1 80 3 0.4;
    1 100 2 0.4;
    1 100 3 0.4;
    1 20 2 0.6;
    1 20 3 0.6;
    1 40 2 0.6;
    1 40 3 0.6;
    1 60 2 0.6;
    1 60 3 0.6;
    1 80 2 0.6;
    1 80 3 0.6;
    1 100 2 0.6;
    1 100 3 0.6
    ];

UserMax = max(Scenarios(:,2));

% Grid
maxGrid = 100;

% Budget
unitCost = 100;

St_Data.gammaMin = 5;
St_Data.gammaMax = 15; 

St_Data.alpha = 1; % used only in RunBB (Branch & Bound)

%-------------------------------------------------------------
% Evolutionary algorithms general variables            
St_Algo.SelProb = 0.5;
St_Algo.isThresholding = 1;
St_Algo.nCountThreshold = 5;
%-------------------------------------------------------------

St_Data.DisplayUserNum = 0;
St_Data.unitCost = unitCost;
St_Data.IsCoverageRequired = 0;

St_Data.maxGrid = maxGrid;
St_Data.UserMax = UserMax;

%% Create cell to store results
TotalScenarios = size(Scenarios,1);
MyCell = cell(MonteCarloIterations,TotalScenarios);

TotalSimulations = MonteCarloIterations*TotalScenarios;
CurrSimulation = 1;

%% User locations: Place users using uniform random distribution
St_Data.MaxUserLocs = getUserLocations(St_Data,UserMax);
tic;

%% Run simulations for all scenarios
for s = 1:size(Scenarios,1)
    betaConst = Scenarios(s,1);
    n = Scenarios(s,2);
    m = Scenarios(s,3);
    beta = Scenarios(s,4);

    DroneLocs = m*m;  
    MaxCost = unitCost*DroneLocs;
    costVec = 10*ones(1,DroneLocs);
    TotalVariables = DroneLocs + (DroneLocs*n);

    St_Algo.pSize = TotalVariables*2;

    St_Data.n = n;
    St_Data.costVec = costVec;
    St_Data.beta = beta;
    St_Data.MaxCost = MaxCost;        
    St_Data.m = m;
    St_Data.totalDroneLocs = DroneLocs;        
    St_Data.MaxDist = sqrt((maxGrid/(m+2))^2 + (maxGrid/(m+2))^2) + 10;        
    St_Data.ynm = zeros(St_Data.n,DroneLocs);               
    St_Data.betaConst = betaConst;         
    St_Data.nConstraints = 1 + n*DroneLocs + n + DroneLocs + DroneLocs + 1 + n*DroneLocs; 

    % Get the expected locations for the UAVs
    St_Data = getDronesLocations(St_Data);
    St_Data.userLocs = St_Data.MaxUserLocs(1:St_Data.n,:);
    
    % Get the distances of all users from all UAVs
    [St_Data.MaxDistMatrix,St_Data.MaxRealYnm] = getDistMatrix(St_Data);
    
    St_Data.DistMatrix = St_Data.MaxDistMatrix(1:St_Data.n,:);
    St_Data.realYnm = St_Data.MaxRealYnm(1:St_Data.n,:);
    
    % Run branch and bound
    disp('BB starts');
    St_ResultsTemp = RunBB(St_Data);
    
    t = toc;
    St_ResultsTemp.Time = t;
    St_Results.St_ResultsBB = St_ResultsTemp;    
    disp(['Total time taken by BB: ' num2str(t) ' seconds']);
    
    if St_Results.St_ResultsBB.exitflag > 0
        for iter = 1:MonteCarloIterations  
            tic
            disp(['Iteration# ' num2str(CurrSimulation) '/' num2str(TotalSimulations) ' executing']);   
            disp(['Scenario: ',num2str(s),', MonteCarlo: ',num2str(iter)]);
            disp(['BetaPenalty: ',num2str(betaConst),', Users: ',num2str(n),...
                ', DroneLocs: ',num2str(DroneLocs),', Beta: ',num2str(beta)]);        

            %-----------------------------------------------
            % EA code
            %-----------------------------------------------                        
            St_Algo.Dimension = TotalVariables;
            St_Algo.gSize = 100;
            St_Data.initPop = rand(St_Algo.pSize,St_Algo.Dimension) < 0.5;
            for p = 1:1
                St_Data.Penalty = p;
                % Call GA
                disp('GA starts');
                St_Results.St_ResultsGA = RunGA(St_Data,St_Algo);
                St_Data.AlgoNum = 1;
                % Call EDA
                disp('EDA starts');                
                St_ResultsTemp = RunEDA(St_Data,St_Algo);
                t = toc;
                St_ResultsTemp.Time = t;
                St_Results.St_ResultsEDA = St_ResultsTemp;
                disp(['Violations : ',num2str(sum(St_ResultsTemp.ConstraintViolations))]);
            end  
            
            disp(['Total time taken by EDA: ' num2str(t) ' seconds']);
            disp('________________________________________________________');            

            MyCell{iter,s} = St_Results;
            CurrSimulation = CurrSimulation + 1;
        end
    end
end

if t < 60
    disp(['Total simulation time : ' num2str(t) ' seconds']);
elseif t > 59 && t < 3600
    disp(['Total simulation time : ' num2str(t/60) ' minutes']);
else
    disp(['Total simulation time : ' num2str(t/3600) ' hours']);
end

MinUsers = min(Scenarios(:,2));
MaxUsers = max(Scenarios(:,2));

MinDrones = min(Scenarios(:,3))^2;
MaxDrones = max(Scenarios(:,3))^2;

MinBeta = min(Scenarios(:,4));
MaxBeta = max(Scenarios(:,4));

if fileSave == 1
    time = now;
    str = datestr(time,0);
    str_index=strfind(str,':');
    str(str_index(1,1)) = '_';
    str(str_index(1,2)) = '_';
    str1 = ['DroneLocs','_Users_',num2str(MinUsers),'_and_',num2str(MaxUsers),...
        '_DroneLocs_',num2str(MinDrones),'_and_',num2str(MaxDrones),...
        '_Beta_',num2str(MinBeta),'_and_',num2str(MaxBeta),'_',str,'.mat'];
    save(str1);
end