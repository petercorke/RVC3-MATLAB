im = zeros(200, 200);
im(50:100,50:150) = 1;

idisp(im);

fv = iblobs(im, 'boundary', 'class', 1);

e = fv(1).edge;
e = [e e(:,1)];


d = diff(e');
th = atan2(d(:,2), d(:,1))


th1 = interp1(1:length(th), th, linspace(1, length(th), 400) );

clf
plot(th1)

%%

im = im(1:4:end, 1:4:end);


fv = iblobs(im, 'boundary', 'class', 1);

e = fv(1).edge;
e = [e e(:,1)];


d = diff(e');
th = atan2(d(:,2), d(:,1))


th2 = interp1(1:length(th), th, linspace(1, length(th), 400) );

hold on
%plot(th2)

%%

im = zeros(200, 200);
im(50:100,50:150) = 1;

im = irotate(im, pi/4);


fv = iblobs(im, 'boundary', 'class', 1);

e = fv(1).edge;
e = [e e(:,1)];


d = diff(e');
th = atan2(d(:,2), d(:,1))


th3 = interp1(1:length(th), th, linspace(1, length(th), 400) );

plot(th3)

fminsearch( @(x) norm2( angdiff( circshift(th1,round(x(1))) - th2 - x(2))) )
