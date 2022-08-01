[U,V] = imeshgrid(castle);

u0 = 500; v0 = 400;
sigma = 100;

off = 1/(2*pi*sigma^2) * exp( -((U-u0).^2 + (V-v0).^2)/2/sigma^2);
off = off/max(off(:));
off = off + 0.02*randn(size(castle));

z = castle + 0.66*off;
z = z / max(z(:));

z = igamm(z, 0.5);
figure(1)
idisp(z);
figure(2)
ihist(z)