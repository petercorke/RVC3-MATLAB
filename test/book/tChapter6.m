classdef tChapter6 < RunMLX & RVCTest
    %tChapter6 Unit tests for chapter 6 book code
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
        MLXFile = "chapter6.mlx"
    end

    methods(Test)
        % Additional test points for the chapter
    end

end
