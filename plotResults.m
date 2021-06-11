function plotResults(St_Data,St_Results,algo)

figure;
totalDroneLocs = St_Data.totalDroneLocs;
n = St_Data.n;
maxGrid = St_Data.maxGrid;
linx = St_Data.linx;
liny = St_Data.liny;
DisplayUserNum = St_Data.DisplayUserNum;

if algo == 1
    xm = St_Results.St_ResultsGA.xm;
    ynm = St_Results.St_ResultsGA.ynm;
    objVal = St_Results.St_ResultsGA.bestValPerIter(end);
else
    xm = St_Results.St_ResultsEDA.xm;
    ynm = St_Results.St_ResultsEDA.ynm;
    objVal = St_Results.St_ResultsEDA.bestValPerIter(end);
end

potentialLocs = St_Data.potentialLocs;

%% connections
[row,col] = find(ynm>0);
userConnections = [row';col'];
lenUserConnections = length(userConnections);

%% plot drone locations: black squares
plot(potentialLocs(:,1),potentialLocs(:,2),'s','MarkerSize',15,'MarkerFaceColor','k');
hold on;
xrand = St_Data.userLocs(:,1);
yrand = St_Data.userLocs(:,2);
% plot(xrand,yrand,'.m','MarkerSize',15);
for i = 1:length(xrand)
    plot(xrand(i),yrand(i),'.b','MarkerSize',10);
    if DisplayUserNum
        text(xrand(i),yrand(i)+3,num2str(i));
    end
end
set(gca,'xtick',linx);
set(gca,'ytick',liny);
axis([0 maxGrid 0 maxGrid]);
grid on;

%% plot drones and connections
for i = 1:lenUserConnections
    userIndx = userConnections(1,i);
    droneIndx = userConnections(2,i);
    
    % plot connection lines
    plot([xrand(userIndx) potentialLocs(droneIndx,1)],[yrand(userIndx) potentialLocs(droneIndx,2)],'-k','lineWidth',1);
    % plot red dots for connected users
    plot(xrand(userIndx),yrand(userIndx),'.r','MarkerSize',20);
    % plot green circles for placed drones
    plot(potentialLocs(droneIndx,1),potentialLocs(droneIndx,2),'o','MarkerSize',15,'MarkerFaceColor','g',...
        'MarkerEdgeColor','k');
end

if St_Data.IsCoverageRequired
    plotCircles(St_Data);
end

%%
totSelectedUsers = sum(sum(ynm));
totSelectedDrones = sum(xm);

if algo == 1
    title(['GA, users: ',num2str(totSelectedUsers),'/',num2str(n),...
        ' drones: ',num2str(totSelectedDrones),'/',num2str(totalDroneLocs),...
        ' Obj Value: ',num2str(objVal)]);
else
    title(['EDA, users: ',num2str(totSelectedUsers),'/',num2str(n),...
        ' drones: ',num2str(totSelectedDrones),'/',num2str(totalDroneLocs),...
        ' Obj Value: ',num2str(objVal)]);
end
grid on;
hold off;