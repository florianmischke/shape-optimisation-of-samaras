import os
import csv
from xml.dom import minidom
from svg.path import parse_path, CubicBezier

print("Ordner mit SVG-Dateien:")
folder = input().strip()

output_file = os.path.join(folder, "svg_punkte.csv")
rows = []

for filename in sorted(os.listdir(folder)):
    if not filename.lower().endswith(".svg"):
        continue

    filepath = os.path.join(folder, filename)
    doc = minidom.parse(filepath)

    for path in doc.getElementsByTagName("path"):
        for curve in parse_path(path.getAttribute("d")):

            if not isinstance(curve, CubicBezier):
                continue

            points = [
                ("A", curve.start),
                ("B", curve.control1),
                ("C", curve.control2),
                ("D", curve.end)
            ]

            for name, point in points:
                rows.append([
                    filename,
                    name,
                    round(point.real, 3),
                    round(-point.imag, 3)
                ])

    doc.unlink()

with open(output_file, "w", newline="", encoding="utf-8-sig") as f:
    writer = csv.writer(f, delimiter=";")
    writer.writerow(["Dateiname", "Punkt", "X", "Y"])
    writer.writerows(rows)

print(f"Fertig: {output_file}")