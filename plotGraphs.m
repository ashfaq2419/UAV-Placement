function plotGraphs(St_Data,St_Results,AlgoNum)

figure;
DroneLocs = St_Data.totalDroneLocs;
n = St_Data.n;
maxGrid = St_Data.maxGrid;
linx = St_Data.linx;
liny = St_Data.liny;
DisplayUserNum = St_Data.DisplayUserNum;

%--------------------------------------------------------
St_Data.xS = 1; 
St_Data.xE = 1*DroneLocs; 
St_Data.LE = St_Data.xE; 
%--------------------------------------------------------
St_Data.yS = St_Data.LE + 1;       
St_Data.yE = St_Data.yS + (n*DroneLocs)-1; 
St_Data.LE = St_Data.yE;
%--------------------------------------------------------
if AlgoNum == 1 % BB
    xm = St_Results.St_ResultsBB.xm;
    ynm = St_Results.St_ResultsBB.ynm;
    fval = St_Results.St_ResultsBB.fval;    
else % EDA
    xm = St_Results.St_ResultsEDA.xm;
    ynm = St_Results.St_ResultsEDA.ynm;
    fval = St_Results.St_ResultsEDA.fval;
end

potentialLocs = St_Data.potentialLocs;

%% connections
[row,col] = find(ynm>0);
userConnections = [row';col'];
lenUserConnections = size(userConnections,2);

%% plots
plot(potentialLocs(:,1),potentialLocs(:,2),'s','MarkerSize',15,'MarkerFaceColor','k');
hold on;
xrand = St_Data.userLocs(:,1);
yrand = St_Data.userLocs(:,2);
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

for i = 1:lenUserConnections
    userIndx = userConnections(1,i);
    droneIndx = userConnections(2,i);
    
    plot([xrand(userIndx) potentialLocs(droneIndx,1)],[yrand(userIndx) potentialLocs(droneIndx,2)],'-k','lineWidth',1);
    plot(xrand(userIndx),yrand(userIndx),'.r','MarkerSize',20);
    plot(potentialLocs(droneIndx,1),potentialLocs(droneIndx,2),'o','MarkerSize',15,'MarkerFaceColor','g',...
        'MarkerEdgeColor','k');
end
    
if AlgoNum == 1
    title(['BB',', Users:', num2str(sum(sum(ynm))),'/',num2str(n),', Drones: ',num2str(sum(xm)),...
        '/',num2str(DroneLocs),', Fitness: ',num2str(fval)]);
else
    title(['EDA',', Users:', num2str(sum(sum(ynm))),'/',num2str(n),', Drones: ',num2str(sum(xm)),...
        '/',num2str(DroneLocs),', Fitness: ',num2str(fval)]);
end
   
if St_Data.IsCoverageRequired
    plotCircles(St_Data);
end

grid on;
hold off;