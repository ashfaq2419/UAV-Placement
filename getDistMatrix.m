function [DistMatrix,realYnm] = getDistMatrix(St_Data)

userLocs = St_Data.MaxUserLocs;
dronePositions = St_Data.potentialLocs;
MaxDist = St_Data.MaxDist;

totalDronesLocs = max(size(dronePositions));
totalUsers = max(size(userLocs));
DistMatrix = zeros(totalUsers,totalDronesLocs);

for i = 1:totalUsers
    for j = 1:totalDronesLocs
        DistMatrix(i,j) = sqrt((userLocs(i,1) - dronePositions(j,1))^2 + ...
            (userLocs(i,2) - dronePositions(j,2))^2);        
    end
end

realYnm = (DistMatrix <= MaxDist); 