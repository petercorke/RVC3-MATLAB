classdef tDifferentialMotion < RVCTest & matlab.unittest.TestCase
    %tDifferentialMotion Unit tests for differential motion functions
    
    methods (Test)
        %%    skew                       - vector to skew symmetric matrix
        function vec2skew(testCase)
            
            %% 2D case
            verifyEqual(testCase, vec2skew(2),...
                [0 -2; 2 0],'absTol',1e-4);
            
            %% 3D case
            
            % test row and column vectors
            verifyEqual(testCase, vec2skew([1, 2, 3]'),...
                [     0    -3     2
                3     0    -1
                -2     1     0],'absTol',1e-4);
            verifyEqual(testCase, vec2skew([1, 2, 3]),...
                [     0    -3     2
                3     0    -1
                -2     1     0],'absTol',1e-4);
            
        end
        
        
        %%    vex                        - skew symmetric matrix to vector
        function skew2vec(testCase)
            %% 2D case
            verifyEqual(testCase, skew2vec([0 -2; 2 0]), 2, 'absTol',1e-4);
            
            %% 3D case
            verifyEqual(testCase, skew2vec([0, -3, 2; 3, 0, -1; -2, 1, 0]),...
                [1 2 3],'absTol',1e-4);
            % unit testing vex with 3x3 skew matrix
            verifyEqual(testCase, skew2vec([0 0 0;0 0 0;0 0 0]),...
                [0 0 0],'absTol',1e-4);
            
            verifyError(testCase, @()skew2vec(1),'SMTB:vex:badarg');
            verifyError(testCase, @()skew2vec(zeros(4,4)),'SMTB:vex:badarg');
            
            % ---------------------------------------------------------------------
            %    wtrans                     - transform wrench between frames
            % does not exist!!! need to find this function
            %----------------------------------------------------------------------
        end
        
        %%    skewa                       - augmented vector to skew symmetric matrix
        function vec2skewa(testCase)
            
            %% 2D case
            verifyEqual(testCase, vec2skewa([1 2 3]),...
                [0 -3 1; 3 0 2; 0 0 0],'absTol',1e-4);
            
            %% 3D case
            
            % test row and column vectors
            verifyEqual(testCase, vec2skewa([1, 2, 3, 4, 5, 6]'),...
                [0 -6 5 1; 6 0 -4 2; -5 4 0 3; 0 0 0 0],'absTol',1e-4);
            verifyEqual(testCase, vec2skewa([1, 2, 3, 4, 5, 6]),...
                [0 -6 5 1; 6 0 -4 2; -5 4 0 3; 0 0 0 0],'absTol',1e-4);
            
            verifyError(testCase, @()vec2skewa(1),'SMTB:vec2skewa:badarg');
            
        end
        
        
        %%    vexa                        - augmented skew symmetric matrix to vector
        function skewa2vec(testCase)
            %% 2D case
            verifyEqual(testCase, skewa2vec([0 -3 1; 3 0 2; 0 0 0]), [1 2 3], 'absTol',1e-4);
            
            %% 3D case
            verifyEqual(testCase, skewa2vec([0 -6 5 1; 6 0 -4 2; -5 4 0 3; 0 0 0 0]),...
                [1 2 3 4 5 6],'absTol',1e-4);
            
            verifyError(testCase, @()skewa2vec(1),'SMTB:vexa:badarg');
            
        end
        
        
        %% Differential motion
        %    delta2tform                   - differential motion vector to HT
        function delta2tform(testCase)
            %test with standard numbers
            verifyEqual(testCase, delta2tform([0.1 0.2 0.3 0.4 0.5 0.6]),...
                [1.0000   -0.6000    0.5000    0.1000
                0.6000    1.0000   -0.4000    0.2000
                -0.5000    0.4000    1.0000    0.3000
                0         0         0    1.0000],'absTol',1e-4);
            %test with zeros
            verifyEqual(testCase, delta2tform([0 0 0 0 0 0]), eye(4,4),'absTol',1e-4);
            %test with scaler input
            verifyError(testCase, @()delta2tform(1),'MATLAB:badsubscript');
        end
        
        
        %    eul2jac                    - Euler angles to Jacobian
        function eul2jac(testCase)
           
            testCase.assumeTrue(logical(exist("eul2jac", "file")), ...
                "Only run test if function eul2jac exists.");
            
            % check it works for simple cases
            verifyEqual(testCase, eul2jac(0, 0, 0), [0 0 0; 0 1 0; 1 0 1]);
            verifyEqual(testCase, eul2jac( [0, 0, 0]), [0 0 0; 0 1 0; 1 0 1]);
            
            eul = [0.2 0.3 0.4];
            
            
            % check complex case
            verifyEqual(testCase, eul2jac( eul(1), eul(2), eul(3)), eul2jac(eul));
            
            
            %Testing with a scalar number input
            verifyError(testCase, @()eul2jac(1),'SMTB:eul2jac:badarg');
            
            % test Jacobian against numerical approximation
            dth = 1e-6;
            
            
            R0 = eul2r(eul);
            R1 = eul2r(eul + dth*[1 0 0]);
            R2 = eul2r(eul + dth*[0 1 0]);
            R3 = eul2r(eul + dth*[0 0 1]);
            
            JJ = [ skew2vec((R1-R0)*R0')  skew2vec((R2-R0)*R0')  skew2vec((R3-R0)*R0')] / dth;
            verifyEqual(testCase, JJ, eul2jac(eul), 'absTol',1e-4)                       
        end
        
        %    rpy2jac                    - RPY angles to Jacobian
        function rpy2jac(testCase)
            
            testCase.assumeTrue(logical(exist("rpy2jac", "file")), ...
                "Only run test if function rpy2jac exists.");
            
            % check it works for simple cases
            verifyEqual(testCase, rpy2jac(0, 0, 0), eye(3,3));
            verifyEqual(testCase, rpy2jac( [0, 0, 0]), eye(3,3));
            
            % check switestCasehes work
            verifyEqual(testCase, rpy2jac( [0, 0, 0], 'xyz'), [0 0 1; 0 1 0; 1 0 0]);
            verifyEqual(testCase, rpy2jac( [0, 0, 0], 'zyx'), eye(3,3));
            verifyEqual(testCase, rpy2jac( [0, 0, 0], 'yxz'), [0 1 0; 0 0 1; 1 0 0]);
            
            rpy = [0.2 0.3 0.4];
            
            % check default
            verifyEqual(testCase, rpy2jac(rpy), rpy2jac(rpy, 'zyx') );
            
            
            
            % check complex case
            verifyEqual(testCase, rpy2jac( rpy(1), rpy(2), rpy(3)), rpy2jac(rpy));
            
            
            %Testing with a scalar number input
            verifyError(testCase, @()rpy2jac(1),'SMTB:rpy2jac:badarg');
            
            % test Jacobian against numerical approximation for 3 different orders
            dth = 1e-6;
            
            for oo = {'xyz', 'zyx', 'yxz'}
                order = oo{1};
                R0 = rpy2r(rpy, order);
                R1 = rpy2r(rpy + dth*[1 0 0], order);
                R2 = rpy2r(rpy + dth*[0 1 0], order);
                R3 = rpy2r(rpy + dth*[0 0 1], order);
                
                JJ = [ skew2vec((R1-R0)*R0')  skew2vec((R2-R0)*R0')  skew2vec((R3-R0)*R0')] / dth;
                verifyEqual(testCase, JJ, rpy2jac(rpy, order), 'absTol',1e-4)
            end
            
        end
        
        
        
        %    tform2delta                   - HT to differential motion vector
        function tform2delta(testCase)
            
            testCase.assumeTrue(logical(exist("tformrx", "file")), ...
                "Only run test if function tformrx exists."); 
            
            % unit testing tform2delta with a tr matrix
            verifyEqual(testCase, tform2delta( trvec2tform(0.1, 0.2, 0.3) ),...
                [0.1000, 0.2000, 0.3000, 0, 0, 0],'absTol',1e-4);
            verifyEqual(testCase, tform2delta( trvec2tform(0.1, 0.2, 0.3), trvec2tform(0.2, 0.4, 0.6) ), ...
                [0.1000, 0.2000, 0.3000, 0, 0, 0],'absTol',1e-4);
            verifyEqual(testCase, tform2delta( tformrx(0.001) ), ...
                [0,0,0, 0.001,0,0],'absTol',1e-4);
            verifyEqual(testCase, tform2delta( tformry(0.001) ), ...
                [0,0,0, 0,0.001,0],'absTol',1e-4);
            verifyEqual(testCase, tform2delta( tformrz(0.001) ), ...
                [0,0,0, 0,0,0.001],'absTol',1e-4);
            verifyEqual(testCase, tform2delta( tformrx(0.001), tformrx(0.002) ), ...
                [0,0,0, 0.001,0,0],'absTol',1e-4);
            
            %Testing with a scalar number input
            verifyError(testCase, @()tform2delta(1),'SMTB:tform2delta:badarg');
            verifyError(testCase, @()tform2delta( ones(3,3) ),'SMTB:tform2delta:badarg');
            
        end
        
        %    tr2jac                     - HT to Jacobian
        function tr2jac(testCase)
            
            testCase.assumeTrue(logical(exist("tr2jac", "file")), ...
                "Only run test if function tr2jac exists.");                       
            
            % unit testing tr2jac with homogeneous transform
            T = transl(1,2,3);
            [R,t] = tr2rt(T);
            
            verifyEqual(testCase, tr2jac(T), [R' zeros(3,3); zeros(3,3) R']);
            verifyEqual(testCase, tr2jac(T, 'samebody'), [R' (vec2skew(t)*R)'; zeros(3,3) R']);
            
            T = transl(1,2,3) * trotx(pi/2) * trotz(pi/2);
            [R,t] = tr2rt(T);
            
            verifyEqual(testCase, tr2jac(T), [R' zeros(3,3); zeros(3,3) R']);
            verifyEqual(testCase, tr2jac(T, 'samebody'), [R' (vec2skew(t)*R)'; zeros(3,3) R']);
            
            
            % test with scalar value
            verifyError(testCase, @()tr2jac(1),'SMTB:t2r:badarg');
        end
    end
end

