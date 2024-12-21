%RVCPRINT Print figure for RVC book
%
% rvcprint(name, options)  from console write to file
% rvcprint(name, options)  from script write relative to calling script
% path and use its name
% rvcprint('fig', name, options) as above but use this name
%
% If fig name not given take it from name of calling script
function rvcprint3(varargin)
    
    global rvcprintopts
    
    outputFolder = './figures/';
    
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    
    opt.subfig = '';
    opt.simulink = [];
    opt.fig = [];
    opt.thicken = [];
    opt.format = {'eps', 'svg', 'pdf'};
    opt.tall = false;
    opt.normal = false;
    opt.grid = true;
    opt.force = false;
    opt.hidden = [];
    opt.cmyk = false; % WJ was true
    opt.here = false;
    opt.opengl = false;
    opt.bgfix = true;
    opt.axes = true;
    
    [opt,args] = tb_optparse(opt, [varargin rvcprintopts]);

    if ~isempty(opt.hidden)
        set(opt.hidden.Number, 'HandleVisibility', 'on');
        opts = { sprintf('-f%d', opt.hidden.Number) };
    else
        opts = {};
    end
   
    if strcmp(opt.format, 'svg')
        opt.cmyk = false;  % MATLAB gives huge error dump with this set of options
    end
    
    if opt.bgfix
        try
            % WJWJ: This fails for figures produced by CentralCamera!!!!
            % it ends up making a new figure; needed to unhide handles
            set(gca, 'color', 'none')   % remove background patch
        catch
           % don't care if it failed (Witek) 
        end
    end
    if opt.opengl
        opts = [opts '-opengl' '-r600'];
    end
    
    if opt.cmyk
        opts = [opts '-cmyk'];
    end
    
    if opt.simulink
        % simulink can't write EPS files
        opts = [opts sprintf('-s%s', opt.simulink)];
        opt.format = 'pdf';
    end
    
    switch opt.format
        case 'pdf'
            opts = [opts '-dpdf' ];
            ext = '.pdf';
        case 'eps'
            opts = [opts '-depsc' ];
            ext = '.eps';
        case 'svg'
            opts = [opts '-dsvg' ];
            ext = '.svg';
        otherwise
            opts = [opts ['-d' opt.format] ];
            ext = ['.' opt.format];
    end


        if opt.tall
            p = get(gcf, 'Position');
            p(4)=p(4)*1.5;
            set(gcf, 'Position', p)
        end

    if opt.thicken
        lines = findobj(gcf, 'Type', 'line');
        for line = lines'
            if ~strcmp(get(line, 'LineStyle'), 'none')
            set(line, 'LineWidth', opt.thicken);
            end
        end
    end
    
    if ~opt.axes
        axis off
    end
    
    if isempty(opt.hidden)
        % when making a hidden handle figure visible, any grid operation seems to
        % overlay it with a blank set of axes, clf makes it go away, very odd

% Witek: just don't do grids        
%         if opt.grid
%             grid on
%         else
%             grid off
%         end
    end
    % find who called us
    %  - first element is self, second element is caller, etc
    st = dbstack('-completenames');
    
%    if length(st) == 1
        % called from the console
        %  use the name given
        if length(args) < 1 
            % this is useful when testing figure scripts from the command line
            fprintf('rvcprint: ignoring request\n');
                pause(2)
            return
        end
        filename = [outputFolder, args{1}];
        args = {};
%     else
%         % called from a script, write relative to script path and use its name
%         % build a path from script name
%         [pth, name] = fileparts(st(2).file);
%         if ~isempty(opt.fig)
%             % no file name given, try to be tricky and get it from the name of the
%             % calling script
%             name = opt.fig;
%         end
%         
%         if opt.here
%             filename = fullfile(pth, [name opt.subfig ext]);
%         else
%             filename = fullfile(pth, outputFolder, [name opt.subfig ext]);
%         end
%     end
    
        opts = [opts args];
        
    % make it so
    fig = gcf;
    fig.PaperPositionMode = 'auto';

    %fprintf('writing file [%s] --> %s\n', strjoin(opts), GetFullPath(filename));
    fprintf('writing file [%s] --> %s\n', strjoin(opts), filename);

    print(opts{:}, args{:}, filename);

    
    pause(2)
