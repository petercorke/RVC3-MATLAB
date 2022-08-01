u0 = 528.1214; v0 = 384.0784;
l=2.7899;
m=996.4617;

th = linspace(0, pi, 200);

r = (l+m)*sin(th)./(l-cos(th));

clf
plot(th, r); xlabel('\theta'); ylabel('r')

hold on
th2 =  acos( ((l+m)*sqrt(r.^2*(1-l^2) + (l+m)^2) - l*r.^2) ./ (r.^2 + (l+m)^2) );

plot(th2, r, 'k--')


t1 = ( (l+m) + sqrt((l+m)^2 -r.^2*(l^2-1)) ) ./ (r*(l+1)); 
t1 = ( (l+m) - sqrt((l+m)^2 -r.^2*(l^2-1)) ) ./ (r*(l+1)); 


plot(2*atan(t1), r, 'b.')
plot(2*atan(t2), r, 'g:')

