classdef tTransformations < RVCTest & matlab.unittest.TestCase
    % Testing 3D Homogeneous Transformation functions

    % Copyright 2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

    methods (TestMethodTeardown)
        function closeFigure(testcase)
            close("all")
        end
    end

    methods (Test)

        %% first of all check we can tell a good matrix from a bad one
        function isrotm(testcase)
            R1 = diag([1 1 1]);    % proper
            R2 = diag([1 1 -1]);   % not proper
            R3 = diag([1 2 1]);    % not proper
            R4 = diag([2 0.5 1]);  % not proper

            % test shapes
            testcase.verifyFalse( isrotm(1) )
            testcase.verifyFalse( isrotm( zeros(2,2) ) )
            testcase.verifyFalse( isrotm( zeros(4,4) ) )
            testcase.verifyFalse( isrotm( zeros(3,1) ) )
            testcase.verifyFalse( isrotm( zeros(1,3) ) )

            % test shapes with validity check
            testcase.verifyFalse( isrotm(1, check=true) )
            testcase.verifyFalse( isrotm( zeros(2,2), check=true ) )
            testcase.verifyFalse( isrotm( zeros(4,4), check=true ) )
            testcase.verifyFalse( isrotm( zeros(4,1), check=true ) )
            testcase.verifyFalse( isrotm( zeros(1,4), check=true ) )

            % test 3x3
            testcase.verifyTrue( isrotm(R1) )
            testcase.verifyTrue( isrotm(R2) )
            testcase.verifyTrue( isrotm(R3) )
            testcase.verifyTrue( isrotm(R4) )

            % test 3x3 with validity check
            testcase.verifyTrue( isrotm(R1, check=true) )
            testcase.verifyFalse( isrotm(R2, check=true) )
            testcase.verifyFalse( isrotm(R3, check=true) )
            testcase.verifyFalse( isrotm(R4, check=true) )

            % vector case
            testcase.verifyTrue( isrotm(cat(3, R1, R1, R1)) )
            testcase.verifyTrue( isrotm(cat(3, R1, R1, R1), check=true) )
            testcase.verifyTrue( isrotm(cat(3, R1, R2, R3)) )
            testcase.verifyFalse( isrotm(cat(3, R1, R2, R3), check=true) )
        end

        function istform(testcase)
            T1 = diag([1 1 1 1]);    % proper
            T2 = diag([1 1 -1 1]);   % not proper
            T3 = diag([1 2 1 1]);    % not proper
            T4 = diag([2 0.5 1 1]);  % not proper
            T5 = diag([1 1 1 0]);    % not proper


            % test shapes
            testcase.verifyFalse( istform(1) )
            testcase.verifyFalse( istform( zeros(2,2) ) )
            testcase.verifyFalse( istform( zeros(3,3) ) )
            testcase.verifyFalse( istform( zeros(4,1) ) )
            testcase.verifyFalse( istform( zeros(1,4) ) )

            % test shapes with validity check
            testcase.verifyFalse( istform(1, check=true) )
            testcase.verifyFalse( istform( zeros(2,2), check=true ) )
            testcase.verifyFalse( istform( zeros(3,3), check=true ) )
            testcase.verifyFalse( istform( zeros(4,1), check=true ) )
            testcase.verifyFalse( istform( zeros(1,4), check=true ) )

            % test 4x4
            testcase.verifyTrue( istform(T1) )
            testcase.verifyTrue( istform(T2) )
            testcase.verifyTrue( istform(T3) )
            testcase.verifyTrue( istform(T4) )
            testcase.verifyTrue( istform(T5) )


            % test 4x4 with validity check
            testcase.verifyTrue( istform(T1, check=true) )
            testcase.verifyFalse( istform(T2, check=true) )
            testcase.verifyFalse( istform(T3, check=true) )
            testcase.verifyFalse( istform(T4, check=true) )
            testcase.verifyFalse( istform(T5, check=true) )


            % vector case
            testcase.verifyTrue( istform(cat(3, T1, T1, T1)) )
            testcase.verifyTrue( istform(cat(3, T1, T1, T1), check=true) )
            testcase.verifyTrue( istform(cat(3, T1, T2, T3)) )
            testcase.verifyFalse( istform(cat(3, T1, T2, T3), check=true) )
        end

        % Primitives
        function rotmx(testcase)
            testcase.verifyEqual(rotmx(0), eye(3,3),absTol=1e-10);
            testcase.verifyEqual(rotmx(pi/2), [1 0 0; 0 0 -1; 0 1 0],absTol=1e-10);
            testcase.verifyEqual(rotmx(pi), [1 0 0; 0 -1 0; 0 0 -1],absTol=1e-10);

            testcase.verifyEqual(rotmx(90, 'deg'), [1 0 0; 0 0 -1; 0 1 0],absTol=1e-10);
            testcase.verifyEqual(rotmx(180, 'deg'), [1 0 0; 0 -1 0; 0 0 -1],absTol=1e-10);

            syms q
            R = rotmx(q);
            verifyInstanceOf(testcase, R, 'sym');
            verifySize(testcase, R, [3 3]);
            testcase.verifyEqual(simplify(det(R)), sym(1));

            %test for non-scalar input
            %     verifyError(testcase, @()rotmx([1 2 3]),'SMTB:rotx:badarg');
        end

        function rotmy(testcase)
            testcase.verifyEqual(rotmy(0), eye(3,3),absTol=1e-10);
            testcase.verifyEqual(rotmy(pi/2), [0 0 1; 0 1 0; -1 0 0],absTol=1e-10);
            testcase.verifyEqual(rotmy(pi), [-1 0 0; 0 1 0; 0 0 -1],absTol=1e-10);

            testcase.verifyEqual(rotmy(90, 'deg'), [0 0 1; 0 1 0; -1 0 0],absTol=1e-10);
            testcase.verifyEqual(rotmy(180, 'deg'), [-1 0 0; 0 1 0; 0 0 -1],absTol=1e-10);

            syms q
            R = rotmy(q);
            verifyInstanceOf(testcase, R, 'sym');
            verifySize(testcase, R, [3 3]);
            testcase.verifyEqual(simplify(det(R)), sym(1));

            %test for non-scalar input
            %     verifyError(testcase, @()rotmy([1 2 3]),'SMTB:roty:badarg');
        end

        function rotmz(testcase)
            testcase.verifyEqual(rotmz(0), eye(3,3),absTol=1e-10);
            testcase.verifyEqual(rotmz(pi/2), [0 -1 0; 1 0 0; 0 0 1],absTol=1e-10);
            testcase.verifyEqual(rotmz(pi), [-1 0 0; 0 -1 0; 0 0 1],absTol=1e-10);

            testcase.verifyEqual(rotmz(90, 'deg'), [0 -1 0; 1 0 0; 0 0 1],absTol=1e-10);
            testcase.verifyEqual(rotmz(180, 'deg'), [-1 0 0; 0 -1 0; 0 0 1],absTol=1e-10);

            syms q
            R = rotmz(q);
            verifyInstanceOf(testcase, R, 'sym');
            verifySize(testcase,R, [3 3]);
            testcase.verifyEqual(simplify(det(R)), sym(1));

            %test for non-scalar input
            %     verifyError(testcase, @()rotmz([1 2 3]),'SMTB:rotz:badarg');
        end

        function tformrx(testcase)
            testcase.verifyEqual(tformrx(0), eye(4,4),absTol=1e-10);
            testcase.verifyEqual(tformrx(pi/2), [1 0 0 0; 0 0 -1 0; 0 1 0 0; 0 0 0 1],absTol=1e-10);
            testcase.verifyEqual(tformrx(pi), [1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 1],absTol=1e-10);

            testcase.verifyEqual(tformrx(90, 'deg'), [1 0 0 0; 0 0 -1 0; 0 1 0 0; 0 0 0 1],absTol=1e-10);
            testcase.verifyEqual(tformrx(180, 'deg'), [1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 1],absTol=1e-10);

            %test for non-scalar input
            %     verifyError(testcase, @()tformrx([1 2 3; 0 0 0 1]),'MATLAB:catenate:dimensionMismatch');
        end

        function tformry(testcase)
            testcase.verifyEqual(tformry(0), eye(4,4),absTol=1e-10);
            testcase.verifyEqual(tformry(pi/2), [0 0 1 0; 0 1 0 0; -1 0 0 0; 0 0 0 1],absTol=1e-10);
            testcase.verifyEqual(tformry(pi), [-1 0 0 0; 0 1 0 0; 0 0 -1 0; 0 0 0 1],absTol=1e-10);

            testcase.verifyEqual(tformry(90, 'deg'), [0 0 1 0; 0 1 0 0; -1 0 0 0; 0 0 0 1],absTol=1e-10);
            testcase.verifyEqual(tformry(180, 'deg'), [-1 0 0 0; 0 1 0 0; 0 0 -1 0; 0 0 0 1],absTol=1e-10);
            %test for non-scalar input
            %     verifyError(testcase, @()tformry([1 2 3; 0 0 0 1]),'MATLAB:catenate:dimensionMismatch');
        end

        function tformrz(testcase)
            testcase.verifyEqual(tformrz(0), eye(4,4),absTol=1e-10);
            testcase.verifyEqual(tformrz(pi/2), [0 -1 0 0; 1 0 0 0; 0 0 1 0; 0 0 0 1],absTol=1e-10);
            testcase.verifyEqual(tformrz(pi), [-1 0 0 0; 0 -1 0 0; 0 0 1 0; 0 0 0 1],absTol=1e-10);

            testcase.verifyEqual(tformrz(90, 'deg'), [0 -1 0 0; 1 0 0 0; 0 0 1 0; 0 0 0 1],absTol=1e-10);
            testcase.verifyEqual(tformrz(180, 'deg'), [-1 0 0 0; 0 -1 0 0; 0 0 1 0; 0 0 0 1],absTol=1e-10);
            %test for non-scalar input
            %     verifyError(testcase, @()tformrz([1 2 3; 0 0 0 1]),'MATLAB:catenate:dimensionMismatch');
        end

        function printtform(testcase)
            a = trvec2tform([1,2,3]) * tformrx(0.3);

            printtform(a);

            s = evalc( 'printtform(a)' );
            testcase.verifyTrue(isa(s, 'char') );
            testcase.verifyEqual(size(s,1), 1);

            s = printtform(a);
            testcase.verifyClass(s, 'string');
            testcase.verifyEqual(size(s,1), 1);

            printtform(a, unit='rad');
            printtform(a, fmt='%g');
            printtform(a, label='bob');

            a = cat(3, a, a, a);
            printtform(a);

            s = evalc( 'printtform(a)' );
            testcase.verifyTrue(isa(s, 'char') );
            testcase.verifyEqual(size(s,1), 1);

            testcase.verifyEqual( length(regexp(s, '\n', 'match')), 3);

            printtform(a, unit='rad');
            printtform(a, fmt='%g');
            printtform(a, label='bob');
        end

        %    oa2r                       - orientation and approach vector to RM
        function oa2rotm(testcase)
            %Unit test for oa2r with variables ([0 1 0] & [0 0 1])
            testcase.verifyEqual(oa2rotm([0 1 0], [0 0 1]),...
                [1     0     0
                0     1     0
                0     0     1],absTol=1e-10);
            %test for scalar input
            verifyError(testcase, @()oa2rotm(1),'MATLAB:minrhs');
        end

        %    oa2tr                      - orientation and approach vector to HT
        function oa2tform(testcase)
            %Unit test for oa2tr with variables ([0 1 0] & [0 0 1])
            testcase.verifyEqual(oa2tform([0 1 0], [0 0 1]),...
                [1     0     0     0
                0     1     0     0
                0     0     1     0
                0     0     0     1],absTol=1e-10);
            %test for scalar input
            verifyError(testcase, @()oa2tform(1),'MATLAB:minrhs');
        end


        %    trnorm                     - normalize HT
        function tformnorm(testcase)

            R = [0.9 0 0; .2 .6 .3; .1 .2 .4]';
            testcase.verifyEqual(det(tformnorm(R)), 1, absTol=1e-14);

            t = [1 2 3];
            T = se3(R, t).tform;
            Tn = tformnorm(T);
            testcase.verifyEqual(det(tformnorm(t2r(Tn))), 1, absTol=1e-14);
            testcase.verifyEqual(Tn(1:3,4), t');


            %test for scalar input
            verifyError(testcase, @()tformnorm(1),'RVC3:tformnorm:badarg');
        end

        function tform2delta(testcase)

            testcase.verifyEqual(tform2delta(trvec2tform([0.1 0.2 0.3])), [0, 0, 0, 0.1, 0.2, 0.3, ], AbsTol=1e-10);

            testcase.verifyEqual(tform2delta(trvec2tform([0.1 0.2 0.3]), trvec2tform([0.2, 0.4, 0.6])), [0, 0, 0, 0.1, 0.2, 0.3, ], AbsTol=1e-10);

            testcase.verifyEqual(tform2delta(tformrx(0.001)), [0.001, 0, 0, 0, 0, 0], AbsTol=1e-8);
            testcase.verifyEqual(tform2delta(tformry(0.001)), [0, 0.001, 0, 0, 0, 0], AbsTol=1e-8);
            testcase.verifyEqual(tform2delta(tformrz(0.001)), [0, 0, 0.001, 0, 0, 0], AbsTol=1e-8);

        end

        function delta2tform(testcase)

            testcase.verifyEqual( ...
                delta2tform([0.4, 0.5, 0.6, 0.1, 0.2, 0.3]), ...
                [
                1.0, -0.6, 0.5, 0.1
                0.6, 1.0, -0.4, 0.2
                -0.5, 0.4, 1.0, 0.3
                0, 0, 0, 1.0
                ], AbsTol=1e-10)

            testcase.verifyEqual(delta2tform(zeros(1,6)), eye(4), AbsTol=1e-10)


        end

        function delta2se(testcase)

            testcase.verifyEqual( ...
                delta2se([0.4, 0.5, 0.6, 0.1, 0.2, 0.3]), ...
                se3([
                1.0, -0.6, 0.5, 0.1
                0.6, 1.0, -0.4, 0.2
                -0.5, 0.4, 1.0, 0.3
                0, 0, 0, 1.0
                ]), AbsTol=1e-10)

            testcase.verifyEqual(delta2se(zeros(1,6)), se3(), AbsTol=1e-10)


        end

        function skew2vec(testcase)
            S = [
                0    -3     2
                3     0    -1
                -2     1     0
                ];

            testcase.verifyEqual( skew2vec(S), [1 2 3]);

            testcase.verifyEqual( skew2vec(-S), -[1  2 3]);
        end


        function vec2skew(testcase)
            S = vec2skew([1 2 3]);

            testcase.verifyTrue( all(size(S) == [3 3]) );  % check size

            testcase.verifyEqual( norm(S'+ S), 0, absTol=1e-10); % check is skew

            testcase.verifyEqual( skew2vec(S), [1 2 3]); % check contents, vex already verified

            testcase.verifyError( @() skew2vec([1 2]), 'RVC3:skew2vec:badarg')
        end

        function skewa2vec(testcase)
            S = [
                0    -6     5     1
                6     0    -4     2
                -5     4     0     3
                0     0     0     0
                ];

            testcase.verifyEqual( skewa2vec(S), [4 5 6 1 2 3]);

            S = [
                0     6     5     1
                -6     0     4    -2
                -5    -4     0     3
                0     0     0     0
                ];
            testcase.verifyEqual( skewa2vec(S), [-4 5 -6 1 -2 3 ]);
        end

        function adjoint(testcase)
            R = eul2rotm( randn(1,3) );  t = randn(3,1);
            T = [R t; 0 0 0 1];

            testcase.verifyEqual(tform2adjoint(T), [R zeros(3,3); vec2skew(t)*R  R]);


        end

        function vec2skewa(testcase)
            S = vec2skewa([1 2 3 4 5 6]);

            testcase.verifyTrue( all(size(S) == [4 4]) );  % check size

            SS = S(1:3,1:3);
            testcase.verifyEqual( norm(SS'+ SS), 0, absTol=1e-10); % check is skew

            testcase.verifyEqual( skew2vec(SS), [1 2 3]); % check contents, skew2vec already verified
            testcase.verifyError( @() vec2skewa([1 2]), 'RVC3:vec2skewa:badarg')

        end


        function e2h(testcase)
            P1 = [1 2 3];
            P2 = [1 2 3 4 5; 6 7 8 9 10; 11 12 13 14 15]';

            testcase.verifyEqual( e2h(P1), [P1 1]);
            testcase.verifyEqual( e2h(P2), [P2 ones(5, 1)]);
        end

        function h2e(testcase)
            P1 = [1;2; 3];
            P2 = [1 2 3 4 5; 6 7 8 9 10; 11 12 13 14 15];

            testcase.verifyEqual( h2e(e2h(P1)), P1);
            testcase.verifyEqual( h2e(e2h(P2)), P2);
        end


        function homtrans(testcase)

            P1 = [1 2 3];
            P2 = [1 2 3 4 5; 6 7 8 9 10; 11 12 13 14 15]';

            T = eye(4,4);
            testcase.verifyEqual( homtrans(T, P1), P1);
            testcase.verifyEqual( homtrans(T, P2), P2);

            Q = [-2 2 4];
            T = trvec2tform(Q);
            testcase.verifyEqual( homtrans(T, P1), P1+Q);
            testcase.verifyEqual( homtrans(T, P2), P2+Q);

            T = tformrx(pi/2);
            testcase.verifyEqual( homtrans(T, P1), [P1(1) -P1(3) P1(2)], absTol=1e-6);
            testcase.verifyEqual( homtrans(T, P2), [P2(:,1) -P2(:,3) P2(:,2)], absTol=1e-6);

            T =  trvec2tform(Q)*tformrx(pi/2);
            testcase.verifyEqual( homtrans(T, P1), [P1(1) -P1(3) P1(2)]+Q, absTol=1e-6);
            testcase.verifyEqual( homtrans(T, P2), [P2(:,1) -P2(:,3) P2(:,2)]+Q, absTol=1e-6);

            % projective point case
            P1h = e2h(P1);
            P2h = e2h(P2);
            testcase.verifyEqual( homtrans(T, P1h), [P1h(1) -P1h(3) P1h(2) 1]+[Q 0], absTol=1e-6);
            testcase.verifyEqual( homtrans(T, P2h), [P2h(:,1) -P2h(:,3) P2h(:,2) ones(5,1)]+[Q 0], absTol=1e-6);

            % error case
            testcase.verifyError( @() homtrans(ones(2,2), P1), 'RVC3:homtrans:badarg')

        end
    end % methods
end