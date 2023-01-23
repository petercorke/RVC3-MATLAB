
xg = [5 5]; % goal position
clf
axis equal
axis([1 9 1 9]);
xlabel("x");
ylabel("y");
grid on
xc = 5; yc = 5;
N = 8;
radius = 3;
hold on

for i=1:N
    th = (i-1)*2*pi/N;
    x0 = [xc+radius*cos(th) yc+radius*sin(th) th+pi/2];
    
    r = sim("sl_drivepoint");
    y = r.find("y");
    if i == N
        % Make color unique for last plot
        lineHandle = plot(y(:,1), y(:,2), Color="#FF13A6");
    else
        lineHandle = plot(y(:,1), y(:,2));
    end

    plotvehicle(x0, edgecolor=lineHandle.Color);
end
plot(xg(1), xg(2), "*", MarkerSize=20, Color="black")

axis equal
axis([1 9 1 9]);

