function rvcprint2(pth)
    
    st = dbstack('-completenames')
    for s=st
        s.file
    end
    [pth, name, ext] = fileparts(pth);
    fullfile(pth, '../figs', [name '.' ext])
    %print('-depsc2', 