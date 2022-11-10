%KDGAUSS Derivative of Gaussian kernel
%
% K = KDGAUSS(SIGMA) is a 2-dimensional derivative of Gaussian kernel (WxW)
% of width (standard deviation) SIGMA and centered within the matrix K
% whose half-width H = 3xSIGMA and W=2xH+1.
%
% K = KDGAUSS(SIGMA, H) as above but the half-width is explictly specified.
%
% Notes::
% - This kernel is the horizontal derivative of the Gaussian, dG/dx.
% - The vertical derivative, dG/dy, is K'.
% - This kernel is an effective edge detector.
%
% See also KGAUSS, KDOG, KLOG, ISOBEL, ICONV.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function m = kdgauss(sigma, w)


    if nargin == 1,
        w = ceil(3*sigma);
    end
    ww = 2*w + 1;

    [x,y] = meshgrid(-w:w, -w:w);

    % This should properly be
    %   m = -x/sigma^4 /(2*pi) .*  exp( -(x.^2 + y.^2)/2/sigma^2);
    % but the effect of the error is simply to scale the result by sigma^2.
    %
    % Too many results in the book depend on this...
    
    m = -x/sigma^2 /(2*pi) .*  exp( -(x.^2 + y.^2)/2/sigma^2);


