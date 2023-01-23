xg = [5 5 pi/2];
clf
axis([0 10 0 10]);
hold on
xlabel("x");
ylabel("y");
grid on
xc = 5; yc = 5;
N = 8;
radius = 4;

for i=1:N
    th = (i-1)*2*pi/N;
    x0 = [xc+radius*cos(th) yc+radius*sin(th) 0];

    r = sim('sl_drivepose');
    y = r.find('y');

    if i == N
        % Make color unique for last plot
        lineHandle = plot(y(:,1), y(:,2), Color="#FF13A6");
    else
        lineHandle = plot(y(:,1), y(:,2));
    end    

    plotvehicle(x0, edgecolor=lineHandle.Color);
end
plotvehicle(xg, edgecolor="black");
axis equal