classdef tTwist < RVCTest & matlab.unittest.TestCase
    % Testing Twist and Twist2d objects

    % Copyright 2023 Peter Corke, Witold Jachimczyk, Remo Pillat

    methods (TestMethodTeardown)
        function closeFigure(testcase)
            close("all")
        end
    end

    methods (Test)

        function twist2d_test(tc)
            %%2D twists

            % check basics work
            s = [1 2 3];
            tw = Twist2d(s);
            verifyEqual(tc, tw.compact, s, absTol=1e-6);
            verifyEqual(tc, tw.v, s(2:3), absTol=1e-6);
            verifyEqual(tc, tw.w, s(1), absTol=1e-6);
            verifyEqual(tc, tw.skewa, [vec2skew(s(1)) [s(2:3)]'; 0 0 0], absTol=1e-6);
        end



        function operator2d_test(tc)
            % check overloaded *

            tw = Twist2d([1 2 3]);
            tw2 = Twist2d([4 6 5]);

            both = tw * tw2;

            Tboth = tw.tform * tw2.tform;
            verifyEqual(tc, both.tform, Tboth, absTol=1e-6);

            % check rotational twist
            tw = Twist2d.UnitRevolute([1 2]);
            verifyEqual(tc, tw.compact, [1 2 -1], absTol=1e-6);

            % check prismatic twist
            tw = Twist2d.UnitPrismatic([2 3]);
            verifyEqual(tc, tw.compact, [0 unitvector([2 3])], absTol=1e-6);

            % check twist from SE(2)
            tw = Twist2d( tformr2d(0) );
            verifyEqual(tc, tw.compact, [0 0 0], absTol=1e-6);
            tw = Twist2d( tformr2d(pi/2) );
            verifyEqual(tc, tw.compact, [pi/2 0 0], absTol=1e-6);
            tw = Twist2d( se2(0, "theta", [1,2]) );
            verifyEqual(tc, tw.compact, [0 1 2], absTol=1e-6);
            tw = Twist2d( se2(pi/2, "theta", [1,2]) );
            verifyEqual(tc, tw.compact, [pi/2 3*pi/4 pi/4], absTol=1e-6);

            % test expm and T
            verifyEqual(tc, tw.tform, expm(tw.skewa), absTol=1e-6);
            verifyEqual(tc, tw.exp.tform, tw.tform);
            verifyEqual(tc, tw.exp(2).tform, tw.tform(2));

            tw = Twist2d.UnitRevolute([1 2]);
            verifyEqual(tc, tw.tform(pi/2), [0 -1 3; 1 0 1; 0 0 1], absTol=1e-6);
        end

        function operator3d_test(tc)
            %% 3D twists

            % check basics work
            s = [1 2 3 4 5 6];
            tw = Twist(s);
            verifyEqual(tc, tw.compact, s, absTol=1e-6);
            verifyEqual(tc, tw.v, s(4:6), absTol=1e-6);
            verifyEqual(tc, tw.w, s(1:3), absTol=1e-6);
            verifyEqual(tc, tw.skewa, [skew(s(1:3)) [s(4:6)]'; 0 0 0 0], absTol=1e-6);

            % check overloaded *
            s2 = [4 6 5 7 9 8];
            tw2 = Twist(s2);

            both = tw * tw2;

            Tboth = tw.tform * tw2.tform;
            verifyEqual(tc, both.tform, Tboth, absTol=1e-6);

            % check rotational twist
            tw = Twist.UnitRevolute([1 2 3], [0 0 0]);
            verifyEqual(tc, tw.compact, [unitvector([1 2 3]) 0 0 0 ], absTol=1e-6);

            % check prismatic twist
            tw = Twist.UnitPrismatic([1 2 3]);
            verifyEqual(tc, tw.compact, [0 0 0 unitvector([1 2 3])], absTol=1e-6);

            % check twist from SE(3)
            tw = Twist( tformrx(0) );
            verifyEqual(tc, tw.compact, [0 0 0  0 0 0], absTol=1e-6);
            tw = Twist( tformrx(pi/2) );
            verifyEqual(tc, tw.compact, [pi/2 0 0  0 0 0], absTol=1e-6);
            tw = Twist( tformry(pi/2) );
            verifyEqual(tc, tw.compact, [0 pi/2 0  0 0 0], absTol=1e-6);
            tw = Twist( tformrz(pi/2) );
            verifyEqual(tc, tw.compact, [0 0 pi/2  0 0 0], absTol=1e-6);

            tw = Twist( trvec2tform([1 2 3]) );
            verifyEqual(tc, tw.compact, [0 0 0  1 2 3], absTol=1e-6);
            tw = Twist( trvec2tform([1 2 3])*tformry(pi/2) );
            verifyEqual(tc, tw.compact, [0 pi/2 0  -pi/2 2 pi], absTol=1e-6);

            tw = Twist( se3(eye(3), [1 2 3]) );
            verifyEqual(tc, tw.compact, [0 0 0 1 2 3], absTol=1e-6);


            % test expm and T
            verifyEqual(tc, tw.tform, expm(tw.skewa));
            verifyEqual(tc, tw.exp.tform, tw.tform);
            verifyEqual(tc, tw.exp(2).tform, tw.tform(2));

            tw = Twist.UnitRevolute([1 0 0], [0 0 0]);
            verifyEqual(tc, tw.tform(pi/2), tformrx(pi/2), absTol=1e-6);
            tw = Twist.UnitRevolute([0 1 0], [0 0 0]);
            verifyEqual(tc, tw.tform(pi/2), tformry(pi/2), absTol=1e-6);
            tw = Twist.UnitRevolute([0 0 1], [0 0 0]);
            verifyEqual(tc, tw.tform(pi/2), tformrz(pi/2), absTol=1e-6);
        end


        function char_test(tc)
            % 2d

            tw = Twist2d([1 2 3]);

            s = char(tw);
            tc.verifyClass(s, 'char');
            tc.verifyEqual(size(s,1), 1);
            s = char([tw tw tw]);
            tc.verifyClass(s, 'char');
            tc.verifyEqual(size(s,1), 3);
            s = char([tw tw tw]');
            tc.verifyClass(s, 'char');
            tc.verifyEqual(size(s,1), 3);

            % 3d
            tw = Twist([4 6 5 7 9 8]);
            s = char(tw);
            tc.verifyClass(s, 'char');
            tc.verifyEqual(size(s,1), 1);
            s = char([tw tw tw]);
            tc.verifyClass(s, 'char');
            tc.verifyEqual(size(s,1), 3);
            s = char([tw tw tw]');
            tc.verifyClass(s, 'char');
            tc.verifyEqual(size(s,1), 3);
        end
    end % methods
end