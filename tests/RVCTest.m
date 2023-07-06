classdef RVCTest < matlab.unittest.TestCase
    %RVCTest Base class for all RVC3 unit tests
    %   This class handles common setup / teardown for the unit tests.
    
    methods (TestClassSetup)
        function setPath(testCase)
            %setPath Add the right folders to the MATLAB path, so tests can run
            %   This runs before any test methods run.
            %   The MATLAB path will be cleaned up when the test class is
            %   torn down.
            
            import matlab.unittest.fixtures.PathFixture
            
            rvc3Dir = fullfile(fileparts( mfilename("fullpath") ), "..", "toolbox");
            testCase.applyFixture( PathFixture(fullfile(rvc3Dir)) );
            testCase.applyFixture( PathFixture(fullfile(rvc3Dir, "data")) );
        end
    end
end