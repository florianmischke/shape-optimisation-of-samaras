// ==========================================
// Fiji / ImageJ Makro (.ijm)
// Größte Fläche -> Feret-Linie -> orthogonale Breite
// ==========================================

//run("Duplicate...", " ");

// Skalierung
run("Set Scale...", "distance=1457.0124 known=4 unit=cm");

// Vorbereitung
run("8-bit");
run("Median...", "radius=2");

// Threshold
setThreshold(0,140);

// Binärbild
run("Convert to Mask");
run("Fill Holes");

// Zuschneiden
//makeRectangle(1320,1170,2934,1002);
makeRectangle(1320, 1170, 2934, 1146);
run("Crop");

// Messungen
run("Set Measurements...", "area fit feret's feret's angle shape centroid redirect=None decimal=3");

// Anzahl vorhandener Ergebnisse und ROIs merken
startResult = nResults;
startROI = roiManager("count");

// Partikelanalyse ohne clear
run("Analyze Particles...", "size=1-Infinity show=Nothing display add");

// neue Ergebnisse suchen
maxArea = 0;
maxIndex = -1;
maxROI = -1;

for (i=startResult; i<nResults; i++) {
    area = getResult("Area", i);
    if (area > maxArea) {
        maxArea = area;
        maxIndex = i;
        maxROI = startROI + (i - startResult);
    }
}

if (maxIndex < 0) {
    print("Keine Fläche gefunden");
    exit();
}

// richtige neue ROI auswählen
roiManager("Select", maxROI);

// Konturpunkte
getSelectionCoordinates(x,y);

// --------------------------------
// Längste Distanz zwischen Konturpunkten = Feret-Linie
// --------------------------------

maxDist = 0;

for (i=0; i<x.length; i++) {
    for (j=i+1; j<x.length; j++) {
        dx = x[j]-x[i];
        dy = y[j]-y[i];

        dist = sqrt(dx*dx+dy*dy);

        if (dist > maxDist) {
            maxDist = dist;

            fx1 = x[i];
            fy1 = y[i];

            fx2 = x[j];
            fy2 = y[j];
        }
    }
}


print("Feret Pixel:", maxDist);


// --------------------------------
// Orthogonale Breite
// --------------------------------

// Richtungsvektor Feret
dx = fx2-fx1;
dy = fy2-fy1;

len = sqrt(dx*dx+dy*dy);

ux = dx/len;
uy = dy/len;

// Normalenvektor
nx = -uy;
ny = ux;

// Projektionen
minP = 1e20;
maxP = -1e20;

for (i=0; i<x.length; i++) {
    p = x[i]*nx + y[i]*ny;

    if (p < minP) {
        minP = p;
        minX = x[i];
        minY = y[i];
    }

    if (p > maxP) {
        maxP = p;
        maxX = x[i];
        maxY = y[i];
    }
}


// --------------------------------
// Orthogonale Breite korrekt zeichnen
// --------------------------------

// Feret-Richtung
dx = fx2 - fx1;
dy = fy2 - fy1;

len = sqrt(dx*dx + dy*dy);

ux = dx / len;
uy = dy / len;

// Normalenvektor (90°)
nx = -uy;
ny = ux;

// Projektionen auf Normalenrichtung
minProj = 1e20;
maxProj = -1e20;

for (i=0; i<x.length; i++) {
    proj = x[i]*nx + y[i]*ny;

    if (proj < minProj)
        minProj = proj;

    if (proj > maxProj)
        maxProj = proj;
}

// Breite in Pixel
widthPixel = maxProj - minProj;

// Mittelpunkt der ROI
cx = (fx1 + fx2) / 2;
cy = (fy1 + fy2) / 2;

// Mittelpunkt auf der Normalenrichtung korrigieren
midProj = (minProj + maxProj) / 2;

shift = midProj - (cx*nx + cy*ny);

cx = cx + nx*shift;
cy = cy + ny*shift;

// Endpunkte der orthogonalen Linie
bx1 = cx - nx*widthPixel/2;
by1 = cy - ny*widthPixel/2;

bx2 = cx + nx*widthPixel/2;
by2 = cy + ny*widthPixel/2;

// ==========================================
// Messlinien ins Bild zeichnen (rot)
// ==========================================

run("RGB Color");

setForegroundColor(255,0,0);
setLineWidth(5);

// Feret-Linie
makeLine(fx1, fy1, fx2, fy2);
run("Draw");

// Orthogonale Breite
makeLine(bx1, by1, bx2, by2);
run("Draw");

// Messwerte ins Bild schreiben
getPixelSize(unit, pixelWidth, pixelHeight, voxelDepth);
setFont("SansSerif", 18, "bold");
text = "Feret: " + d2s(maxDist*pixelWidth,3) + " " + unit + "\n" +
       "max Width: " + d2s(widthPixel*pixelWidth,3) + " " + unit + "\n";

drawString(
    text,
    50,
    50
);

// Ausgabe
getPixelSize(unit,pixelWidth,pixelHeight,voxelDepth);

print("----------------");
print("Feret Pixel:", maxDist);
print("Feret real:", maxDist*pixelWidth, unit);
print("Breite Pixel:", widthPixel);
print("Breite real:", widthPixel*pixelWidth, unit);
print("----------------");

setResult("maxWidth", nResults-1, widthPixel*pixelWidth);
setResult("FileName", nResults-1, getTitle());
updateResults();

// ROI-Manager leeren
roiManager("Reset");