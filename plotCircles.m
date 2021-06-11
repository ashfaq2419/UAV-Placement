function plotCircles(St_Data)

potentialLocs = St_Data.potentialLocs;
radius = St_Data.MaxDist;
angle = 0:.01:2*pi;

for i = 1:length(potentialLocs)
    center = [potentialLocs(i,1),potentialLocs(i,2)]; % center coordinates of the circle [x0,y0]     
    r = radius;
    X = r.*cos(angle)+ center(1);
    Y = r.*sin(angle)+ center(2);
    plot(X,Y,'--b','LineWidth',0.5);
end