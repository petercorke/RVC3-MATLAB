%%
eg_morph1

% join the 2 squares
im(20:25,14)=1;
im=im';

S1 = ones(5);
e1 = imorph(im, S1, 'min');
d1 = imorph(e1, S1, 'max');

S2 = ones(7);
e2 = imorph(im, S2, 'min');
d2 = imorph(e2, S2, 'max');

S3 = ones(1,14);
e3 = imorph(im, S3, 'min');
d3 = imorph(e3, S3, 'max');

f1
vsep = ones(size(im,1), 1);
hsep = ones(1,3*size(im,2)+3);
%idisp([e1 vsep e2 vsep e3; hsep; d1 vsep d2 vsep d3]);

p1 = bg*ones(size(vsep,1)+1, 25);
p1 = ipaste(p1, icolor(S1, [1 0 0]), [5,15]);
p2 = bg*ones(size(vsep,1)+1, 25);
p2 = ipaste(p2, icolor(S2, [1 0 0]), [5,15]);
p3 = bg*ones(size(vsep,1), 25);
p3 = ipaste(p3, icolor(S3, [1 0 0]), [5,15]);
panel = cat(1, p1, p2, p3);

results = icolor([im vsep e1 vsep d1 vsep; hsep;  im vsep e2 vsep d2 vsep; hsep; im vsep e3 vsep d3 vsep]);

idisp( cat(2, results, panel), 'noaxes', 'nogui', 'square')

rvcprint