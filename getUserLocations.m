function [userLocs] = getUserLocations(St_Data,UserMax)

n = UserMax;
maxGrid = St_Data.maxGrid;

xrand = maxGrid * rand(n,1);
yrand = maxGrid * rand(n,1);

userLocs = [xrand yrand];