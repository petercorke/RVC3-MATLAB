%% This is for testing the Plotting functions in the robotics Toolbox
function tests = TransformationsTest
  tests = functiontests(localfunctions);
  clc
end

function teardownOnce(tc)
    close all
end

%    tranimate                  - animate a coordinate frame
function animtform_test(tc)
    X1 = eye(3,3); X2 = rotmx(pi/2);
    clf; animtform(X2);
    clf; animtform(X1, X2);
    clf; animtform(X1, X2, nsteps=10);
    
    clf; animtform(X1, X2, 'axis', [-10 10 -20 20 -30 30]);
    ax = gca; v = [ax.XLim ax.YLim ax.ZLim];
    tc.verifyEqual(v, [-10 10 -20 20 -30 30]); % 19b doesnt give 
    
    clf; animtform(X1, X2, style='rgb');
    clf; animtform(X1, X2, retain=true);
    clf; animtform(X1, X2, fps=20);
    
    X1 = eye(4,4); X2 = trvec2tform([1 2 3])*tformrx(pi/2);
    clf; animtform(X1, X2);
    clf; animtform(X1, X2, 'nsteps', 10);
    
    clf; animtform(X1, X2, 'axis', [-10 10 -20 20 -30 30]);
    %v = axis;
    ax = gca; v = [ax.XLim ax.YLim ax.ZLim];
    tc.verifyEqual(v, [-10 10 -20 20 -30 30]);
    
    clf; animtform(X1, X2, style='rgb');
    clf; animtform(X1, X2, retain=true);
    clf; animtform(X1, X2, fps=20);
end

function animtform2d_test(tc)
    X1 = eye(2,2); X2 = rotm2d(pi/2);
    animtform2d(X1, X2);
    animtform2d(X1, X2, nsteps=10);
    
    clf; animtform2d(X1, X2, 'axis', [-10 10 -20 20]);
    v = axis;
    tc.verifyEqual(v, [-10 10 -20 20]);
    
    clf; animtform2d(X1, X2, style='rg');
    clf; animtform2d(X1, X2, retain=true);
    clf; animtform2d(X1, X2, fps=20);
    
    
    X1 = eye(3,3); X2 = trvec2tform([1 2])*tformr2d(pi/2);
    clf; animtform2d(X1, X2);
    clf; animtform2d(X1, X2, 'nsteps', 10);
    
    clf; animtform2d(X1, X2, 'axis', [-10 10 -20 20]);
    v = axis;
    tc.verifyEqual(v, [-10 10 -20 20]);
    
    clf; animtform2d(X1, X2, style='rg');
    clf; animtform2d(X1, X2, retain=true);
    clf; animtform2d(X1, X2, fps=20);
end

%    trplot                     - plot HT as a coordinate frame
function plottform_test(tc)
    %%
    Rt1 = [1.0000         0         0         0
                0    0.8253   -0.5646         0
                0    0.5646    0.8253         0
                0         0         0    1.0000];
    clf; plottform(Rt1);
    clf; h = plottform(Rt1);
    plottform(Rt1, 'handle', h);
    clf; plottform(Rt1, 'color', 'r');
    clf; plottform(Rt1, 'color', [1 0 1]);
    clf; plottform(Rt1, axes=false);
    clf; plottform(Rt1, 'frame', 'bob');
    clf; plottform(Rt1, 'frame', 'A', 'text_options', struct(FontSize=10, FontWeight='bold'))
    clf; plottform(Rt1, 'view', [10 20]);
    clf; plottform(Rt1, 'arrow',true)
    clf; plottform(Rt1, 'anaglyph', 'mo')
    clf; plottform(Rt1, 'anaglyph', 'mo', 'dispar', 0.3);
end

 function plottform2d_test(tc)
     %%
    Rt1 = [
    0.9553   -0.2955    1.0000
    0.2955    0.9553    2.0000
         0         0    1.0000];
    clf; plottform2d(Rt1);
    clf; h = plottform2d(Rt1);
    plottform2d(Rt1, 'handle', h);
    clf; plottform2d(Rt1, 'color', 'r');
    clf; plottform2d(Rt1, 'color', [1 0 0]);
    clf; plottform2d(Rt1, 'axes', false);
    clf; plottform2d(Rt1, 'frame', 'bob');
    clf; plottform2d(Rt1, 'frame', 'A', 'text_opts', struct(FontSize=10, FontWeight=bold'))
    clf; plottform2d(Rt1, 'arrow', false)
    clf; plottform2d(Rt1, 'framelabel', 'A')
    
    a = gca;
    plottform2d(Rt1, 'axhandle', a);
 
    clf; h = plottform2d(Rt1);
    tc.verifyWarning( @() trplot2(h, Rt1), 'SMTB:trplot2:deprecated')
end

%    plot_box                   - draw a box
function plot_box_test(tc)
        plot_box(1,1,5,5,'b');
        plot_box(2,2,4,4,'g');
end

%    plot_circle                - draw a circle
function plot_circle_test(tc)
    plotcircle([1 2],2,'g');
    plotcircle([1 2],2,'fillcolor', 'g');
    plotcircle([1 2],2,'fillcolor', 'g', 'alpha', 0.5);
    plotcircle([1 2],2,'edgecolor', 'b');
    plotcircle([1 2],2,'fillcolor', 'g', 'edgecolor', 'b');
end


%    plot_ellipse               - draw an ellipse
function plotellipse_test(tc)
    
    C = diag([1,4]);
    plotellipse(C,[2 3],'r');
    plotellipse(C,[2 3],'fillcolor', 'g');
    plotellipse(C,[2 3],'fillcolor', 'g', 'alpha', 0.5);
    plotellipse(C,[2 3],'edgecolor', 'g');
    plotellipse(C,[2 3],'fillcolor', 'g', 'edgecolor', 'b');
    
    % with 3d centre
    plotellipse([1 0; 0 4],[2 3 1],'r');
end

function plotellipsoid_test(tc)
    
    C = diag([1,4,2]);
    plotellipsoid(C,[2 3 1],'r');
    plotellipsoid(C,[2 3 1],'fillcolor', 'g');
    plotellipsoid(C,[2 3 1],'fillcolor', 'g', 'alpha', 0.5);
    plotellipsoid(C,[2 3 1],'edgecolor', 'g');
    plotellipsoid(C,[2 3 1],'fillcolor', 'g', 'edgecolor', 'b');
end

%    plot_homline               - plot homogeneous line
function plothomline_test(tc)
    plothomline([1 2 3],'y');
end

%    plot_point                 - plot points
function plotpoint_test(tc)
    plotpoint([1 2]);
end

%    plot_poly                  - plot polygon
function plot_poly_test(tc)
    p = [1 2 2 1; 1 1 2 2]; 
    plot_poly(p,'g');
end

%    plot_sphere                - draw a sphere
function plotsphere_test(tc)
     plotsphere([1 2 3],5,'r');
end

function xyzlabel_test(tc)
    
    plot3(1, 2, 3)
    xyzlabel()
end

function plotvol_test(tc)
    
    % 2D cases
    plotvol([2 3])
    tc.verifyEqual(axis, [-2 2 -3 3]);
    plotvol([2 3 4 5])
    tc.verifyEqual(axis, [2 3 4 5]);
    
    % 3D cases
    plotvol(3)
    ax = gca; v = [ax.XLim ax.YLim ax.ZLim];
    tc.verifyEqual(v, 3*[-1 1 -1 1 -1 1]);
    
    plotvol([1 2 3]);
    ax = gca; v = [ax.XLim ax.YLim ax.ZLim];
    tc.verifyEqual(v, [-1 1 -2 2 -3 3]);
    
    plotvol([1 2 3 4 5 6]);
    ax = gca; v = [ax.XLim ax.YLim ax.ZLim];
    tc.verifyEqual(v, [1 2 3 4 5 6]);
end
