% run the unit tests locally
%
% run from this folder, will produce test report + coverage.xml file

%% set up the test runner
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.codecoverage.CoberturaFormat
import matlab.unittest.TestRunner
import matlab.unittest.plugins.codecoverage.CoverageReport

suite = testsuite(".",IncludeSubfolders=false);
runner = TestRunner.withTextOutput;

% add a coverage report
reportFile = 'coverage.xml';
% reportFormat = CoberturaFormat(reportFile);  % XML report
reportFormat = CoverageReport(".");            % HTML report

plugin = CodeCoveragePlugin.forFolder("../../toolbox", IncludingSubfolders=true, Producing=reportFormat);
runner.addPlugin(plugin);


%% Run all unit tests in this folder
fprintf('---------------------------------- Run the unit tests ------------------------------------\n')

results = runner.run(suite);
open(fullfile(".","index.html"))

