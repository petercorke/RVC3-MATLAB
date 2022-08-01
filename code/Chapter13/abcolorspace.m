function [im,ax,ay] = abcolorspace(varargin)
    
    opt.N = 501;
    opt.L = 90; % luminance 0 to 100
    
    [opt,args] = tb_optparse(opt, varargin);

    % Generate colors in the Lab color space
    a = linspace(-128, 128, opt.N);
    b = linspace(-128, 128, opt.N);
    [aa,bb] = meshgrid(a, b);

    % Convert from Lab to R'G'B'
    color = colorspace('rgb<-lab',[opt.L*ones(size(aa(:))) aa(:) bb(:) ]);

    color = col2im(color, [opt.N opt.N]);
    
    color = ipixswitch(kcircle(floor(opt.N/2)), color, [1 1 1]);
        

    if nargout == 0
        % Render the colors on the plane
        image(a, b, color)
        if length(args) > 0
            cxy = args{1};
            plot_point(cxy, 'k*', 'textsize', 10, 'sequence', 'textcolor', 'k');
        end
        
        set(gca, 'Ydir', 'normal');
        axis equal
        xaxis(-128, 128); yaxis(-128, 128)
        xlabel('a*'); ylabel('b*')
        grid
        shg;
    else
        ax = a;
        ay = b;
        im = color;
    end