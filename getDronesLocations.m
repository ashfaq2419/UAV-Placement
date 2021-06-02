function [St_Data] = getDronesLocations(St_Data)

m = St_Data.m;
maxGrid = St_Data.maxGrid;

linx = linspace(0,maxGrid,m+2);
liny = linspace(0,maxGrid,m+2);

lenLinx = length(linx);
lenLiny = length(liny);

potentialLocs = zeros((lenLinx-2)*(lenLiny-2),2);
tempRow = 1;

for i = 2:lenLinx - 1
    for j = 2:lenLiny - 1
        potentialLocs(tempRow,:) = [linx(i),liny(j)];
        tempRow = tempRow+1;
    end
end

St_Data.linx = linx;
St_Data.liny = liny;
St_Data.potentialLocs = potentialLocs;