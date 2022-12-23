%RVCPRINT Print figure for RVC book
%
% rvcprint(name, options)  from console write to file
% rvcprint(name, options)  from script write relative to calling script
% path and use its name
% rvcprint('fig', name, options) as above but use this name
%
% If fig name not given take it from name of calling script
function rvcprint(varargin)
    
    global rvcprintopts
    
    % outputFolder = '../matfigs';
    outputFolder = '.';
    
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end
    
    opt.subfig = '';
    opt.simulink = [];
    opt.fig = [];
    opt.thicken = [];
    opt.format = {'eps', 'svg', 'pdf', 'jpg'};
    opt.tall = false;
    opt.normal = false;
    opt.grid = true;
    opt.force = false;
    opt.hidden = [];
    opt.cmyk = false;       % By default, save figures in RGB.
    opt.here = false;
    opt.opengl = false;
    opt.painters = false;
    opt.bgfix = true;
    opt.axes = true;
    opt.figy = 0;
    
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
        set(gca, 'color', 'none')   % remove background patch
    end
    
    if opt.opengl
        opts = [opts '-opengl' '-r600'];        
    end

    % Enforce that the resulting graphics is a vector graphics.
    % As of 20a, recommended option is "-vector", not "-painters".    
    if opt.painters
        opts = [opts '-vector'];
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
        if opt.grid
            grid on
        else
            grid off
        end
    end
    % find who called us
    %  - first element is self, second element is caller, etc
    st = dbstack('-completenames');
    
    if length(st) == 1
        % called from the console
        %  use the name given
        if length(args) < 1 
            % this is useful when testing figure scripts from the command line
            fprintf('rvcprint: ignoring request\n');
                pause(2)
            return
        end
        filename = args{1};
        args = args{2:end};
    else
        % called from a script, write relative to script path and use its name
        % build a path from script name
        [pth, name] = fileparts(st(2).file);
        if ~isempty(opt.fig)
            % no file name given, try to be tricky and get it from the name of the
            % calling script
            name = opt.fig;
        end
        
        if opt.here
            filename = fullfile(pth, [name opt.subfig ext]);
        else
            filename = fullfile(pth, outputFolder, [name opt.subfig ext]);
        end
    end
    
        opts = [opts args];
        
    % make it so
    fig = gcf;
    if ~opt.simulink
        fig.PaperPositionMode = 'auto';
    end

    if opt.figy ~= 0
        % Change figure y size. To avoid axes scaling, set units to pixels.
        ax = gca;
        ax.Units = "pixels";
        fig.Position(2) = fig.Position(2) - opt.figy;
        fig.Position(4) = fig.Position(4) + opt.figy;
        ax.Position(2) = ax.Position(2) + round(opt.figy/2);
    end

    fprintf('writing file [%s] --> %s\n', strjoin(opts), filename);

    if strcmp(opt.format, 'jpg')        
        % For jpeg export use exportgraphics to get tighter margins
        % Export JPEG images at 600 dpi
        exportgraphics(gca, filename, Resolution=600);
    else
        print(opts{:}, args{:}, filename);
    end

    % Automatically crop PDF to remove any margins that MATLAB added
    % This only works if "pdfcrop" is on the path. If you installed
    % TeXLive, this should be the case.
    if strcmp(opt.format, 'pdf')
        [status,result] = system("pdfcrop """ + filename + """ """ + filename + """");
        if status
            disp("Call to pdfcrop failed with error message: " + result);
        end
    end
  
end