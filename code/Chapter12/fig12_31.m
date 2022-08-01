
skeleton = ithin(clean);
im = clean;
idisp(skeleton + im*0.3,'nogui', 'invert');
rvcprint('subfig', 'a', 'svg')

ends = iendpoint(skeleton);
z = ends + im*0.3 + skeleton*0.2;
idisp(z, 'invert', 'nogui');
axis([203 326 261 358])
rvcprint('subfig', 'b', 'svg')


joins = itriplepoint(skeleton);
z = joins + im*0.3 + skeleton*0.2;
idisp(z, 'invert', 'nogui');
axis([203 326 261 358])
rvcprint('subfig', 'c', 'svg')

