%% This is for testing the Homogeneous Transformation functions in the robotics Toolbox

function tests = TransformationsTest
    tests = functiontests(localfunctions);
    
    clc
end

function teardownOnce(tc)
    close all
end

%% first of all check we can tell a good matrix from a bad one
function isrotm_test(tc)
    R1 = diag([1 1 1]);    % proper
    R2 = diag([1 1 -1]);   % not proper
    R3 = diag([1 2 1]);    % not proper
    R4 = diag([2 0.5 1]);  % not proper
    
    % test shapes
    tc.verifyFalse( isrotm(1) )
    tc.verifyFalse( isrotm( zeros(2,2) ) )
    tc.verifyFalse( isrotm( zeros(4,4) ) )
    tc.verifyFalse( isrotm( zeros(3,1) ) )
    tc.verifyFalse( isrotm( zeros(1,3) ) )
    
    % test shapes with validity check
    tc.verifyFalse( isrotm(1, check=true) )
    tc.verifyFalse( isrotm( zeros(2,2), check=true ) )
    tc.verifyFalse( isrotm( zeros(4,4), check=true ) )
    tc.verifyFalse( isrotm( zeros(4,1), check=true ) )
    tc.verifyFalse( isrotm( zeros(1,4), check=true ) )
    
    % test 3x3
    tc.verifyTrue( isrotm(R1) )
    tc.verifyTrue( isrotm(R2) )
    tc.verifyTrue( isrotm(R3) )
    tc.verifyTrue( isrotm(R4) )
    
    % test 3x3 with validity check
    tc.verifyTrue( isrotm(R1, check=true) )
    tc.verifyFalse( isrotm(R2, check=true) )
    tc.verifyFalse( isrotm(R3, check=true) )
    tc.verifyFalse( isrotm(R4, check=true) )
    
    % vector case
    tc.verifyTrue( isrotm(cat(3, R1, R1, R1)) )
    tc.verifyTrue( isrotm(cat(3, R1, R1, R1), check=true) )
    tc.verifyTrue( isrotm(cat(3, R1, R2, R3)) )
    tc.verifyFalse( isrotm(cat(3, R1, R2, R3), check=true) )
end

function istform_test(tc)
    T1 = diag([1 1 1 1]);    % proper
    T2 = diag([1 1 -1 1]);   % not proper
    T3 = diag([1 2 1 1]);    % not proper
    T4 = diag([2 0.5 1 1]);  % not proper
    T5 = diag([1 1 1 0]);    % not proper
    
    
    % test shapes
    tc.verifyFalse( istform(1) )
    tc.verifyFalse( istform( zeros(2,2) ) )
    tc.verifyFalse( istform( zeros(3,3) ) )
    tc.verifyFalse( istform( zeros(4,1) ) )
    tc.verifyFalse( istform( zeros(1,4) ) )
    
    % test shapes with validity check
    tc.verifyFalse( istform(1, check=true) )
    tc.verifyFalse( istform( zeros(2,2), check=true ) )
    tc.verifyFalse( istform( zeros(3,3), check=true ) )
    tc.verifyFalse( istform( zeros(4,1), check=true ) )
    tc.verifyFalse( istform( zeros(1,4), check=true ) )
    
    % test 4x4
    tc.verifyTrue( istform(T1) )
    tc.verifyTrue( istform(T2) )
    tc.verifyTrue( istform(T3) )
    tc.verifyTrue( istform(T4) )
    tc.verifyTrue( istform(T5) )
    
    
    % test 4x4 with validity check
    tc.verifyTrue( istform(T1, check=true) )
    tc.verifyFalse( istform(T2, check=true) )
    tc.verifyFalse( istform(T3, check=true) )
    tc.verifyFalse( istform(T4, check=true) )
    tc.verifyFalse( istform(T5, check=true) )
    
    
    % vector case
    tc.verifyTrue( istform(cat(3, T1, T1, T1)) )
    tc.verifyTrue( istform(cat(3, T1, T1, T1), check=true) )
    tc.verifyTrue( istform(cat(3, T1, T2, T3)) )
    tc.verifyFalse( istform(cat(3, T1, T2, T3), check=true) )
end

% Primitives
function rotmx_test(tc)
    tc.verifyEqual(rotmx(0), eye(3,3),absTol=1e-10);
    tc.verifyEqual(rotmx(pi/2), [1 0 0; 0 0 -1; 0 1 0],absTol=1e-10);
    tc.verifyEqual(rotmx(pi), [1 0 0; 0 -1 0; 0 0 -1],absTol=1e-10);
    
    tc.verifyEqual(rotmx(90, 'deg'), [1 0 0; 0 0 -1; 0 1 0],absTol=1e-10);
    tc.verifyEqual(rotmx(180, 'deg'), [1 0 0; 0 -1 0; 0 0 -1],absTol=1e-10);
    
    syms q
    R = rotmx(q);
    verifyInstanceOf(tc, R, 'sym');
    verifySize(tc, R, [3 3]);
    tc.verifyEqual(simplify(det(R)), sym(1));
    
    %test for non-scalar input
%     verifyError(tc, @()rotmx([1 2 3]),'SMTB:rotx:badarg');
end

function rotmy_test(tc)
    tc.verifyEqual(rotmy(0), eye(3,3),absTol=1e-10);
    tc.verifyEqual(rotmy(pi/2), [0 0 1; 0 1 0; -1 0 0],absTol=1e-10);
    tc.verifyEqual(rotmy(pi), [-1 0 0; 0 1 0; 0 0 -1],absTol=1e-10);
    
    tc.verifyEqual(rotmy(90, 'deg'), [0 0 1; 0 1 0; -1 0 0],absTol=1e-10);
    tc.verifyEqual(rotmy(180, 'deg'), [-1 0 0; 0 1 0; 0 0 -1],absTol=1e-10);
    
    syms q
    R = rotmy(q);
    verifyInstanceOf(tc, R, 'sym');
    verifySize(tc, R, [3 3]);
    tc.verifyEqual(simplify(det(R)), sym(1));
    
    %test for non-scalar input
%     verifyError(tc, @()rotmy([1 2 3]),'SMTB:roty:badarg');
end

function rotmz_test(tc)
    tc.verifyEqual(rotmz(0), eye(3,3),absTol=1e-10);
    tc.verifyEqual(rotmz(pi/2), [0 -1 0; 1 0 0; 0 0 1],absTol=1e-10);
    tc.verifyEqual(rotmz(pi), [-1 0 0; 0 -1 0; 0 0 1],absTol=1e-10);
    
    tc.verifyEqual(rotmz(90, 'deg'), [0 -1 0; 1 0 0; 0 0 1],absTol=1e-10);
    tc.verifyEqual(rotmz(180, 'deg'), [-1 0 0; 0 -1 0; 0 0 1],absTol=1e-10);
    
    syms q
    R = rotmz(q);
    verifyInstanceOf(tc, R, 'sym');
    verifySize(tc,R, [3 3]);
    tc.verifyEqual(simplify(det(R)), sym(1));
    
    %test for non-scalar input
%     verifyError(tc, @()rotmz([1 2 3]),'SMTB:rotz:badarg');
end

function tformrx_test(tc)
    tc.verifyEqual(tformrx(0), eye(4,4),absTol=1e-10);
    tc.verifyEqual(tformrx(pi/2), [1 0 0 0; 0 0 -1 0; 0 1 0 0; 0 0 0 1],absTol=1e-10);
    tc.verifyEqual(tformrx(pi), [1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 1],absTol=1e-10);
    
    tc.verifyEqual(tformrx(90, 'deg'), [1 0 0 0; 0 0 -1 0; 0 1 0 0; 0 0 0 1],absTol=1e-10);
    tc.verifyEqual(tformrx(180, 'deg'), [1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 1],absTol=1e-10);
    
    %test for non-scalar input
%     verifyError(tc, @()tformrx([1 2 3; 0 0 0 1]),'MATLAB:catenate:dimensionMismatch');
end

function tformry_test(tc)
    tc.verifyEqual(tformry(0), eye(4,4),absTol=1e-10);
    tc.verifyEqual(tformry(pi/2), [0 0 1 0; 0 1 0 0; -1 0 0 0; 0 0 0 1],absTol=1e-10);
    tc.verifyEqual(tformry(pi), [-1 0 0 0; 0 1 0 0; 0 0 -1 0; 0 0 0 1],absTol=1e-10);
    
    tc.verifyEqual(tformry(90, 'deg'), [0 0 1 0; 0 1 0 0; -1 0 0 0; 0 0 0 1],absTol=1e-10);
    tc.verifyEqual(tformry(180, 'deg'), [-1 0 0 0; 0 1 0 0; 0 0 -1 0; 0 0 0 1],absTol=1e-10);
    %test for non-scalar input
%     verifyError(tc, @()tformry([1 2 3; 0 0 0 1]),'MATLAB:catenate:dimensionMismatch');
end

function tformrz_test(tc)
    tc.verifyEqual(tformrz(0), eye(4,4),absTol=1e-10);
    tc.verifyEqual(tformrz(pi/2), [0 -1 0 0; 1 0 0 0; 0 0 1 0; 0 0 0 1],absTol=1e-10);
    tc.verifyEqual(tformrz(pi), [-1 0 0 0; 0 -1 0 0; 0 0 1 0; 0 0 0 1],absTol=1e-10);
    
    tc.verifyEqual(tformrz(90, 'deg'), [0 -1 0 0; 1 0 0 0; 0 0 1 0; 0 0 0 1],absTol=1e-10);
    tc.verifyEqual(tformrz(180, 'deg'), [-1 0 0 0; 0 -1 0 0; 0 0 1 0; 0 0 0 1],absTol=1e-10);
    %test for non-scalar input
%     verifyError(tc, @()tformrz([1 2 3; 0 0 0 1]),'MATLAB:catenate:dimensionMismatch');
end

function printtform_test(tc)
    a = trvec2tform([1,2,3]) * tformrx(0.3);
    
    printtform(a);
    
    s = evalc( 'printtform(a)' );
    tc.verifyTrue(isa(s, 'char') );
    tc.verifyEqual(size(s,1), 1);
    
    s = printtform(a);
    tc.verifyClass(s, 'string');
    tc.verifyEqual(size(s,1), 1);
    
    printtform(a, unit='rad');
    printtform(a, fmt='%g');
    printtform(a, label='bob');
    
    a = cat(3, a, a, a);
    printtform(a);
    
    s = evalc( 'printtform(a)' );
    tc.verifyTrue(isa(s, 'char') );
    tc.verifyEqual(size(s,1), 1);
    
    tc.verifyEqual( length(regexp(s, '\n', 'match')), 3);
    
    printtform(a, unit='rad');
    printtform(a, fmt='%g');
    printtform(a, label='bob');
end

%    oa2r                       - orientation and approach vector to RM
function oa2rotm_test(tc)
    %Unit test for oa2r with variables ([0 1 0] & [0 0 1])
    tc.verifyEqual(oa2rotm([0 1 0], [0 0 1]),...
        [1     0     0
         0     1     0
         0     0     1],absTol=1e-10);
    %test for scalar input
    verifyError(tc, @()oa2rotm(1),'MATLAB:minrhs');
end

%    oa2tr                      - orientation and approach vector to HT
function oa2tform_test(tc)
    %Unit test for oa2tr with variables ([0 1 0] & [0 0 1])
    tc.verifyEqual(oa2tform([0 1 0], [0 0 1]),...
        [1     0     0     0
         0     1     0     0
         0     0     1     0
         0     0     0     1],absTol=1e-10);
    %test for scalar input
    verifyError(tc, @()oa2tform(1),'MATLAB:minrhs');
end


%    trnorm                     - normalize HT
function tformnorm_test(tc)
    
    R = [0.9 0 0; .2 .6 .3; .1 .2 .4]';
    tc.verifyEqual(det(tformnorm(R)), 1, absTol=1e-14);
    
    t = [1 2 3];
    T = se3(R, t).tform
    Tn = tformnorm(T);
    tc.verifyEqual(det(tformnorm(t2r(Tn))), 1, absTol=1e-14);
    tc.verifyEqual(Tn(1:3,4), t');
   
    
    %test for scalar input
    verifyError(tc, @()tformnorm(1),'RVC3:tformnorm:badarg');
end

function tform2delta_test(tc)

    tc.verifyEqual(tform2delta(trvec2tform([0.1 0.2 0.3])), [0, 0, 0, 0.1, 0.2, 0.3, ], AbsTol=1e-10);
    
    tc.verifyEqual(tform2delta(trvec2tform([0.1 0.2 0.3]), trvec2tform([0.2, 0.4, 0.6])), [0, 0, 0, 0.1, 0.2, 0.3, ], AbsTol=1e-10);
    
    tc.verifyEqual(tform2delta(tformrx(0.001)), [0.001, 0, 0, 0, 0, 0], AbsTol=1e-8);
    tc.verifyEqual(tform2delta(tformry(0.001)), [0, 0.001, 0, 0, 0, 0], AbsTol=1e-8);
    tc.verifyEqual(tform2delta(tformrz(0.001)), [0, 0, 0.001, 0, 0, 0], AbsTol=1e-8);
    
end

function delta2tform_test(tc)

tc.verifyEqual( ...
    delta2tform([0.4, 0.5, 0.6, 0.1, 0.2, 0.3]), ...
    [
    1.0, -0.6, 0.5, 0.1
    0.6, 1.0, -0.4, 0.2
    -0.5, 0.4, 1.0, 0.3
    0, 0, 0, 1.0
    ], AbsTol=1e-10)

tc.verifyEqual(delta2tform(zeros(1,6)), eye(4), AbsTol=1e-10)


end

function delta2se_test(tc)

tc.verifyEqual( ...
    delta2se([0.4, 0.5, 0.6, 0.1, 0.2, 0.3]), ...
    se3([
    1.0, -0.6, 0.5, 0.1
    0.6, 1.0, -0.4, 0.2
    -0.5, 0.4, 1.0, 0.3
    0, 0, 0, 1.0
    ]), AbsTol=1e-10)

tc.verifyEqual(delta2se(zeros(1,6)), se3(), AbsTol=1e-10)


end

function skew2vec_test(tc)
    S = [
         0    -3     2
         3     0    -1
        -2     1     0
        ];
    
    tc.verifyEqual( skew2vec(S), [1 2 3]);
    
    tc.verifyEqual( skew2vec(-S), -[1  2 3]);
end


function vec2skew_test(tc)
    S = vec2skew([1 2 3]);
    
    tc.verifyTrue( all(size(S) == [3 3]) );  % check size
    
    tc.verifyEqual( norm(S'+ S), 0, absTol=1e-10); % check is skew
    
    tc.verifyEqual( skew2vec(S), [1 2 3]); % check contents, vex already verified

    tc.verifyError( @() skew2vec([1 2]), 'RVC3:skew2vec:badarg')
end

function skewa2vec_test(tc)
    S = [
         0    -6     5     1
         6     0    -4     2
        -5     4     0     3
         0     0     0     0
        ];
    
    tc.verifyEqual( skewa2vec(S), [4 5 6 1 2 3]);
    
    S = [
         0     6     5     1
        -6     0     4    -2
        -5    -4     0     3
         0     0     0     0
        ];
    tc.verifyEqual( skewa2vec(S), [-4 5 -6 1 -2 3 ]);
end

function adjoint_test(tc)
    R = eul2rotm( randn(1,3) );  t = randn(3,1); 
    T = [R t; 0 0 0 1];
    
    tc.verifyEqual(tform2adjoint(T), [R zeros(3,3); vec2skew(t)*R  R]);
    
    
end

function vec2skewa_test(tc)
    S = vec2skewa([1 2 3 4 5 6]);
    
    tc.verifyTrue( all(size(S) == [4 4]) );  % check size
    
    SS = S(1:3,1:3);
    tc.verifyEqual( norm(SS'+ SS), 0, absTol=1e-10); % check is skew
    
    tc.verifyEqual( skew2vec(SS), [1 2 3]); % check contents, skew2vec already verified
    tc.verifyError( @() vec2skewa([1 2]), 'RVC3:vec2skewa:badarg')

end


function e2h_test(tc)
    P1 = [1 2 3];
    P2 = [1 2 3 4 5; 6 7 8 9 10; 11 12 13 14 15]';

    tc.verifyEqual( e2h(P1), [P1 1]);
    tc.verifyEqual( e2h(P2), [P2 ones(5, 1)]);
end

function h2e_test(tc)
    P1 = [1;2; 3];
    P2 = [1 2 3 4 5; 6 7 8 9 10; 11 12 13 14 15];

    tc.verifyEqual( h2e(e2h(P1)), P1);
    tc.verifyEqual( h2e(e2h(P2)), P2);
end


function homtrans_test(tc)
    
    P1 = [1 2 3];
    P2 = [1 2 3 4 5; 6 7 8 9 10; 11 12 13 14 15]';
    
    T = eye(4,4);
    tc.verifyEqual( homtrans(T, P1), P1);
    tc.verifyEqual( homtrans(T, P2), P2);
    
    Q = [-2 2 4];
    T = trvec2tform(Q);
    tc.verifyEqual( homtrans(T, P1), P1+Q);
    tc.verifyEqual( homtrans(T, P2), P2+Q);
    
    T = tformrx(pi/2);
    tc.verifyEqual( homtrans(T, P1), [P1(1) -P1(3) P1(2)], absTol=1e-6);
    tc.verifyEqual( homtrans(T, P2), [P2(:,1) -P2(:,3) P2(:,2)], absTol=1e-6);
    
    T =  trvec2tform(Q)*tformrx(pi/2);
    tc.verifyEqual( homtrans(T, P1), [P1(1) -P1(3) P1(2)]+Q, absTol=1e-6);
    tc.verifyEqual( homtrans(T, P2), [P2(:,1) -P2(:,3) P2(:,2)]+Q, absTol=1e-6);

    % projective point case
    P1h = e2h(P1);
    P2h = e2h(P2);
    tc.verifyEqual( homtrans(T, P1h), [P1h(1) -P1h(3) P1h(2) 1]+[Q 0], absTol=1e-6);
    tc.verifyEqual( homtrans(T, P2h), [P2h(:,1) -P2h(:,3) P2h(:,2) ones(5,1)]+[Q 0], absTol=1e-6);

    % error case
    tc.verifyError( @() homtrans(ones(2,2), P1), 'RVC3:homtrans:badarg')

end

