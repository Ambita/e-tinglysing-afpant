# e-tinglysing-afpant-folgebrev-1.0.0
## F�lgebrev fra bank til megler - AFPANT

XSD: https://github.com/Websystemer-AS/e-tinglysing-afpant/blob/master/spesifikasjoner/afpant/afpant-folgebrev/afpant-folgebrev/afpant-folgebrev-xsd/afpant-folgebrev-1.0.0.xsd

XSLT: https://github.com/Websystemer-AS/e-tinglysing-afpant/blob/master/spesifikasjoner/afpant/afpant-folgebrev/afpant-folgebrev/afpant-folgebrev-xslt/afpant-folgebrev-1.0.0.xslt

Eksempel XML: http://last-opp.pantedokumentet.no/AFPANT/afpant-folgebrev-example1.xml

## Sammendrag
F�lgebrev fra bank kan produseres som XML. Dokumentet m� da validere i henhold til XSD, og vil bli rendret av mottakers system ved hjelp av XSLT.
Referanse til XSD (xsi:noNamespaceSchemaLocation) og XSLT (<?xml-stylesheet />) m� inkluderes i produsert XML slik at dokumentet blir self-contained.

XSD og XSLT vil bli hostet p� https://last-opp.pantedokumentet.no/AFPANT/

### Prod URI til XSD/XSLT
- XSD: http://last-opp.pantedokumentet.no/AFPANT/afpant-folgebrev-1.0.0.xsd
- XSLT (uten semver revision): http://last-opp.pantedokumentet.no/AFPANT/afpant-folgebrev-1.0.xslt

## Eksempel
XSD.EXE kan brukes for � autogenerere en POCO fra XSD (Se eksempel p� https://github.com/Websystemer-AS/e-tinglysing-afpant/blob/master/spesifikasjoner/afpant/afpant-folgebrev/afpant-folgebrev/generate-poco-from-xsd.bat)

Hvordan serialisere AFPANT.Folgebrev til XML med XSD+XSLT referanser: https://github.com/Websystemer-AS/e-tinglysing-afpant/blob/master/spesifikasjoner/afpant/afpant-folgebrev/afpant-folgebrev-example/Program.cs

![Eksempel p� rendret f�lgebrev som html](https://github.com/Websystemer-AS/e-tinglysing-afpant/blob/master/spesifikasjoner/afpant/afpant-folgebrev/afpant-folgebrev/afpant-folgebrev-xslt/afpant-folgebrev-rendered-example.PNG)

## F�lgebrev XSD diagram
![Diagram av f�lgebrev XSD](https://github.com/Websystemer-AS/e-tinglysing-afpant/blob/master/spesifikasjoner/afpant/afpant-folgebrev/afpant-folgebrev/afpant-folgebrev-xslt/afpant-folgebrev-1.0.0.jpg)
