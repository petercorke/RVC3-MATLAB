flowers = iread('flowers4.png', 'double');
idisp(flowers, 'plain')
rvcprint('subfig', 'a', 'format', 'png');

hsv = colorspace('RGB->HSV', flowers);
idisp(hsv(:,:,1), 'plain')
rvcprint('subfig', 'b', 'format', 'png');

idisp(hsv(:,:,2), 'plain')
rvcprint('subfig', 'c', 'format', 'png');

lab = colorspace('RGB->Lab', flowers);

idisp(lab(:,:,1), 'plain')
rvcprint('subfig', 'd', 'format', 'png');

idisp(lab(:,:,2), 'plain')
rvcprint('subfig', 'e', 'format', 'png');

idisp(lab(:,:,3), 'plain')
rvcprint('subfig', 'f', 'format', 'png');