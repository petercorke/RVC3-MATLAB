classdef tmkgrid < matlab.unittest.TestCase & RVCTest
    %Unit test for mkgrid class
    
    methods (Test)
        function fixToBugInCh11(testCase)
            actP = mkgrid(3, 0.2, 'pose', trvec2tform([0 0 1.0]));
            expP = [-0.1 -0.1 -0.1 0 0 0 0.1 0.1 0.1;-0.1 0 0.1 -0.1 0 0.1 -0.1 0 0.1;1 1 1 1 1 1 1 1 1]';

            %% check that the transform is applied correctly 
            %  it used to ignore the Z translation
            testCase.verifyEqual(actP, expP, "Incorrect grid after translation" );
                        
        end
    end % methods
end