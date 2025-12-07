classdef RunMLX < RVCTest
    %RunMLX Base class for running chapter MLX files
    %   To automatically run the MLX file and perform a few other sanity
    %   checks, derive from RunMLX and define the "MLXFile" property.
    %   For example:
    %
    %     classdef tChapter2 < RunMLX
    %        properties(Test)
    %           MLXFile = "chapter2.mlx"
    %        end
    %     end

    % Copyright 2023 Peter Corke, Witold Jachimczyk, Remo Pillat

    properties (Abstract)
        MLXFile
        %MLXFile - Abstract property to be defined by derived class
    end

    methods(Test)        
        function runMLXFile(testCase)
            %runMLXFile - Ensure MLX file runs with no errors

            import matlab.unittest.fixtures.PathFixture
            import matlab.unittest.fixtures.WorkingFolderFixture

            testCase.log(1,"Executing book chapter " + testCase.MLXFile);

            % Make sure that all figures and apps are closed while
            % everything is still on the path.
            testCase.addTeardown(@() close("force","all"))

            % Make sure that all Simulink models are closed while
            % everything is still on the path.
            testCase.addTeardown(@() bdclose("all"))

            % Go into a temporary folder, just in case the chapter file
            % download / creates any files.
            testCase.applyFixture(WorkingFolderFixture);


            % Add the chapter MLX folder to the path. This path will be
            % removed when the test method is torn down.
            testCase.applyFixture( PathFixture(fullfile(testCase.BookRoot, "code")) );

            % Run the MLX file and make sure there are no warnings or
            % errors.
            testCase.verifyWarningFree(@testCase.runFile, ...
                "Did not expect any warnings or errors when running " + ...
                testCase.MLXFile);
            
        end
    end

    methods (Access = private)
        function runFile(testCase)
            run(testCase.MLXFile);
        end
    end
    
end