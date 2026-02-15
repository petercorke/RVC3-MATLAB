classdef ttb_optparse < RVCTest & matlab.unittest.TestCase
    %ttb_optparse Unit tests for tb_optparse function

    % Copyright 2025 Peter Corke, Witold Jachimczyk, Remo Pillat

    %% Tests for LineSpec parsing and output argument
    properties (TestParameter)
        %pLineSpecValid - Valid LineSpec definitions
        pLineSpecValid = struct(...
            "SolidLine", '-', ...
            "RedDashedCircles", '--or',  ...
            "TriangleBlue", 'b^' ...
            )

        %pLineSpecInvalid - Invalid LineSpec definitions
        pLineSpecInvalid = struct(...
            "OtherAlphabetic", 'fjl', ...
            "OneCharacterWrong", '--oQ', ...
            "SpecialChars", '&(', ...
            "NotCharArray", ["--" "o"], ...
            "Cell", {{'--o'}} ...
            )
    end

    methods(Test)
        function validLineSpec(testCase, pLineSpecValid)
            %validLineSpec Positive tests for LineSpec parsing
            %   The actual options structure (first argument to
            %   tb_optparse) is just an empty structure.
            
            % The LineSpec is the only argument that's passed to tb_optparse.
            % Expectation: The LineSpec is returned as third output
            [~,~,actualLineSpec] = tb_optparse(struct, {pLineSpecValid});
            testCase.assertNotEmpty(actualLineSpec);
            testCase.verifyEqual(actualLineSpec{1}, pLineSpecValid, "Expected LineSpec to be parsed correctly.");

            % The LineSpec is passed along with other arguments
            % Expectation: The LineSpec argument is returned as third
            % output. The other arguments are ignored.
            [~,~,actualLineSpec] = tb_optparse(struct, {pLineSpecValid, "LineWidth", 2});
            testCase.verifyEqual(actualLineSpec{1}, pLineSpecValid, "Expected LineSpec to be parsed correctly.");
            [~,~,actualLineSpec] = tb_optparse(struct, {"ffo", pLineSpecValid, 'baa'});
            testCase.verifyEqual(actualLineSpec{1}, pLineSpecValid, "Expected LineSpec to be parsed correctly.");
        end

        function validLineSpecMultiple(testCase, pLineSpecValid)
            %validLineSpecMultiple Test passing multiple (valid) LineSpecs 
            
            % Expectation: Only the first LineSpec that's matched is
            % returned.
            flipLineSpec = fliplr(pLineSpecValid);
            [~,~,actualLineSpec] = tb_optparse(struct, {pLineSpecValid, flipLineSpec});
            testCase.verifyEqual(actualLineSpec{1}, pLineSpecValid);

            [~,~,actualLineSpec] = tb_optparse(struct, {flipLineSpec, pLineSpecValid});
            testCase.verifyEqual(actualLineSpec{1}, flipLineSpec);

            [~,~,actualLineSpec] = tb_optparse(struct, {{''}, flipLineSpec, pLineSpecValid, struct});
            testCase.verifyEqual(actualLineSpec{1}, flipLineSpec);
        end

        function validLineSpecString(testCase, pLineSpecValid)
            %validLineSpecString String inputs should also work

            % Expectation: Result is still returned as character array
            [~,~,actualLineSpec] = tb_optparse(struct, {string(pLineSpecValid)});
            testCase.verifyEqual(actualLineSpec{1}, pLineSpecValid, "Expected LineSpec as string to work.");            
        end

        function validLineSpecRepeated(testCase)
            %validLineSpecRepeated Test for having repeated tokens

            repeatedColor = ':kk';
            [~,~,actualLineSpec] = tb_optparse(struct, {repeatedColor});
            testCase.verifyEqual(actualLineSpec{1}, repeatedColor);

            repeatedMultiChar = '--:rg-.';
            [~,~,actualLineSpec] = tb_optparse(struct, {repeatedMultiChar});
            testCase.verifyEqual(actualLineSpec{1}, repeatedMultiChar);
        end

        function invalidLineSpecNeg(testCase, pLineSpecInvalid)
            %invalidLineSpecNeg Negative tests for LineSpec parsing

            [~,~,actualLineSpec] = tb_optparse(struct, {pLineSpecInvalid});
            testCase.verifyEqual(actualLineSpec, {}, "Expected empty cell return for invalid LineSpec.")
        end
    end
    
end