classdef tChapter7 < RunMLX & RVCTest
    %tChapter7 Unit tests for chapter 7 book code
    %   The RunMLX base class will automatically run the MLX code in the
    %   "MLXFile" property and ensure there are no errors.
    %
    %   The RVCTest base class ensures that all the RVC Toolbox code is
    %   available.
    % 
    %   Add additional unit tests for this chapter in the methods(Test) 
    %   section.

    % Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

    properties
        %MLXFile - Name of MLX file to test
        %   This property is declared in the RunMLX base class.
        MLXFile = "chapter7.mlx"
    end

    methods (TestClassSetup)
        function ignoreWarnings(testCase)
            %ignoreWarnings Ignore warnings that are expected when running the MLX file
            
            import matlab.unittest.fixtures.SuppressedWarningsFixture
            
            testCase.applyFixture( SuppressedWarningsFixture(...
                "symbolic:solve:SolutionsDependOnConditions" ...  % Symbolic solve
                ) );
        end
    end    

    methods(Test)
        % Additional test points for the chapter
    end

end
