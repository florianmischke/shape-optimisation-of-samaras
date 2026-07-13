////	runMacro("/Users/florianmischke/Library/Mobile Documents/com~apple~CloudDocs/Studium/Bachelorarbeit/GitHub/shape-optimisation-of-samaras/"+"msam.ijm");


// Ordner auswählen
//inputDir = getDirectory("Wähle den Bildordner");
//macroDir = getDirectory("Wähle den Makroordner");

inputDir = "/Users/florianmischke/Library/Mobile Documents/com~apple~CloudDocs/Studium/Bachelorarbeit/Test/";
outputDir = inputDir + "processed/";
macroDir = "/Users/florianmischke/Library/Mobile Documents/com~apple~CloudDocs/Studium/Bachelorarbeit/GitHub/shape-optimisation-of-samaras/";
File.makeDirectory(outputDir);

// Dateiliste
list = getFileList(inputDir);

for (i = 0; i < list.length; i++) {

    // Nur Bilddateien bearbeiten
    if (endsWith(list[i], ".tif") || endsWith(list[i], ".tiff")
        || endsWith(list[i], ".jpg") || endsWith(list[i], ".JPG") || endsWith(list[i], ".png")) {

        // Bild öffnen
        open(inputDir + list[i]);

        // Makro ausführen
        runMacro(macroDir + "msam.ijm");

        // Bild speichern
		saveAs("JPG", outputDir + list[i]);

        // Bild schließen
        close();
    }
}