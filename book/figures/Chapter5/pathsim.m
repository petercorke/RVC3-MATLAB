function x = pathsim(x0, u)

    if nargin < 2
        vel = 1
    end

    tmax = 2;
    L = 0.5;

    f = @(t, x) bicycle(t, x, u, L);

    [t,x] = ode45(f, [0 tmax], x0(:)');
    if nargout < 1
        plot2(x);
    end

end

function xdot = bicycle(t, x, u, L)


    xb = x(1); yb = x(2); thb = x(3);
    v = u(1); gamma = u(2);

    xdot = v * [ cos(thb)
                 sin(thb)
                 tan(gamma) / L ];
end