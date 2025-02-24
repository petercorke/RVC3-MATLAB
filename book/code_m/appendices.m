%[text] %[text:anchor:F4CCA683] # Robotics, Vision & Control 3e: for MATLAB
%[text] %[text:anchor:874DADDE] # Appendices
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] %[text:anchor:H_FD45E4DF] Copyright 2022\-2023 Peter Corke, Witold Jachimczyk, Remo Pillat
%[text] %[text:anchor:F954A5D5] ## Appendix C: Geometry
%[text] %[text:anchor:BAEBF2AC] ### C.1 Euclidean Geometry
%[text] %[text:anchor:E4239FA6] #### C.1\.2 Lines
%[text] %[text:anchor:E7791A79] #### C.1\.2\.2 Lines in 3D and Plücker Coordinates
P = [2 3 4]; Q = [3 5 7];
L = Plucker(P,Q)
L.v
L.w
L.skew
axis([-5 5 -5 5 -5 5]);
L.plot("b");
L.point([0 1 2])
[x,d] = L.closest([1 2 3]) %#ok<*ASGLU> 
L.intersect_plane([0 0 1 0])
%%
%[text] %[text:anchor:B107E972] #### C.1\.4 Ellipses and Ellipsoids
E = [1 1;1 2];
clf; plotellipse(E); hold on
[x,e] = eig(E)
r = 1./sqrt(diag(e))
p = x(:,1)*r(1); quiver(0,0,p(1),p(2),0,"r");
p = x(:,2)*r(2); quiver(0,0,p(1),p(2),0,"r");
atan2d(x(2,1),x(1,1))
%%
%[text] %[text:anchor:81891655] #### C.1\.4\.1 Drawing an Ellipse
E = [1 1; 1 2];
th = linspace(0,2*pi,50);
y = [cos(th);sin(th)];
x = inv(sqrtm(E))*y;
clf; plot(x(1,:),x(2,:));
clf; plotellipse(E)
%%
%[text] %[text:anchor:A199F180] #### C.1\.4\.2 Fitting an Ellipse to Data
rng(0);  % reset random number generator
x = [];  % empty point set
while size(x,2) < 500
    p = (rand(2,1)-0.5)*4;
    if norm(p'*E*p) <= 1
        x = [x p];
    end
end
plot(x(1,:),x(2,:),".")
% compute the moments
m00 = mpq_point(x,0,0);
m10 = mpq_point(x,1,0);
m01 = mpq_point(x,0,1);
xc = m10/m00; yc = m01/m00;
% compute second moments relative to centroid
x0 = x - [xc; yc];
m20 = mpq_point(x0,2,0);
m02 = mpq_point(x0,0,2);
m11 = mpq_point(x0,1,1);
% compute the moments and ellipse matrix
J = [m20 m11;m11 m02];
E_est = m00*inv(J)/4;
E_est
plotellipse(E_est,"r")
%%
%[text] %[text:anchor:22C91717] ### C.2 Homogeneous Coordinates
%[text] %[text:anchor:A2EF233A] #### C.2\.1 Two Dimensions
%[text] %[text:anchor:25F2AFB3] #### C.2\.1\.1 Points and Lines
l1 = [1 -1 0];
l2 = [1 -1 -1];
plothomline(l1,"b")
plothomline(l2,"r")
cross(l1, l2)
%[text] %[text:anchor:82267EC7] ## 
%[text] %[text:anchor:29028678] ## Appendix E: Linearization, Jacobians, and Hessians
%[text] %[text:anchor:05136303] ### E.4 Deriving Jacobians
zrange = @(xi,xv,w) ...
      [sqrt((xi(1)-xv(1))^2 + (xi(2)-xv(2))^2) + w(1);
       atan((xi(2)-xv(2))/(xi(1)-xv(1)))-xv(3) + w(2)];
xv = [1 2 pi/3]; xi = [10 8]; w= [0,0];
h0 = zrange(xi,xv,w)
d = 0.001;
J = [zrange(xi,xv+[1 0 0]*d,w)-h0 ...
     zrange(xi,xv+[0 1 0]*d,w)-h0 ...
     zrange(xi,xv+[0 0 1]*d,w)-h0]/d
syms xi yi xv yv thetav wr wb
z = zrange([xi yi],[xv yv thetav],[wr wb])
J = jacobian(z,[xv yv thetav])
whos J
Jf = matlabFunction(J);
xv = [1 2 pi/3]; xi = [10 8]; w = [0 0];
Jf(xi(1),xv(1),xi(2),xv(2))
%%
%[text] %[text:anchor:99DE1C25] ## 
%%
%[text] %[text:anchor:980876A6] ## Appendix G: Gaussian Random Variables
x = linspace(-6,6,500);
plot(x,gaussfunc(0,1,x),"r")
hold on
plot(x,gaussfunc(0,2^2,x),"b--")
sigma = 1; mu = 0;
g = sigma*randn(100,1) + mu;
[x,y] = meshgrid(-5:0.1:5,-5:0.1:5);
P = diag([1 2]).^2;
surfc(x,y,gaussfunc([0 0],P,x,y))
s = chi2inv(0.5,2)
%%
%[text] %[text:anchor:DD77BE42] ## Appendix H: Kalman Filter
%[text] %[text:anchor:72ADDA8C] ### H.2 Nonlinear Systems \-\- Extended Kalman Filter
x = 2*randn(1000000,1) + 5;
y = (x+2).^2/4;
clf; histogram(y, Normalization="pdf");
%%
%[text] %[text:anchor:1A4CC05A] ## Appendix I: Graphs
g = UGraph()
rng(10)
for i = 1:5
   g.add_node(rand(2,1));
end
g.add_edge(1,2);
g.add_edge(1,3);
g.add_edge(1,4);
g.add_edge(2,3);
g.add_edge(2,4);
g.add_edge(4,5);
g
clf; g.plot(labels=true);
g.neighbors(2)
e = g.edges(2)
g.cost(e)
g.nodes(5)'  % transpose for display
[n,c] = g.neighbors(2)
g.about(1)
g.closest([0.5 0.5])
g.path_Astar(3, 5)
%%
%[text] %[text:anchor:8633A41B] ## Appendix J: Peak finding
%[text] %[text:anchor:794CD871] ### J.1 1D Signal
load peakfit1
clf; plot(y,"-o")
[ypk,k] = max(y)
[ypk,k] = findpeaks(y,SortStr="descend");
ypk'  % transpose for display
k'  % transpose for display
ypk(2)/ypk(1)
range=k(1)-1:k(1)+1
p = polyfit(range,y(range),2)  % fit second-order polynomial
pd = polyder(p)  % derivative of fitted polynomial
roots(pd)  % zero value of the derivative
ypk = findpeaks(y,MinPeakDistance=5)'  % transpose for display
%%
%[text] %[text:anchor:A82CA7F7] ### J.2 2D Signal
z
[zmax,i] = max(z(:))
[y,x] = ind2sub(size(z),i)
LMaxFinder = vision.LocalMaximaFinder(MaximumNumLocalMaxima=3, ...
                NeighborhoodSize=[3 3],Threshold=0);
LMaxFinder(z)
%[text] 
%[text] Suppress syntax warnings in this file
%#ok<*NASGU>
%#ok<*AGROW>
%#ok<*MINV> 

%[appendix]
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
