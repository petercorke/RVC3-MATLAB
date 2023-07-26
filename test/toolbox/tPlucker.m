classdef tPlucker < RVCTest & matlab.unittest.TestCase
    % Test Plucker objects for representing 3D lines

    % Copyright 2023 Peter Corke, Witold Jachimczyk, Remo Pillat

    methods (TestMethodTeardown)
        function closeFigure(testcase)
            close("all")
        end
    end

    methods (Test)

        % Primitives
        function constructor1(testcase)

            % construct from 6-vector
            L = Plucker([1 2 3 4 5 6]);
            testcase.verifyTrue( isa(L, 'Plucker') );
            testcase.verifyEqual(L.w, [1 2 3],absTol=1e-10);
            testcase.verifyEqual(L.v, [4 5 6],absTol=1e-10);

            % construct from object
            L2 = Plucker(L);
            testcase.verifyTrue( isa(L2, 'Plucker') );
            testcase.verifyEqual(L2.w, [1 2 3],absTol=1e-10);
            testcase.verifyEqual(L2.v, [4 5 6],absTol=1e-10);

            % construct from point and direction
            L = Plucker.PointDir([1 2 3], [4 5 6]);
            testcase.verifyTrue(L.contains([1 2 3]));
            testcase.verifyEqual(L.uw, unitvector([4 5 6]), absTol=1e-10);
        end

        function compact(testcase)
            % verify double
            L = Plucker([1 2 3 4 5 6]);
            testcase.verifyEqual(compact(L), [1 2 3 4 5 6], absTol=1e-10);
        end

        function constructor2(testcase)
            % 2 point constructor
            P = [2 3 7]; Q = [2 1 0];
            L = Plucker(P, Q);
            testcase.verifyEqual(L.w, P-Q,absTol=1e-10);
            testcase.verifyEqual(L.v, cross(P-Q,Q),absTol=1e-10);

            % test all possible input shapes
            L2 = Plucker(P', Q);
            testcase.verifyEqual(compact(L2), compact(L), absTol=1e-10);
            L2 = Plucker(P, Q');
            testcase.verifyEqual(compact(L2), compact(L), absTol=1e-10);
            L2 = Plucker(P', Q');
            testcase.verifyEqual(compact(L2), compact(L), absTol=1e-10);
            L2 = Plucker(P, Q);
            testcase.verifyEqual(compact(L2), compact(L), absTol=1e-10);

            % planes constructor
            P = [10 11 12]'; w = [1 2 3];
            L = Plucker.PointDir(P, w);
            testcase.verifyEqual(compact(L), [w cross(w,P)], absTol=1e-10);
            L2 = Plucker.PointDir(P', w);
            testcase.verifyEqual(compact(L2), compact(L), absTol=1e-10);
            L2 = Plucker.PointDir(P, w');
            testcase.verifyEqual(compact(L2), compact(L), absTol=1e-10);
            L2 = Plucker.PointDir(P', w');
            testcase.verifyEqual(compact(L2), compact(L), absTol=1e-10);
        end

        function pp(testcase)
            % validate pp and ppd
            L = Plucker([-1 1 2], [1 1 2]);
            testcase.verifyEqual(L.pp, [0 1 2], absTol=1e-10);
            testcase.verifyEqual(L.ppd, sqrt(5), absTol=1e-10);

            % validate pp
            testcase.verifyTrue( L.contains(L.pp) );
        end

        function contains(testcase)
            P = [2 3 7]; Q = [2 1 0];
            L = Plucker(P, Q);

            % validate contains
            testcase.verifyTrue( L.contains([2 3 7]) );
            testcase.verifyTrue( L.contains([2 1 0]) );
            testcase.verifyFalse( L.contains([2 1 4]) );
        end


        function closest(testcase)
            P = [2 3 7]; Q = [2 1 0];
            L = Plucker(P, Q);

            [p,d] = L.closest(P);
            testcase.verifyEqual(p, P, absTol=1e-10);
            testcase.verifyEqual(d, 0, absTol=1e-10);

            % validate closest with given points and origin
            [p,d] = L.closest(Q);
            testcase.verifyEqual(p, Q, absTol=1e-10);
            testcase.verifyEqual(d, 0, absTol=1e-10);

            L = Plucker([-1 1 2], [1 1 2]);
            [p,d] = L.closest([0 1 2]);
            testcase.verifyEqual(p, [0 1 2], absTol=1e-10);
            testcase.verifyEqual(d, 0, absTol=1e-10);

            [p,d] = L.closest([5 1 2]);
            testcase.verifyEqual(p, [5 1 2], absTol=1e-10);
            testcase.verifyEqual(d, 0, absTol=1e-10);

            [p,d] = L.closest([0 0 0]);
            testcase.verifyEqual(p, L.pp, absTol=1e-10);
            testcase.verifyEqual(d, L.ppd, absTol=1e-10);

            [p,d] = L.closest([5 1 0]);
            testcase.verifyEqual(p, [5 1 2], absTol=1e-10);
            testcase.verifyEqual(d, 2, absTol=1e-10);
        end

        function plot(testcase)

            P = [2 3 7]; Q = [2 1 0];
            L = Plucker(P, Q);

            axis(10*[-1 1 -1 1 -1 1]);
            plot(L, 'r', 'LineWidth', 2);
        end

        function eq(testcase)
            w = [1 2 3];
            P = [-2 4 3];

            L1 = Plucker(P, P+w);
            L2 = Plucker(P+2*w, P+5*w);
            L3 = Plucker(P+[1 0 0], P+w);

            testcase.verifyTrue(L1 == L2);
            testcase.verifyFalse(L1 == L3);

            testcase.verifyFalse(L1 ~= L2);
            testcase.verifyTrue(L1 ~= L3);
        end

        function skew(testcase)

            P = [2 3 7]; Q = [2 1 0];
            L = Plucker(P, Q);

            m = L.skew;

            testcase.verifyEqual(size(m), [4 4]);
            testcase.verifyEqual(m+m', zeros(4,4), absTol=1e-10);
        end

        function mtimes(testcase)
            P = [1 2 0]; Q = [1 2 10];  % vertical line through (1,2)
            L = Plucker(P, Q);

            % check pre/post multiply by matrix
            M = rand(4,10);

            a = L * M;
            testcase.verifyEqual(a, L.skew*M);

        end

        function transform(testcase)
            P = [1 2 0]; Q = [1 2 10];  % vertical line through (1,2)
            L = Plucker(P, Q);
            % check transformation by SE3

            L2 = L.transform(se3());
            testcase.verifyEqual(L.compact, L2.compact);

            L2 = L.transform(se3([2, 3, 1], "trvec")); % shift line in the xy directions
            pxy = L2.intersect_plane([0 0 1 0]);
            testcase.verifyEqual(pxy, [1+2 2+3 0]);

        end

        function parallel(testcase)

            L1 = Plucker.PointDir([4 5 6], [1 2 3]);
            L2 = Plucker.PointDir([5 5 6], [1 2 3]);
            L3 = Plucker.PointDir([4 5 6], [3 2 1]);

            % L1 || L2 but doesnt intersect
            % L1 intersects L3

            testcase.verifyTrue( isparallel(L1, L1) );
            testcase.verifyTrue(L1 | L1);

            testcase.verifyTrue( isparallel(L1, L2) );
            testcase.verifyTrue(L1 | L2);
            testcase.verifyTrue( isparallel(L2, L1) );
            testcase.verifyTrue(L2 | L1);
            testcase.verifyFalse( isparallel(L1, L3) );
            testcase.verifyFalse(L1 | L3);
        end

        function intersect(testcase)


            L1 = Plucker.PointDir([4 5 6], [1 2 3]);
            L2 = Plucker.PointDir([5 5 6], [1 2 3]);
            L3 = Plucker.PointDir( [4 5 6], [0 0 1]);
            L4 = Plucker.PointDir([5 5 6], [1 0 0]);

            % L1 || L2 but doesnt intersect
            % L3 intersects L4
            testcase.verifyFalse( L1^L2 );

            testcase.verifyTrue( L3^L4 );

        end

        function commonperp(testcase)
            L1 = Plucker.PointDir([4 5 6], [0 0 1]);
            L2 = Plucker.PointDir([6 5 6], [0 1 0]);

            testcase.verifyFalse( L1|L2 );
            testcase.verifyFalse( L1^L2 );

            testcase.verifyEqual( distance(L1, L2), 2);

            L = commonperp(L1, L2);  % common perp intersects both lines

            testcase.verifyTrue( L^L1 );
            testcase.verifyTrue( L^L2 );
        end


        function line(testcase)

            % mindist
            % intersect
            % char
            % intersect_volume
            % mindist
            % mtimes
            % or
            % side
        end

        function point(testcase)
            P = [2 3 7]; Q = [2 1 0];
            L = Plucker(P, Q);

            testcase.verifyTrue( L.contains(L.point(0)) );
            testcase.verifyTrue( L.contains(L.point(1)) );
            testcase.verifyTrue( L.contains(L.point(-1)) );
        end

        function char(testcase)
            P = [2 3 7]; Q = [2 1 0];
            L = Plucker(P, Q);

            s = char(L);
            testcase.verifyClass(s, 'char');
            testcase.verifyEqual(size(s,1), 1);

            s = char([L L]);
            testcase.verifyClass(s, 'char');
            testcase.verifyEqual(size(s,1), 2);
            s = char([L L]');
            testcase.verifyClass(s, 'char');
            testcase.verifyEqual(size(s,1), 2);
        end

        function plane(testcase)

            xyplane = [0 0 1 0];
            xzplane = [0 1 0 0];
            L = Plucker.Planes(xyplane, xzplane); % x axis
            testcase.verifyEqual(compact(L), [-1 0 0 0 0 0], absTol=1e-10);

            L = Plucker([-1 2 3], [1 2 3]);  %line at y=2,z=3
            x6 = [1 0 0 -6]; % x = 6

            % plane_intersect
            [p,lambda] = L.intersect_plane(x6);
            testcase.verifyEqual(p, [6 2 3],absTol=1e-10);
            testcase.verifyEqual(L.point(lambda), [6 2 3], absTol=1e-10);

            x6s.n = [1 0 0];
            x6s.p = [6 0 0];
            [p,lambda] = L.intersect_plane(x6s);
            testcase.verifyEqual(p, [6 2 3],absTol=1e-10);
            testcase.verifyEqual(L.point(lambda), [6 2 3], absTol=1e-10);
        end

        function methods(testcase)
            % intersection
            px = Plucker([0 0 0], [1 0 0]);  % x-axis
            py = Plucker([0 0 0], [0 1 0]);  % y-axis
            px1 = Plucker([0 1 0], [1 1 0]); % offset x-axis

            verifyEqual(testcase, px.ppd, 0);
            verifyEqual(testcase, px1.ppd, 1);
            verifyEqual(testcase, px1.pp, [0 1 0]);

            px.intersects(px);
            px.intersects(py);
            px.intersects(px1);
        end

        % function intersect(testcase)
        %     px = Plucker([0 0 0], [1 0 0]);  % x-axis
        %     py = Plucker([0 0 0], [0 1 0]);  % y-axis
        %
        %     plane.d = [1 0 0]; plane.p = 2; % plane x=2
        %
        %     px.intersect_plane(plane)
        %     py.intersect_plane(plane)
        % end
    end % methods
end