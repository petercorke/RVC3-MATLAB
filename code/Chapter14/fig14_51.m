randinit
vl_twister('STATE', 0.0)
bag = BagOfWords(sf, 2000)
w = bag.words(259)
bag.occurrence(w)
bag.contains(w)
im = bag.exemplars(w, images, 'columns', 15);
idisp(im, 'plain');

rvcprint('nogrid');
