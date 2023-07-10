classdef tTransformations2d < RVCTest & matlab.unittest.TestCase
    % Testing 2D Homogeneous Transformation functions

    % Copyright 2023 Peter Corke, Witold Jachimczyk, Remo Pillat

    methods (TestMethodTeardown)
        function closeFigure(testcase)
            close("all")
        end
    end

    methods (Test)

        function teardownOnce(testcase)
            close all
        end

        %% first of all check we can tell a good matrix from a bad one
        function isrotm2d(testcase)
            R1 = diag([1 1]);    % proper
            R2 = diag([1 2]);    % not proper
            R3 = diag([2 0.5]);  % not proper
            R4 = diag([1 -1]);  % not proper

            % test shapes
            testcase.verifyFalse(isrotm2d(1))
            testcase.verifyFalse(isrotm2d(zeros(3,3)))
            testcase.verifyFalse(isrotm2d(zeros(4,4)))
            testcase.verifyFalse(isrotm2d(zeros(2,1)))
            testcase.verifyFalse(isrotm2d(zeros(1,2)))

            % test shapes with validity check
            testcase.verifyFalse(isrotm2d(1, check=true))
            testcase.verifyFalse(isrotm2d(zeros(2,2), check=true))
            testcase.verifyFalse(isrotm2d(zeros(4,4), check=true))
            testcase.verifyFalse(isrotm2d(zeros(4,1), check=true))
            testcase.verifyFalse(isrotm2d(zeros(1,4), check=true))

            % test 3x3
            testcase.verifyTrue(isrotm2d(R1))
            testcase.verifyTrue(isrotm2d(R2))
            testcase.verifyTrue(isrotm2d(R3))
            testcase.verifyTrue(isrotm2d(R4))

            % test 3x3 with validity check
            testcase.verifyTrue(isrotm2d(R1, check=true))
            testcase.verifyFalse(isrotm2d(R2, check=true))
            testcase.verifyFalse(isrotm2d(R3, check=true))
            testcase.verifyFalse(isrotm2d(R4, check=true))

            % vector case
            testcase.verifyTrue(isrotm2d(cat(3, R1, R1, R1)))
            testcase.verifyTrue(isrotm2d(cat(3, R1, R1, R1), check=true))
            testcase.verifyTrue(isrotm2d(cat(3, R1, R2, R3)))
            testcase.verifyFalse(isrotm2d(cat(3, R1, R2, R3), check=true))
        end

        function istform2d(testcase)
            T1 = diag([1 1 1]);    % proper
            T2 = diag([1 -1 1]);   % not proper
            T3 = diag([1 2 1]);    % not proper
            T4 = diag([2 0.5 1]);  % not proper
            T5 = diag([1 1 0]);    % not proper


            % test shapes
            testcase.verifyFalse(istform2d(1))
            testcase.verifyFalse(istform2d(zeros(2,2)))
            testcase.verifyFalse(istform2d(zeros(4,4)))
            testcase.verifyFalse(istform2d(zeros(3,1)))
            testcase.verifyFalse(istform2d(zeros(1,3)))

            % test shapes with validity check
            testcase.verifyFalse(istform2d(1, check=true))
            testcase.verifyFalse(istform2d(zeros(2,2), check=true))
            testcase.verifyFalse(istform2d(zeros(4,4), check=true))
            testcase.verifyFalse(istform2d(zeros(4,1), check=true))
            testcase.verifyFalse(istform2d(zeros(1,4), check=true))

            % test 4x4
            testcase.verifyTrue(istform2d(T1))
            testcase.verifyTrue(istform2d(T2))
            testcase.verifyTrue(istform2d(T3))
            testcase.verifyTrue(istform2d(T4))
            testcase.verifyTrue(istform2d(T5))


            % test 4x4 with validity check
            testcase.verifyTrue(istform2d(T1, check=true))
            testcase.verifyFalse(istform2d(T2, check=true))
            testcase.verifyFalse(istform2d(T3, check=true))
            testcase.verifyFalse(istform2d(T4, check=true))
            testcase.verifyFalse(istform2d(T5, check=true))


            % vector case
            testcase.verifyTrue(istform2d(cat(3, T1, T1, T1)))
            testcase.verifyTrue(istform2d(cat(3, T1, T1, T1), check=true))
            testcase.verifyTrue(istform2d(cat(3, T1, T2, T3)))
            testcase.verifyFalse(istform2d(cat(3, T1, T2, T3), check=true))
        end

        %% SO(2)
        function rotm2d(testcase)
            testcase.verifyEqual(rotm2d(0), eye(2,2), absTol=1e-6);
            testcase.verifyEqual(rotm2d(0), eye(2,2), absTol=1e-6);

            testcase.verifyEqual(rotm2d(pi)*rotm2d(-pi/2), ...
                rotm2d(pi/2), absTol=1e-6);
        end

        function tformr2d(testcase)
            testcase.verifyEqual(tformr2d(0), eye(3,3), absTol=1e-6);

            testcase.verifyEqual(tformr2d(pi/2), [0 -1 0; 1 0 0; 0 0 1], absTol=1e-6);

            testcase.verifyEqual(tformr2d(90, 'deg'),[0 -1 0; 1 0 0; 0 0 1], absTol=1e-6);
            testcase.verifyEqual(tformr2d(pi)*tformr2d(-pi/2), ...
                tformr2d(pi/2), absTol=1e-6);

        end

        function printtform2d(testcase)
            a = trvec2tform([1,2]) * tformr2d(0.3);

            printtform2d(a);

            s = evalc('printtform2d(a)');
            testcase.verifyTrue(isa(s, 'char'));
            testcase.verifyEqual(size(s,1), 1);

            s = printtform2d(a);
            testcase.verifyClass(s, 'string');
            testcase.verifyEqual(size(s,1), 1);

            printtform2d(a, unit='rad');
            printtform2d(a, fmt='%g');
            printtform2d(a, label='bob');

            a = cat(3, a, a, a);
            printtform2d(a);

            s = evalc('printtform2d(a)');
            testcase.verifyTrue(isa(s, 'char'));
            testcase.verifyEqual(size(s,1), 1);

            testcase.verifyEqual(length(regexp(s, '\n', 'match')), 3);

            printtform2d(a, unit='rad');
            printtform2d(a, fmt='%g');
            printtform2d(a, label='bob');
        end

        function skew2vec(testcase)
            S = [0 -2; 2 0];
            testcase.verifyEqual(skew2vec(S), 2);

            S = [0 2; -2 0];
            testcase.verifyEqual(skew2vec(S), -2);
        end


        function vec2skew(testcase)
            S = vec2skew(3);

            testcase.verifyTrue(all(size(S) == [2 2]));  % check size

            testcase.verifyEqual(norm(S'+ S), 0, absTol=1e-10); % check is skew

            testcase.verifyEqual(skew2vec(S), 3); % check contents, vex already verified

            testcase.verifyError(@() vec2skew([1 2]), "RVC3:vec2skew:badarg")

        end

        function skewa2vec(testcase)
            S = [0 -2 3 ; 2 0 4; 0 0 0];
            testcase.verifyEqual(skewa2vec(S), [2 3 4]);

            S = [0 2 3 ; -2 0 4; 0 0 0];
            testcase.verifyEqual(skewa2vec(S), [-2 3 4]);
        end


        function vec2skewa(testcase)
            S = vec2skewa([3 4 5]);

            testcase.verifyTrue(istform2d(S));  % check size

            SS = S(1:2,1:2);
            testcase.verifyEqual(norm(SS'+ SS), 0, absTol=1e-10); % check is skew

            testcase.verifyEqual(skew2vec(SS), [3]); % check contents, vexa already verified

            testcase.verifyError(@() vec2skewa([1 2]), 'RVC3:vec2skewa:badarg')

        end


        function e2h(testcase)
            P1 = [1 2];
            P2 = [1 2 3 4 5; 6 7 8 9 10]';

            testcase.verifyEqual(e2h(P1), [P1 1]);
            testcase.verifyEqual(e2h(P2), [P2 ones(5,1)]);
        end

        function h2e(testcase)
            P1 = [1 2];
            P2 = [1 2 3 4 5; 6 7 8 9 10]';

            testcase.verifyEqual(h2e(e2h(P1)), P1);
            testcase.verifyEqual(h2e(e2h(P2)), P2);
        end

        function homtrans(testcase)

            P1 = [1 2];
            P2 = [1 2 3 4 5; 6 7 8 9 10]';

            T = eye(3,3);
            testcase.verifyEqual(homtrans(T, P1), P1);
            testcase.verifyEqual(homtrans(T, P2), P2);

            Q = [-2 2];
            T = trvec2tform(Q);
            testcase.verifyEqual(homtrans(T, P1), P1+Q);
            testcase.verifyEqual(homtrans(T, P2), P2+Q);

            T = tformr2d(pi/2);
            testcase.verifyEqual(homtrans(T, P1), [-P1(2) P1(1)], absTol=1e-6);
            testcase.verifyEqual(homtrans(T, P2), [-P2(:,2) P2(:,1)], absTol=1e-6);

            T =  trvec2tform(Q)*tformr2d(pi/2);
            testcase.verifyEqual(homtrans(T, P1), [-P1(2) P1(1)]+Q, absTol=1e-6);
            testcase.verifyEqual(homtrans(T, P2), [-P2(:,2,:) P2(:,1)]+Q, absTol=1e-6);

            % projective point case
            P1h = e2h(P1);
            P2h = e2h(P2);
            testcase.verifyEqual(homtrans(T, P1h), [-P1(2) P1(1) 1]+[Q 0], absTol=1e-6);
            testcase.verifyEqual(homtrans(T, P2h), [-P2(:,2) P2(:,1) ones(5,1)]+[Q 0], absTol=1e-6);


            % error case
            testcase.verifyError(@() homtrans(7, P1), 'RVC3:homtrans:badarg')

        end

    end % methods
end