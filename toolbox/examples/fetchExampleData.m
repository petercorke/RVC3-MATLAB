function fetchExampleData(exampleName)


switch exampleName

    case "VisualOdometry"

        disp("Fetching bridge-l.zip. This can take a while...")
        url = "https://petercorke.com/files/images/bridge-l.zip";

        fetchedFile = "yo.zip";
        websave(fetchedFile, url);

        disp("Fetching bridge-r.zip. This can take a while...")
        url = "https://petercorke.com/files/images/bridge-r.zip";

        fetchedFile = "yo.zip";
        websave(fetchedFile, url);

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

function fetchFomWeb(fetchThis)

end