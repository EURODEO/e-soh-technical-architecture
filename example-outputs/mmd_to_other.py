import os
from lxml import etree

mmd_infile = "latest"
xml_doc = etree.ElementTree(file="xml-output/"+mmd_infile+".mmd")

for filename in os.listdir("xslt"):
    print(filename)
    if filename.split("-")[0] != "mmd":
        print(filename, " is not mmd-to-something transformation, skipping")
        continue
    transform = etree.XSLT(etree.parse("xslt/"+filename))
    new_doc = transform(xml_doc)
    result = etree.tostring(new_doc, pretty_print=True, encoding="utf-8")
    with open("xml-output/"+mmd_infile+"."+filename.split(".")[0].split("-")[-1], "wb") as outfile:
        outfile.write(result)
