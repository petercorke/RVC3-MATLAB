[d,sim,DSI] = istereo(L, R, [40 90], 3);
about(DSI)

% good
simpeaks2(DSI, 138, 439)
rvcprint('subfig', 'a', 'thicken', 1.5);

% multiple
simpeaks2(DSI, 133, 313)
rvcprint('subfig', 'b', 'thicken', 1.5);

% weak
%simpeaks2(DSI,  410, 276)
simpeaks2(DSI,  408, 277)

rvcprint('subfig', 'c', 'thicken', 1.5);

% broad
simpeaks2(DSI, 464, 544)
rvcprint('subfig', 'd', 'thicken', 1.5);