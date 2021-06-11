clc;
close all;
clear;

load('Data/DroneLocs_Users_20_and_100_DroneLocs_4_and_9_Beta_0.4_and_0.6_18-Jun-2020 17_42_09.mat');

% load(['Data/DroneLocs_Users_20_and_40_DroneLocs_4_and_9_',...
%     'Beta_0.2_and_0.3_BetaPenalty_1_21-Apr-2020 14_38_34.mat']);

% load(['Data/DroneLocs_Users_20_and_40_DroneLocs_4_and_9_Beta_0.3_and_0.3_21-Apr-2020 16_20_32.mat']);

%load('Data/DroneLocs_Users_20_and_40_DroneLocs_4_and_9_Beta_0.3_and_0.5_23-Apr-2020 14_43_50.mat');

% load('Data/DroneLocs_Users_100_and_100_DroneLocs_9_and_9_Beta_0.4_and_0.6_23-Apr-2020 21_44_01.mat')


BBvsEDAfitness = 0;
BBvsEDAdrones = 0;
BBvsEDAusers = 0;
BBvsEDAtime = 0;
EDAconstraintViolationTrend = 0;
fitness_vs_iterations = 1;

% Scenarios = Scenarios(1:6,:);

%% Plot fitness comparison
if BBvsEDAfitness
    nScenarios = size(Scenarios,1);
    FitnessValBB = zeros(MonteCarloIterations,nScenarios);
    FitnessValEDA = zeros(MonteCarloIterations,nScenarios);
    nCount = zeros(1,nScenarios);
    l = 1;
    for j = 1:nScenarios
        for i = 1:MonteCarloIterations    
            Flag1 = MyCell{i,j}.St_ResultsBB.exitflag;
            Flag2 = sum(MyCell{i,j}.St_ResultsEDA.ConstraintViolations);   
            if Flag1 > 0 && Flag2 == 0
                FitnessValBB(i,l) = MyCell{i,j}.St_ResultsBB.fval;
                FitnessValEDA(i,l) = MyCell{i,j}.St_ResultsEDA.fval;
                nCount(1,l) = nCount(1,l) + 1;
            end
        end
        l = l + 1;
    end
    
    if MonteCarloIterations > 1
        AvgFitnessValBB = sum(FitnessValBB)./nCount;
        AvgFitnessValEDA = sum(FitnessValEDA)./nCount;
    else
        AvgFitnessValBB = FitnessValBB;
        AvgFitnessValEDA = FitnessValEDA;
    end

    figure;
    bar(AvgFitnessValEDA,0.7,'FaceColor',[0.3 0.3 0.3],'EdgeColor','k');
    hold on;
    bar(AvgFitnessValBB,0.3,'FaceColor',[0.85 0.85 0.85],'EdgeColor','k');
    xlabel('Scenarios');
    ylabel('Average fitness');
    legend('PLA','B&B');
    xticks(1:nScenarios);
    xticklabels(1:nScenarios);
    axis([0 nScenarios+1 0 max(max(AvgFitnessValEDA),max(AvgFitnessValEDA))+0.05]);
    grid on;
end

%% Plot drone placement comparison
if BBvsEDAdrones
    nScenarios = size(Scenarios,1);
    DronesBB = zeros(MonteCarloIterations,nScenarios);
    DronesEDA = zeros(MonteCarloIterations,nScenarios);
    nCount = zeros(1,nScenarios);
    l = 1;
    for j = 1:nScenarios
        for i = 1:MonteCarloIterations    
            Flag1 = MyCell{i,j}.St_ResultsBB.exitflag;
            Flag2 = sum(MyCell{i,j}.St_ResultsEDA.ConstraintViolations);   
            if Flag1 > 0 && Flag2 == 0
                DronesBB(i,l) = sum(MyCell{i,j}.St_ResultsBB.xm);
                DronesEDA(i,l) = sum(MyCell{i,j}.St_ResultsEDA.xm);
                nCount(l) = nCount(l) + 1;
            end
        end
        l = l + 1;
    end

    if MonteCarloIterations > 1
        AvgDronesBB = sum(DronesBB)./nCount;
        AvgDronesEDA = sum(DronesEDA)./nCount;
    else
        AvgDronesBB = DronesBB;
        AvgDronesEDA = DronesEDA;
    end

    figure;
    bar(AvgDronesEDA,0.7,'FaceColor',[0.3 0.3 0.3],'EdgeColor','k');
    hold on;
    bar(AvgDronesBB,0.3,'FaceColor',[0.85 0.85 0.85],'EdgeColor','k');
    xlabel('Scenarios');
    ylabel('Average drone placements');
    legend('PLA','B&B');
    xticks(1:nScenarios);
    xticklabels(1:nScenarios);
    axis([0 nScenarios+1 0 max(max(AvgDronesEDA),max(AvgDronesBB))+0.2]);
    grid on;
end

%% Plot user connections comparison
if BBvsEDAusers
    nScenarios = size(Scenarios,1);
    UsersBB = zeros(MonteCarloIterations,nScenarios);
    UsersEDA = zeros(MonteCarloIterations,nScenarios);
    nCount = zeros(1,nScenarios);
    l = 1;
    for j = 1:nScenarios
        for i = 1:MonteCarloIterations    
            Flag1 = MyCell{i,j}.St_ResultsBB.exitflag;
            Flag2 = sum(MyCell{i,j}.St_ResultsEDA.ConstraintViolations);   
            if Flag1 > 0 && Flag2 == 0
                UsersBB(i,l) = sum(sum(MyCell{i,j}.St_ResultsBB.ynm));
                UsersEDA(i,l) = sum(sum(MyCell{i,j}.St_ResultsEDA.ynm));
                nCount(l) = nCount(l) + 1;
            end
        end
        l = l + 1;
    end

    AvgUsersBB = sum(UsersBB)./nCount;
    AvgUsersEDA = sum(UsersEDA)./nCount;

    figure;
    bar(AvgUsersEDA,0.7,'FaceColor',[0.3 0.3 0.3],'EdgeColor','k');
    hold on;
    bar(AvgUsersBB,0.3,'FaceColor',[0.85 0.85 0.85],'EdgeColor','k');
    xlabel('Scenarios');
    ylabel('Average User connections');
    legend('PLA','B&B');
    xticks(1:nScenarios);
    xticklabels(1:nScenarios);
    axis([0 nScenarios+1 0 max(max(AvgUsersEDA),max(AvgUsersBB))+5]);
    grid on;
end

%% Time comparison of BB and EDA
if BBvsEDAtime
    nScenarios = size(Scenarios,1);
    TimeBB = zeros(MonteCarloIterations,nScenarios);
    TimeEDA = zeros(MonteCarloIterations,nScenarios);
    nCount = zeros(1,nScenarios);
    l = 1;
    for j = 1:nScenarios
        for i = 1:MonteCarloIterations    
            Flag1 = MyCell{i,j}.St_ResultsBB.exitflag;
            Flag2 = sum(MyCell{i,j}.St_ResultsEDA.ConstraintViolations);   
            if Flag1 > 0 && Flag2 == 0
                TimeBB(i,l) = MyCell{i,j}.St_ResultsBB.Time;
                TimeEDA(i,l) = MyCell{i,j}.St_ResultsEDA.Time;
                nCount(l) = nCount(l) + 1;
            end
        end
        l = l + 1;
    end

    AvgTimeBB = sum(TimeBB)./nCount;
    AvgTimeEDA = sum(TimeEDA)./nCount;

    figure;
    bar(AvgTimeEDA,0.7,'FaceColor',[0.3 0.3 0.3],'EdgeColor','k');
    hold on;
    bar(AvgTimeBB,0.3,'FaceColor',[0.85 0.85 0.85],'EdgeColor','k');
    xlabel('Scenarios');
    ylabel('Average Time (Seconds)');
    legend('PLA','B&B');
    xticks(1:nScenarios);
    xticklabels({'7','8','9'});
    axis([0 nScenarios+1 0 max(max(AvgTimeEDA),max(AvgTimeBB))+10]);
    grid on;
end

%% Constraint violation trend in EDA

if EDAconstraintViolationTrend
    lineStyles = {'-','-','-','-','-','--','--','--','--','--'};
    lineColor = {'r','g','b','m','k','r','g','b','m','k'};
    LineWidth = 1.5;
    
    nScenarios = size(Scenarios,1);
    Violations = zeros(MonteCarloIterations,St_Algo.gSize+1);
    ThisScenarioTrend = zeros(nScenarios,St_Algo.gSize+1);
    ThisScenarioBestValPerIteration = zeros(nScenarios,St_Algo.gSize);
    nCount = zeros(1,nScenarios);
    for j = 1:nScenarios
        St_Data.m = Scenarios(j,3);
        St_Data.n = Scenarios(j,2);
        St_Data.beta = Scenarios(j,4);
        
        St_Data.totalDroneLocs = St_Data.m*St_Data.m;
        St_Data = getDronesLocations(St_Data);
        St_Data.userLocs = St_Data.MaxUserLocs(1:St_Data.n,:);
                
        DroneLocs = St_Data.totalDroneLocs;

        St_Data.gammaMin = 5;%round(0.06*St_Data.n);
        St_Data.gammaMax = 15;%round(0.25*St_Data.n); 
        St_Data.costVec = 10*ones(1,DroneLocs);
        St_Data.MaxCost = unitCost*DroneLocs;
        St_Data.MaxDist = sqrt((maxGrid/(St_Data.m+2))^2 + (maxGrid/(St_Data.m+2))^2) + 10;
        
        [St_Data.MaxDistMatrix,St_Data.MaxRealYnm] = getDistMatrix(St_Data);
        St_Data.DistMatrix = St_Data.MaxDistMatrix(1:St_Data.n,:);     
        n = St_Data.n;
        nConstraints = 1 + n*DroneLocs + n + DroneLocs + DroneLocs + 1 + n*DroneLocs;
        
        nCount = 0;
        BestValuePerIteration = zeros(MonteCarloIterations,St_Algo.gSize);
        for i = 1:MonteCarloIterations    
            BestPopPerIteration = MyCell{i,j}.St_ResultsEDA.BestPopPerIteration; 
            BestValuePerIteration(i,:) = MyCell{i,j}.St_ResultsEDA.bestValPerIter;
            for k = 1:size(BestPopPerIteration,1)
                TempYnm = BestPopPerIteration(k,DroneLocs+1:end);
                ynm = reshape(TempYnm,DroneLocs,St_Data.n)';
                xm = BestPopPerIteration(k,1:DroneLocs);
                [TempViolations,~] = OnlyCheckConstraints(St_Data,ynm,xm);
                Violations(i,k) = sum(TempViolations);
                nCount = nCount + 1;
            end
            ynm = MyCell{i,j}.St_ResultsEDA.ynm;
            xm = MyCell{i,j}.St_ResultsEDA.xm;
            [TempViolations,~] = OnlyCheckConstraints(St_Data,ynm,xm);
            Violations(i,k+1) = sum(TempViolations);
        end
        ThisScenarioBestValPerIteration(j,:) = sum(BestValuePerIteration)/MonteCarloIterations;
        ThisScenarioTrend(j,:) = sum(Violations)/MonteCarloIterations; 
        ThisScenarioTrend(j,:) = ThisScenarioTrend(j,:)./nConstraints*100;
    end
    
    q = 1;
    figure(1);
    hold on;
    for p = 1:nScenarios        
        if mod(p,2)~=0
            ThisLineStyle = [lineStyles{q},lineColor{q}];%,MarkerStyle{q}];
            txt = ['Scenario = ',num2str(p)];
            plot(1:St_Algo.gSize+1,ThisScenarioTrend(p,:),ThisLineStyle,...
                'DisplayName',txt,'LineWidth',LineWidth);
            ylabel('Average constraints violations (%)');
            xlim([0 St_Algo.gSize+1]);
            grid on;
            q = q + 1
        end
    end
    xlabel('PLA Iterations'); 
    hold off;
    legend show;
    
    q = 1;
    figure(2);
    hold on;
    for p = 1:nScenarios
        if mod(p,2)==0
            ThisLineStyle = [lineStyles{q},lineColor{q}];%,MarkerStyle{q}];
            txt = ['Scenario = ',num2str(p)];
%             plot(1:St_Algo.gSize+1,ThisScenarioTrend(p,:),'DisplayName',txt,'LineWidth',LineWidth);
            plot(1:St_Algo.gSize+1,ThisScenarioTrend(p,:),ThisLineStyle,...
                'DisplayName',txt,'LineWidth',LineWidth);
            ylabel('Average constraints violations (%)');
            xlim([0 St_Algo.gSize+1]);            
            grid on;
            q = q + 1;
        end        
    end
    xlabel('PLA Iterations'); 
    hold off;
    legend show;
    
%     figure;
%     q = 1;
%     for p = 1:nScenarios
%         ThisLineStyle = [lineStyles{q},'k'];%,MarkerStyle{q}];
%         plot(1:St_Algo.gSize,ThisScenarioBestValPerIteration(p,:),ThisLineStyle,'LineWidth',LineWidth);
%         ylabel('Fitness vs. Iterations');
%         hold on;
%         grid on;
%         q = q + 1;
%     end
%     xlim([0 St_Algo.gSize+1]);
%     xlabel('PLA Iterations');       
%     legend('Scenario 2','Scenario 4','Scenario 6');
    
%     figure;
%     q = 1;
%     for p = 2:2:nScenarios
%         ThisLineStyle = [lineStyles(q),'k',MarkerStyle(q)];
%         plot(1:St_Algo.gSize+1,ThisScenarioTrend(p,:),ThisLineStyle);
%         hold on;
%         grid on;
%         q = q + 1;
%     end
%     xlim([0 St_Algo.gSize+1]);
%     xlabel('EDA Iterations');
%     ylabel('Average constraints violations');
%     legend('Scenario 2','Scenario 4','Scenario 6');
end

%% fitness vs. iterations
if fitness_vs_iterations
    lineStyles = {'-','-','-','-','-','--','--','--','--','--'};
    lineColor = {'r','g','b','m','k','r','g','b','m','k'};
    LineWidth = 1.5;
    
    nScenarios = size(Scenarios,1);
    for j = 1:nScenarios
        for i = 1:MonteCarloIterations        
            TempBestValPerIteration(i,:) = MyCell{i,j}.St_ResultsEDA.bestValPerIter;   
        end        
        AvgBestValPerIteration(j,:) = sum(TempBestValPerIteration)/MonteCarloIterations;
    end
    
    q = 1;
    figure(1);
    hold on;
    for p = 1:nScenarios        
        if mod(p,2)~=0
            ThisLineStyle = [lineStyles{q},lineColor{q}];%,MarkerStyle{q}];
            txt = ['Scenario = ',num2str(p)];
            plot(1:St_Algo.gSize,AvgBestValPerIteration(p,:),ThisLineStyle,...
                'DisplayName',txt,'LineWidth',LineWidth);
            ylabel('Average fitness');
            xlim([0 St_Algo.gSize+1]);
            grid on;
            q = q + 1
        end
    end
    xlabel('PLA Iterations'); 
    hold off;
    legend show;
    
    q = 1;
    figure(2);
    hold on;
    for p = 1:nScenarios
        if mod(p,2)==0
            ThisLineStyle = [lineStyles{q},lineColor{q}];%,MarkerStyle{q}];
            txt = ['Scenario = ',num2str(p)];
%             plot(1:St_Algo.gSize+1,ThisScenarioTrend(p,:),'DisplayName',txt,'LineWidth',LineWidth);
            plot(1:St_Algo.gSize,AvgBestValPerIteration(p,:),ThisLineStyle,...
                'DisplayName',txt,'LineWidth',LineWidth);
            ylabel('Average fitness');
            xlim([0 St_Algo.gSize+1]);            
            grid on;
            q = q + 1;
        end        
    end
    xlabel('PLA Iterations'); 
    hold off;
    legend show;    
end

