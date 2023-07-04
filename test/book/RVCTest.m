classdef RVCTest < matlab.unittest.TestCase
    %RVCTest Base class for all RVC3 unit tests
    %   This class handles common setup / teardown for unit tests.
    %   Derive from this class in your own test case, e.g.
    %
    %     classdef tChapter2 < RVCTest

    % Copyright 2023 Peter Corke, Witold Jachimczyk, Remo Pillat

    properties
        %RVCToolboxRoot - Root folder for "toolbox" folder
        RVCToolboxRoot

        %BookRoot - Root folder for "book" folder
        %   Use this when accessing the book MLX or figure files.
        BookRoot
    end
    
    methods (TestClassSetup)
        function setRVC3Path(testCase)
            %setRVC3Path Set MATLAB path for RVC Toolbox
            %   This runs before any test methods run.
            %   The MATLAB path will be cleaned up when the test class is
            %   torn down.
            
            import matlab.unittest.fixtures.PathFixture
            
            rvc3Dir = fullfile(fileparts( mfilename("fullpath") ), "..", "..", "toolbox");
            testCase.applyFixture( PathFixture(fullfile(rvc3Dir)) );
            testCase.applyFixture( PathFixture(fullfile(rvc3Dir, "data")) );
            testCase.applyFixture( PathFixture(fullfile(rvc3Dir, "examples")) );
            testCase.applyFixture( PathFixture(fullfile(rvc3Dir, "images")) );
            testCase.applyFixture( PathFixture(fullfile(rvc3Dir, "internal")) );
        end

        function setRootProperties(testCase)
            %setRootProperties Set properties to define root folders

            repoDir = fullfile(fileparts( mfilename("fullpath") ), "..", "..");
            testCase.RVCToolboxRoot = fullfile(repoDir, "toolbox");
            testCase.BookRoot = fullfile(repoDir, "book");
        end
    end
end