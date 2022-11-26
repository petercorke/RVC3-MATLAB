
% f = iread('flowers8.png', 'single');
% seg= vl_quickseg(cast(f, 'double'), 0.5, 2, 50);
% idisp(seg)
% [seg,L] = vl_quickseg(cast(f, 'double'), 0.5, 2, 50);
% idisp(seg)
% [seg,L] = vl_quickseg(cast(f, 'double'), 0.5, 2, 50);

%castle = iread('castle.png', 'double');
castle = iread('castle2.png', 'double');
%castle = iread('castle_sign2.png', 'double');


% [s,n,R] = imser(cast(castle, 'double'), 'dark', 'Verbose', ...
%     'BrightOnDark', 1, 'DarkOnBright', 0, ...
%     'MinArea', 500/np, 'MaxArea', 30000/np, ...
%     'Delta', 1, ...
%     'MinDiversity', 0.1, ...
%     'MaxVariation', 0.25);

s = imser(castle, 'verbose', 'area', [100 20000]); %, 'light');

idisp(s);



% im = castle;
% all = zeros( size(im) );
% count = 1;
% for r=abs(R)'
%     bim = im <= im(r);
% 
%     lim = ilabel(bim);
%     mser_blob = lim == lim(r);
%     if count == 11
%         idisp(mser_blob);
%     end    
%     
%     all(mser_blob) =  count;
%     count = count + 1;
%     
% end

%idisp(all)
