function fetchExampleData(exampleName)


switch exampleName

    case "VisualOdometry"

        fetchedFile = fetchFromWeb("bridge-l.zip");
        outputFolder = fullfile("visodom", "left");
        unpackFile(fetchedFile, outputFolder);

        fetchedFile = fetchFromWeb("bridge-r.zip");
        outputFolder = fullfile("visodom", "right");
        unpackFile(fetchedFile, outputFolder);

    case "Mosaicking"
        url= "https://petercorke.com/files/images/mosaic.zip";

        fetchedFile = "yo.zip";
        disp("Fetching mosaic.zip. This can take a while...")
        websave(fetchedFile, url);
        disp("Done!")

    otherwise
        error("Valid choices for exampleName are: VisualOdometry, Mosaicking");
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

