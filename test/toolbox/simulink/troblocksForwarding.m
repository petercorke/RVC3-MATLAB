classdef troblocksForwarding < matlab.unittest.TestCase
    %troblocksForwarding Test block forwarding of blocks in roblocks library
    %   We introduced block forwarding when we introduced the sub-libraries
    %   generallib, mobilelib, and visualservolib.

    % Copyright 2023-2025 Peter Corke, Witold Jachimczyk, Remo Pillat
    
    properties (Constant)
        %ModelName - Name of Simulink model containing the old blocks
        ModelName = "mroblocksForwarding"

        %LibraryName - Main Simulink library for RVC Toolbox
        LibraryName = "roblocks"
    end

    properties
        %ForwardingTable - Forwarding table extracted from library
        %   This will be a Nx3 string array.
        ForwardingTable
    end

    properties (TestParameter)
        %BlockNames - Block names to test for forwarding
        %   Each parameter contains 3 values
        %   (1) The name of the block in ModelName
        %   (2) The original block path
        %   (3) The new, forwarded block path
        pBlockName = struct(...
            "angdiff", {{"angdiff", "roblocks/angdiff", "generallib/angdiff"}}, ...
            "tform2delta", {{"tform2delta", "roblocks/tform2delta", "generallib/tform2delta"}}, ...
            "wrapToPi", {{"wrapToPi", "roblocks/wrapToPi", "generallib/wrapToPi"}}, ...
            "Quadrotor", {{"Quadrotor", "roblocks/Quadrotor", "mobilelib/Quadrotor"}}, ...
            "ControlMixer", {{"Control Mixer 4", "roblocks/Control Mixer 4", "mobilelib/Control Mixer 4"}}, ...
            "JointVLoop", {{"Joint vloop", "roblocks/Joint vloop", "mobilelib/Joint vloop"}} ...
            )
    end

    methods(TestClassSetup)
        function loadTestModel(testCase)
            %loadTestModel Load model with forwarded blocks

            % Ensure model loads without any warnings. That's a good
            % initial sanity check that the forwarding is working.
            testCase.verifyWarningFree(@() load_system(testCase.ModelName));
            testCase.addTeardown(@() close_system(testCase.ModelName,0));
        end

        function storeForwardingTable(testCase)
            %storeForwardingTable Extract forwarding table from library and store in class property

            load_system(testCase.LibraryName);
            testCase.addTeardown(@() close_system(testCase.LibraryName, 0));

            % Retrieve the actual forwarding table
            actualTableTemp = get_param(testCase.LibraryName, "ForwardingTable");
            testCase.assertNotEmpty(actualTableTemp, "Expected forwarding table for library to exist");

            for k = 1:numel(actualTableTemp)
                while length(actualTableTemp{k})< 3
                    actualTableTemp{k}(end+1)={''};
                end
                testCase.ForwardingTable = [testCase.ForwardingTable;string(actualTableTemp{k})];
            end
        end
    end
    
    methods(Test)
        function blockForwarding(testCase, pBlockName)
            %blockForwarding Verify that block forwarding works correctly

            [blockName, oldLibraryPath, newLibraryPath] = pBlockName{:};

            % Check that block exists in test model
            blockPath = testCase.ModelName + "/" + blockName;
            testCase.assertNotEmpty(get_param(blockPath, "BlockType"), "Expected block to exist.");

            % Verify that forwarding is set up correctly
            fwdRow = find(testCase.ForwardingTable.matches(oldLibraryPath));
            testCase.verifyNotEmpty(fwdRow, "No entry for block in forwarding table")            
            actualLibraryPath = get_param(blockPath, "ReferenceBlock");
            testCase.verifyEqual(actualLibraryPath, char(newLibraryPath));
        end
    end
    
end