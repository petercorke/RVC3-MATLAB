function fetchExampleData(exampleName)
%fetchExampleData Download example data files.
%   fetchExampleData(exampleName) downloads ZIP files for use with 
%   RVC Toolbox examples and extracts the data into the toolbox/examples
%   folder. exampleName is a string corresponding to the example name.
%   Valid options for exampleName string are: "Mosaicing" and
%   "VisualOdometry".

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

arguments
    exampleName (1,1) string {mustBeMember(exampleName,["Mosaicing","VisualOdometry"])}
end

switch exampleName

    case "VisualOdometry"

        fetchedFile = fetchFromWeb("bridge-l.zip");
        outputFolder = fullfile("visodom", "left");
        unpackFile(fetchedFile, outputFolder);

        fetchedFile = fetchFromWeb("bridge-r.zip");
        outputFolder = fullfile("visodom", "right");
        unpackFile(fetchedFile, outputFolder);

    case "Mosaicing"
        
        fetchedFile = fetchFromWeb("mosaicml.zip");
        outputFolder = "mosaic";
        unpackFile(fetchedFile, outputFolder);

    otherwise
        error("Valid choices for exampleName are: VisualOdometry, Mosaicing");
end

end

function fetchedFile = fetchFromWeb(fetchThisFile)

rootUrlLocation = "https://petercorke.com/files/images/";

disp("Fetching " + fetchThisFile +". This can take a while...")
fileUrl = rootUrlLocation + fetchThisFile;
disp("File was downloaded.")

fetchedFile = fullfile(tempdir, fetchThisFile);

websave(fetchedFile, fileUrl);

end


function unpackFile(fetchedFile, outputFolder)

disp("Unpacking the ZIP file...")
examplesRootFolder = fullfile(rvctoolboxroot, "examples");
outputFullPathFolder = fullfile(examplesRootFolder, outputFolder);

unzip(fetchedFile, outputFullPathFolder);
disp("Done. Unpacked data is in " + outputFullPathFolder)

end

