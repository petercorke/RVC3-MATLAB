%% This is for testing the Homogeneous Transformation functions in the robotics Toolbox

function tests = TransformationsTest
    tests = functiontests(localfunctions);
    
    clc
end

function teardownOnce(tc)
    close all
end

%% first of all check we can tell a good matrix from a bad one
function isrotm2d_test(tc)
    R1 = diag([1 1]);    % proper
    R2 = diag([1 2]);    % not proper
    R3 = diag([2 0.5]);  % not proper
    R4 = diag([1 -1]);  % not proper
    
    % test shapes
    tc.verifyFalse( isrotm2d(1) )
    tc.verifyFalse( isrotm2d( zeros(3,3) ) )
    tc.verifyFalse( isrotm2d( zeros(4,4) ) )
    tc.verifyFalse( isrotm2d( zeros(2,1) ) )
    tc.verifyFalse( isrotm2d( zeros(1,2) ) )
    
    % test shapes with validity check
    tc.verifyFalse( isrotm2d(1, check=true) )
    tc.verifyFalse( isrotm2d( zeros(2,2), check=true ) )
    tc.verifyFalse( isrotm2d( zeros(4,4), check=true ) )
    tc.verifyFalse( isrotm2d( zeros(4,1), check=true ) )
    tc.verifyFalse( isrotm2d( zeros(1,4), check=true ) )
    
    % test 3x3
    tc.verifyTrue( isrotm2d(R1) )
    tc.verifyTrue( isrotm2d(R2) )
    tc.verifyTrue( isrotm2d(R3) )
    tc.verifyTrue( isrotm2d(R4) )
    
    % test 3x3 with validity check
    tc.verifyTrue( isrotm2d(R1, check=true) )
    tc.verifyFalse( isrotm2d(R2, check=true) )
    tc.verifyFalse( isrotm2d(R3, check=true) )
    tc.verifyFalse( isrotm2d(R4, check=true) )
    
    % vector case
    tc.verifyTrue( isrotm2d(cat(3, R1, R1, R1)) )
    tc.verifyTrue( isrotm2d(cat(3, R1, R1, R1), check=true) )
    tc.verifyTrue( isrotm2d(cat(3, R1, R2, R3)) )
    tc.verifyFalse( isrotm2d(cat(3, R1, R2, R3), check=true) )
end

function istform2d_test(tc)
    T1 = diag([1 1 1]);    % proper
    T2 = diag([1 -1 1]);   % not proper
    T3 = diag([1 2 1]);    % not proper
    T4 = diag([2 0.5 1]);  % not proper
    T5 = diag([1 1 0]);    % not proper
    
    
    % test shapes
    tc.verifyFalse( istform2d(1) )
    tc.verifyFalse( istform2d( zeros(2,2) ) )
    tc.verifyFalse( istform2d( zeros(4,4) ) )
    tc.verifyFalse( istform2d( zeros(3,1) ) )
    tc.verifyFalse( istform2d( zeros(1,3) ) )
    
    % test shapes with validity check
    tc.verifyFalse( istform2d(1, check=true) )
    tc.verifyFalse( istform2d( zeros(2,2), check=true ) )
    tc.verifyFalse( istform2d( zeros(4,4), check=true ) )
    tc.verifyFalse( istform2d( zeros(4,1), check=true ) )
    tc.verifyFalse( istform2d( zeros(1,4), check=true ) )
    
    % test 4x4
    tc.verifyTrue( istform2d(T1) )
    tc.verifyTrue( istform2d(T2) )
    tc.verifyTrue( istform2d(T3) )
    tc.verifyTrue( istform2d(T4) )
    tc.verifyTrue( istform2d(T5) )
    
    
    % test 4x4 with validity check
    tc.verifyTrue( istform2d(T1, check=true) )
    tc.verifyFalse( istform2d(T2, check=true) )
    tc.verifyFalse( istform2d(T3, check=true) )
    tc.verifyFalse( istform2d(T4, check=true) )
    tc.verifyFalse( istform2d(T5, check=true) )
    
    
    % vector case
    tc.verifyTrue( istform2d(cat(3, T1, T1, T1)) )
    tc.verifyTrue( istform2d(cat(3, T1, T1, T1), check=true) )
    tc.verifyTrue( istform2d(cat(3, T1, T2, T3)) )
    tc.verifyFalse( istform2d(cat(3, T1, T2, T3), check=true) )
end

%% SO(2)
function rotm2d_test(tc)
    tc.verifyEqual( rotm2d(0), eye(2,2), absTol=1e-6);
    tc.verifyEqual( rotm2d(0), eye(2,2), absTol=1e-6);

    tc.verifyEqual( rotm2d(pi)*rotm2d(-pi/2), ...
        rotm2d(pi/2), absTol=1e-6);
end

function tformr2d_test(tc)
    tc.verifyEqual( tformr2d(0), eye(3,3), absTol=1e-6);

    tc.verifyEqual( tformr2d(pi/2), [0 -1 0; 1 0 0; 0 0 1], absTol=1e-6);
    
    tc.verifyEqual( tformr2d(90, 'deg'),[0 -1 0; 1 0 0; 0 0 1], absTol=1e-6);
    tc.verifyEqual( tformr2d(pi)*tformr2d(-pi/2), ...
        tformr2d(pi/2), absTol=1e-6);

end

function printtform2d_test(tc)
    a = trvec2tform([1,2]) * tformr2d(0.3);
    
    printtform2d(a);
    
    s = evalc( 'printtform2d(a)' );
    tc.verifyTrue(isa(s, 'char') );
    tc.verifyEqual(size(s,1), 1);
    
    s = printtform2d(a);
    tc.verifyClass(s, 'string');
    tc.verifyEqual(size(s,1), 1);
    
    printtform2d(a, unit='rad');
    printtform2d(a, fmt='%g');
    printtform2d(a, label='bob');
    
    a = cat(3, a, a, a);
    printtform2d(a);
    
    s = evalc( 'printtform2d(a)' );
    tc.verifyTrue(isa(s, 'char') );
    tc.verifyEqual(size(s,1), 1);
    
    tc.verifyEqual( length(regexp(s, '\n', 'match')), 3);
    
    printtform2d(a, unit='rad');
    printtform2d(a, fmt='%g');
    printtform2d(a, label='bob');
end

function skew2vec_test(tc)
    S = [0 -2; 2 0];
    tc.verifyEqual( skew2vec(S), 2);
    
    S = [0 2; -2 0];
    tc.verifyEqual( skew2vec(S), -2);
end


function vec2skew_test(tc)
    S = vec2skew(3);
    
    tc.verifyTrue( all(size(S) == [2 2]) );  % check size
    
    tc.verifyEqual( norm(S'+ S), 0, absTol=1e-10); % check is skew
    
    tc.verifyEqual( skew2vec(S), 3); % check contents, vex already verified

    tc.verifyError( @() vec2skew([1 2]), "RVC3:vec2skew:badarg")

end

function skewa2vec_test(tc)
    S = [0 -2 3 ; 2 0 4; 0 0 0];
    tc.verifyEqual( skewa2vec(S), [2 3 4]);
    
    S = [0 2 3 ; -2 0 4; 0 0 0];
    tc.verifyEqual( skewa2vec(S), [-2 3 4]);
end


function vec2skewa_test(tc)
    S = vec2skewa([3 4 5]);
    
    tc.verifyTrue( istform2d(S) );  % check size
    
    SS = S(1:2,1:2);
    tc.verifyEqual( norm(SS'+ SS), 0, absTol=1e-10); % check is skew
    
    tc.verifyEqual( skew2vec(SS), [3]); % check contents, vexa already verified

    tc.verifyError( @() vec2skewa([1 2]), 'RVC3:vec2skewa:badarg')

end


function e2h_test(tc)
    P1 = [1 2];
    P2 = [1 2 3 4 5; 6 7 8 9 10]';

    tc.verifyEqual( e2h(P1), [P1 1]);
    tc.verifyEqual( e2h(P2), [P2 ones(5,1)]);
end

function h2e_test(tc)
    P1 = [1 2];
    P2 = [1 2 3 4 5; 6 7 8 9 10]';

    tc.verifyEqual( h2e(e2h(P1)), P1);
    tc.verifyEqual( h2e(e2h(P2)), P2);
end

function homtrans_test(tc)
    
    P1 = [1 2];
    P2 = [1 2 3 4 5; 6 7 8 9 10]';
    
    T = eye(3,3);
    tc.verifyEqual( homtrans(T, P1), P1);
    tc.verifyEqual( homtrans(T, P2), P2);
    
    Q = [-2 2];
    T = trvec2tform(Q);
    tc.verifyEqual( homtrans(T, P1), P1+Q);
    tc.verifyEqual( homtrans(T, P2), P2+Q);
    
    T = tformr2d(pi/2);
    tc.verifyEqual( homtrans(T, P1), [-P1(2) P1(1)], absTol=1e-6);
    tc.verifyEqual( homtrans(T, P2), [-P2(:,2) P2(:,1)], absTol=1e-6);
    
    T =  trvec2tform(Q)*tformr2d(pi/2);
    tc.verifyEqual( homtrans(T, P1), [-P1(2) P1(1)]+Q, absTol=1e-6);
    tc.verifyEqual( homtrans(T, P2), [-P2(:,2,:) P2(:,1)]+Q, absTol=1e-6);

    % projective point case
    P1h = e2h(P1);
    P2h = e2h(P2);
    tc.verifyEqual( homtrans(T, P1h), [-P1(2) P1(1) 1]+[Q 0], absTol=1e-6);
    tc.verifyEqual( homtrans(T, P2h), [-P2(:,2) P2(:,1) ones(5,1)]+[Q 0], absTol=1e-6);


    % error case
    tc.verifyError( @() homtrans(7, P1), 'RVC3:homtrans:badarg')
    
end

