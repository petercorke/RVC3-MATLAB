classdef tBug2 < RVCTest & matlab.unittest.TestCase
    %tBug2 Unit tests for Bug2 class

    % Copyright 2023 Peter Corke, Witold Jachimczyk, Remo Pillat    
    
    methods (Test)
        function mapConstructor(testCase)
            map = zeros(10,10);
            map(2,3) = 1;
            
            nav = Bug2(map);
            
            %% test isoccupied method
            % row vector
            testCase.verifyTrue( nav.isoccupied([3,2]), "Expected cell to be occupied" );
            testCase.verifyFalse( nav.isoccupied([3,3]), "Expected cell to be free" );
            
            % column vector
            testCase.verifyTrue( nav.isoccupied([3,2]') );
            testCase.verifyFalse( nav.isoccupied([3,3]') );
            
            % separate args
            testCase.verifyTrue( nav.isoccupied(3,2) );
            testCase.verifyFalse( nav.isoccupied(3,3) );
            
            % out of bound
            testCase.verifyTrue( nav.isoccupied([20 20]) );
            
            % multiple points
            testCase.verifyEqual( nav.isoccupied([3 2; 20 20; 3 3]'), [true true false] );
            
            testCase.verifyEqual( nav.isoccupied([3 20 3], [2 20 3]), [true true false] );
            testCase.verifyEqual( nav.isoccupied([3 20 3]', [2 20 3]), [true true false] );
            testCase.verifyEqual( nav.isoccupied([3 20 3], [2 20 3]'), [true true false] );
            testCase.verifyEqual( nav.isoccupied([3 20 3]', [2 20 3]'), [true true false] );
            
            %% test inflation option
            nav = Bug2(map, "inflate", 1);
            testCase.verifyTrue( nav.isoccupied([3,2]) );
            testCase.verifyTrue( nav.isoccupied([3,3]) );
            testCase.verifyFalse( nav.isoccupied([3,4]) );
        end
        
        function mapLogicalUint8Constructor(testCase)
            
            %% logical map
            map = zeros(10,10, "logical");
            map(2,3) = true;
            
            nav = Bug2(map); 
            
            testCase.verifyTrue( nav.isoccupied([3,2]) );
            testCase.verifyFalse( nav.isoccupied([3,3]) );
            
            %% uint8 map
            map = zeros(10,10, "uint8");
            map(2,3) = 1;
            
            nav = Bug2(map);  % we can't instantiate Navigation because it's abstract
            
            testCase.verifyTrue( nav.isoccupied([3,2]) );
            testCase.verifyFalse( nav.isoccupied([3,3]) );
        end
        
        function rand(testCase)
            
            nav = Bug2();
            
            %% test random number generator
            r = nav.randn;
            testCase.verifySize(r, [1 1]);
            testCase.verifyInstanceOf(r, "double");
            r = nav.randn(2,2);
            testCase.verifySize(r, [2 2]);
        end
        
        function randi(testCase)
            
            nav = Bug2();
            
            %% test integer random number generator
            r = nav.randi(10);
            testCase.verifySize(r, [1 1]);
            testCase.verifyEqual(r, floor(r)); % is it an integer value
            testCase.verifyInstanceOf(r, 'double');
            r = nav.randi(10, 2,2);
            testCase.verifySize(r, [2 2]);
            testCase.verifyEqual(r, floor(r));
            
            % check range
            r = nav.randi(10, 100,1);
            testCase.verifyTrue(min(r) >= 1);
            testCase.verifyTrue(max(r) <= 10);
        end
    end
end