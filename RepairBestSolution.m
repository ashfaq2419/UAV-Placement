function [xm,ynm,St_Data,ConstraintViolations] = RepairBestSolution(xm,ynm,St_Data)

DroneLocs = St_Data.totalDroneLocs;
m = DroneLocs;
n = St_Data.n;

gammaMax = St_Data.gammaMax;
gammaMin = St_Data.gammaMin;

realYnm = St_Data.realYnm;

UPPERTHRESHOLD = 0.99;
LOWERTHRESHOLD = 0.1;

%% Constraint 3: code to remove duplicate user connections
[~,constNum] = OnlyCheckConstraints(St_Data,ynm,xm); % Check if there are violations
if constNum(3) > 0
    AllUsersConnections = sum(ynm,2);
    UsersWithMoreConnections = find(AllUsersConnections > 1); 
    for k = 1:length(UsersWithMoreConnections)
        thisUser = UsersWithMoreConnections(k);
        currUserTotalConnections = ynm(thisUser,:);
        bbb = find(currUserTotalConnections > UPPERTHRESHOLD);
        CoverageThisUser = realYnm(thisUser,bbb) == 0;
        ynm(thisUser,bbb(CoverageThisUser)) = 0;
        if sum(ynm(thisUser,:)) > 1      
            currUserTotalConnections = ynm(thisUser,:);
            bbb = find(currUserTotalConnections > UPPERTHRESHOLD);
            [~,indx] = max(sum(ynm(:,bbb)));
            ccc = zeros(1,m);
            ccc(1,bbb(indx)) = 1;
            ynm(thisUser,:) = ccc; 
        end
    end
    xm = xm.*(sum(ynm)>0);
    ynm(:,~xm) = 0;
end

%% Constraint 5: Constraint Find under-utilized drones, UU:Under-Utilized
[~,constNum] = OnlyCheckConstraints(St_Data,ynm,xm); % Check if there are violations
if constNum(5) > 0
    DronesUtilitzation1 = sum(ynm);
    DronesUtilitzation2 = xm.*(DronesUtilitzation1 < gammaMin);
    UnderUtilizedDrones = find(DronesUtilitzation2 > 0);
    for i = 1:length(UnderUtilizedDrones) % LOOP: CHECK FOR ALL UU DRONES
        uuDrone1 = UnderUtilizedDrones(i); % Find ith UU drone
        nnDrone1 = find(ynm(:,uuDrone1) >= UPPERTHRESHOLD); % Find all connection to ith UU drone
        for j = 1:length(nnDrone1) % LOOP: CHECK FOR ALL USERS CONNECTED TO iTH UU DRONE
            user1 = nnDrone1(j); % Select jth user connected to ith UU drone
            user1PossibleConn = find(realYnm(user1,:) >= UPPERTHRESHOLD); % Find all possible connections for user1
            user1PossibleConn(user1PossibleConn == uuDrone1) = []; % Remove UU drone from the list
            [~,indx] = sort(sum(ynm(:,user1PossibleConn)),'descend');
            for k = 1:length(user1PossibleConn) % LOOP: CHECK FOR ALL POSSIBLE CONNECTIONS
                curr = user1PossibleConn(indx(k)); % Collect current possible connection option
                % Re-connect this user to some other drone on following
                % basis: (1) the user is in range of it, (2) the drone has
                % capacity to serve more users, (3) the drone is not under
                % utilized, (4) the drone is already deployed
                Flag1 = sum(ynm(:,curr))<gammaMax; % Check if the current drone has capacity
                Flag2 = sum(ynm(:,curr))>gammaMin-1; % Check if the current drone has capacity
                Flag3 = xm(curr) >= UPPERTHRESHOLD; % Check if the drone is already deployed
                if Flag1 && Flag2 && Flag3
                    ccc = zeros(1,m);
                    ccc(1,curr) = 1;
                    ynm(j,:) = ccc;
                    xm(curr) = 1;
                end
            end
        end
    end
end

%% Constraint 4: Find over-utilized drones, OU:Over-Utilized
[~,constNum] = OnlyCheckConstraints(St_Data,ynm,xm); % Check if there are violations
if constNum(4) > 0
    DronesUtilization = sum(ynm);
    OverUtilizedDrones = find(DronesUtilization > gammaMax);
    for i = 1:length(OverUtilizedDrones) % LOOP: CHECK FOR ALL OU DRONES
        ouDrone1 = OverUtilizedDrones(i); % Find ith OU drone
        totalConnections = sum(ynm(:,ouDrone1)); % Find total no. connected users
        nnDrone1 = find(ynm(:,ouDrone1) >= UPPERTHRESHOLD); % Find all connection to ith OU drone
        %uuOptions = sum(ynm(nnDrone1,:),2); % Find number of possible options for users
        OverConnections = totalConnections - gammaMax; % Find over connections
        xTemp = 0; % No. of shifted users from OU drone
        for j = 1:totalConnections % LOOP: FOR ALL OVER UTILIZED CONNECTIONS
            if xTemp < OverConnections
                curr = nnDrone1(j); % jth connected user to ith OU drone
                user1PossibleConn = find(realYnm(curr,:) >= UPPERTHRESHOLD); % Find all possible connections for jth user
                user1PossibleConn(user1PossibleConn == ouDrone1) = []; % Remove OU drone from the list
                shiftFlag = 0;
                for k = 1:length(user1PossibleConn) % LOOP: CHECK FOR ALL POSSIBLE CONNECTIONS
                    if shiftFlag == 0
                        curr = user1PossibleConn(k); % Collect current possible connection option
                        Flag1 = sum(ynm(:,curr))>=gammaMin-1; % Check if the current drone is not UU
                        Flag2 = sum(ynm(:,curr))<gammaMax; % Check if the current drone is not OU
                        Flag3 = xm(curr) >= UPPERTHRESHOLD; % Check if the drone is already deployed
                        if Flag1 && Flag2 && Flag3
                            ccc = zeros(1,m);
                            ccc(1,curr) = 1;
                            ynm(j,:) = ccc;
                            xm(curr) = 1;
                            xTemp = xTemp + 1;
                            shiftFlag = 1;
                        end
                    end
                end   
            end
        end
        %----------------------------------------------------------------
        totalConnections = sum(ynm(:,ouDrone1)); % Find total no. connected users to OU ith drone
        OverConnections = totalConnections - gammaMax; % Find over connections        
        if OverConnections > 0 % If still the ith drone is OU, simply remove extra users randomly
            nnDrone1 = find(ynm(:,ouDrone1) >= UPPERTHRESHOLD); % Find all connection to ith OU drone
            [~,Indx] = sort(sum(realYnm(nnDrone1,:)),'descend'); % sort users w.r.t. to their connection options
            SelectednnDrone1 = nnDrone1(Indx); % rearrange users order according to no. of connection options
            ynm(SelectednnDrone1(1:OverConnections),ouDrone1) = 0; % remove those extra users who would have multiple options
            xm = xm.*(sum(ynm)>0);
            ynm(:,xm <= LOWERTHRESHOLD) = 0;
        end
    end
end

%% Constraint 7: Repair coverage constraint
[~,constNum] = OnlyCheckConstraints(St_Data,ynm,xm); % Check if there are violations
if constNum(7) > 0
    for i = 1:n
        for j = 1:DroneLocs
            if ynm(i,j) > realYnm(i,j)
                currUserConOptions = find(realYnm(i,:) > 0);
                [~,indx] = sort(sum(ynm(:,currUserConOptions)),'ascend');
                for k = 1:length(currUserConOptions)
                    CurrDrone = currUserConOptions(indx(k));
                    ccc = zeros(1,m);
                    ccc(1,CurrDrone) = 1;
                    ynm(i,:) = ccc;
                    xm(CurrDrone) = 1;
                end
            end
        end
    end
end

%% Constraint 1: Connect all possible users
[~,constNum] = OnlyCheckConstraints(St_Data,ynm,xm); % Check if there are violations
if constNum(1) > 0
    unConnectedUsers = sum(ynm,2) < LOWERTHRESHOLD;
    IndexunConnectedUsers = find(unConnectedUsers >= UPPERTHRESHOLD);
    for i = 1:length(IndexunConnectedUsers)
        curr = IndexunConnectedUsers(i);
        user1PossibleConn = realYnm(curr,:) >= UPPERTHRESHOLD; % Find all possible connections for curr user
        UsersConnectedToThisDrone = sum(ynm(:,user1PossibleConn));
        [~,Sorteduser1PossibleConn] = sort(UsersConnectedToThisDrone,'descend');
        connectFlag = 0;
        for k = 1:length(Sorteduser1PossibleConn) % LOOP: CHECK FOR ALL POSSIBLE CONNECTIONS
            if connectFlag == 0
                currDrone = Sorteduser1PossibleConn(k); % Collect current possible connection option
                Flag1 = sum(ynm(:,currDrone))>=gammaMin-1; % Check if the current drone is not OU
                 Flag2 = sum(ynm(:,currDrone))<gammaMax; % Check if the current drone is not OU
%                 Flag3 = xm(currDrone) >= UPPERTHRESHOLD; % Check if the drone is already deployed
                 if Flag1 && Flag2
                    ccc = zeros(1,m);
                    ccc(1,currDrone) = 1;
                    ynm(curr,:) = ccc;
                    xm(currDrone) = 1;
                    connectFlag = 1;
                 end
            end
        end        
    end
end

%% if still there are under-utilized drones, simply remove them and
% disconnect all users
DronesUtilization = sum(ynm);
UnderUtilizedDrones = DronesUtilization < gammaMin;
ynm(:,UnderUtilizedDrones) = 0; % If there are still UU drones, simply remove them
xm(UnderUtilizedDrones) = 0;

%% Remove all the drones with beta*n more users
BetaUsers = round(St_Data.beta*n);    
AdmittedUsers = sum(sum(ynm));
ExtraUsers =  AdmittedUsers - BetaUsers;

ConnectionsToEachDrone = sum(ynm);
[~,DroneIndx] = sort(ConnectionsToEachDrone,'ascend');
for i = 1:DroneLocs
    if ExtraUsers > 0
        ThisDrone = DroneIndx(i);
        if xm(ThisDrone) > 0
            if ExtraUsers >= ConnectionsToEachDrone(ThisDrone)
                ynm(:,ThisDrone) = 0;
                xm(ThisDrone) = 0;
                ExtraUsers = ExtraUsers - ConnectionsToEachDrone(ThisDrone);
            end
        end 
    end
end

%% Connect all possible users
unConnectedUsers = sum(ynm,2) < LOWERTHRESHOLD;
IndexunConnectedUsers = find(unConnectedUsers >= UPPERTHRESHOLD);
for i = 1:length(IndexunConnectedUsers)
        curr = IndexunConnectedUsers(i);
        user1PossibleConn = find(realYnm(curr,:) >= UPPERTHRESHOLD); % Find all possible connections for curr user
        connectFlag = 0;
        for k = 1:length(user1PossibleConn) % LOOP: CHECK FOR ALL POSSIBLE CONNECTIONS
            if connectFlag == 0
                currDrone = user1PossibleConn(k); % Collect current possible connection option
                Flag1 = sum(ynm(:,currDrone))>=gammaMin-1; % Check if the current drone is not OU
                Flag2 = sum(ynm(:,currDrone))<gammaMax; % Check if the current drone is not OU
                Flag3 = xm(currDrone) >= UPPERTHRESHOLD; % Check if the drone is already deployed
                 if Flag1 && Flag2 && Flag3
                    ccc = zeros(1,m);
                    ccc(1,currDrone) = 1;
                    ynm(curr,:) = ccc;
                    xm(currDrone) = 1;
                    connectFlag = 1;
                 end
            end
        end 
end

%% Remove all the drones with beta*n more users
BetaUsers = round(St_Data.beta*n);    
AdmittedUsers = sum(sum(ynm));
ExtraUsers =  AdmittedUsers - BetaUsers;

ConnectionsToEachDrone = sum(ynm);
[~,DroneIndx] = sort(ConnectionsToEachDrone,'ascend');
for i = 1:DroneLocs
    if ExtraUsers > 0
        ThisDrone = DroneIndx(i);
        if xm(ThisDrone) > 0
            if ExtraUsers >= ConnectionsToEachDrone(ThisDrone)
                ynm(:,ThisDrone) = 0;
                xm(ThisDrone) = 0;
                ExtraUsers = ExtraUsers - ConnectionsToEachDrone(ThisDrone);
            end
        end 
    end
end


[ConstraintViolations,~] = OnlyCheckConstraints(St_Data,ynm,xm); % Check if there are violations
    






