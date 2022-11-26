function colorlights
R = 400;
d = 100;
O = 200;

W = 2*d+4*R-2*O
im = zeros(W+d,W,3);

p1 = [R+d, R+d]
p2 = [3*R+d-2*O, R+d]
p3 = [2*R+d-O, R*(1+tand(60))+d-1.5*O]
    
im = beam(im, p1, R, [1 0 0]);
im = beam(im, p2, R, [0 1 0]);
im = beam(im, p3, R, [0 0 1]);
idisp(im, 'plain')

    end
    
    function im2 = beam(im, c, R, color)
    sz = size(im);
    n = prod(sz(1:2));
    [X,Y] = imeshgrid(im);
    k = find( (X-c(1)).^2 + (Y-c(2)).^2 <= R.^2 );
    im(k) = im(k) + color(1);
    im(k+n) = im(k+n) + color(2);
    im(k+2*n) = im(k+2*n) + color(3);
    im2 = im;
    end