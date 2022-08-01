im = zeros(200, 200);
im(50:100,50:150) = 1;

idisp(im);

fv = iblobs(im, 'boundary', 'class', 1);
e = bsxfun(@minus, fv(1).edge, [fv(1).uc; fv(1).vc]);
r = atan2(e(2,:), e(1,:));
r1 = interp1(1:length(r), r, linspace(1, length(r), 400) );

clf
plot(r1)

%%

im = im(1:2:end, 1:2:end);

fv = iblobs(im, 'boundary', 'class', 1);
e = bsxfun(@minus, fv(1).edge, [fv(1).uc; fv(1).vc]);
r = atan2(e(2,:), e(1,:));
r2 = interp1(1:length(r), r, linspace(1, length(r), 400) );

aa= cumsum(r1)/cumsum(r2)

hold on
plot(r2)

% this ratio deviates from expected when the shrinkage is high


%%

im = zeros(200, 200);
im(50:100,50:150) = 1;

im = irotate(im, 20*pi/180);


fv = iblobs(im, 'boundary', 'class', 1);
e = bsxfun(@minus, fv(1).edge, [fv(1).uc; fv(1).vc]);
r = atan2(e(2,:), e(1,:));
r3 = interp1(1:length(r), r, linspace(1, length(r), 400) );

plot(r3)
pause(2)

a=r1; b = r3;
% z = xcorr([a a a], [b b b]);
% plot(z)
% [~,k] = max(z)
% k
% (1200-k)/400*360

z =[];
for i=1:400
	z(i) = norm( angdiff(a, circshift(b, [1,i])));
end

clf
plot(z)
[~,k] = min(z)
k

pause(2)
clf
plot(a)
hold on
plot(circshift(b, [1,k]))
([k 400-k])/400*360