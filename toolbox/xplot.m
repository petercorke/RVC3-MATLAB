%XPLOT Plot robot joint angles
%
% XPLOT(Q) is a convenience function to plot joint angle trajectories (Mx6) for
% a 6-axis robot, where each row represents one time step.
%
% The first three joints are shown as solid lines, the last three joints (wrist)
% are shown as dashed lines.  A legend is also displayed.
%
% XPLOT(T, Q) as above but displays the joint angle trajectory versus time
% given the time vector T (Mx1).
%
% Options:
%
%  unwrap       - if true, values are considered angles and unwrapped
%
% See also JTRAJ, PLOTP, PLOT.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function xplot(varargin)

    ip = inputParser();
    if isnumeric(varargin{1}) && isvector(varargin{1})
        % Syntax: XPLOT(T,Q)
        ip.addRequired("t");
        ip.addRequired("q", @(x) isnumeric(x) && (size(x,2) == 6));
    else
        % Syntax: XPLOT(Q)
        ip.addRequired("q", @(x) isnumeric(x) && (size(x,2) == 6));
    end
    ip.addParameter("unwrap", false, @(x) islogical(x));
    ip.parse(varargin{:});
    args = ip.Results;

    q = args.q;
    t = args.t;
    if isempty(t)
        t = [0:size(q, 1)-1]';
    end
    
    if args.unwrap
        q = unwrap(q);
    end
    
    %clf
    hold on
    plot(t, q(:,1:3))
    plot(t, q(:,4:6), '--')
    grid on
    xlabel('Time (s)')
    ylabel('Joint coordinates (rad,m)')
    legend('q1', 'q2', 'q3', 'q4', 'q5', 'q6');
    hold off
    
    xlim([t(1), t(end)]);
end
