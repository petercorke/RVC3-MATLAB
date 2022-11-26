%%
% lena = iread('lena.pgm');
% idisp(lena, 'nogui')
% rvcprint('svg', 'subfig', 'a')
% 
% eyes = iroi(lena, [239   359; 237 294]);
% idisp(eyes, 'nogui')
% rvcprint('svg', 'subfig', 'b')

%%
mona = iread('monalisa.png');

%smile = iroi(mona, [265 342; 264 286]);

idisp(mona, 'nogui')
rvcprint('svg', 'subfig', 'a')
eyes = iroi(mona, [239   376;170   210]);


smile = iroi(mona, [265 342; 264 286]);
idisp(smile, 'nogui')
rvcprint('svg', 'subfig', 'b')