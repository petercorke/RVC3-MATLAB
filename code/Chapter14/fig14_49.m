clf

im1 = iread('mosaic/aerial2-1.png', 'double', 'grey');

composite = zeros(2000,2000);
composite = ipaste(composite, im1, [1 1]);

for i=2:6
    f1 = isurf(composite)
    im = iread( sprintf('mosaic/aerial2-%d.png', i), 'double', 'grey');
    
    fi = isurf(im)
    m = f1.match(fi);
    [H,in] = m.ransac(@homography, 0.2)
    
    [tile,t] = homwarp(inv(H), im, 'full', 'extrapval', 0);
    
    composite = ipaste(composite, tile, t, 'add');
    idisp(composite)
end

idisp(composite/max(composite(:)), 'nogui')
brighten(0.4)

rvcprint('svg')