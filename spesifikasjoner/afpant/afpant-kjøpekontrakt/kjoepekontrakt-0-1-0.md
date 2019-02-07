# Kjøpekontrakt
En bank kan sende forespørsel om kjøpekontrakt til en megler basert på kjøpers fødsels og personnummer og eiendomsobjektet som skal finansieres.
Megler vil besvare forespørselen med en forsendelse som inneholder stukrutrerte data samt en signert versjon av den fulle kontrakten.
Dersom den faktiske kjøpekontrakten ikke er signert, skal kun den strukturerte delen returneres.
Dersom forespørselen ikke kan besvares, vil banken få en feilmelding i retur som beskriver hvorfor megler ikke kan besvare forespørselen.

## Forspørsel om kjøpekontrakt

### Manifest
(BrokerServiceInitiation.Manifest.PropertyList)

|Manifest key|Type|Required|Beskrivelse|
|--- |--- |--- |--- |
|messageType|String|Yes|RealEstatePurchaseContractRequest|

### Payload
En ZIP-fil som inneholder en XML med requestdata ihht. [definert skjema.](xsd/dsbm-1.0.0.xsd)

#### Om payload *(request)*
- Må være en xml-fil som er i henhold til xsd-filen.
- Avsenderinfo (orgnr)
- Kontaktperson
- Objektinformasjon
- Kjøper
- Banks referanse/saksnr

## Svar fra meglersystem til banksystem

### Manifest
(BrokerServiceInitiation.Manifest.PropertyList)

|Manifest key|Type|Required|Beskrivelse|
|--- |--- |--- |--- |
|messageType|String|Yes|RealEstatePurchaseContractResponse|

### Payload
En ZIP-fil som inneholder en XML med responsdata ihht. gitte xsd.
Tilknytting av ZIP-fil til forsendelsen kan gjøres ved bruk av BrokerServiceExternalBasicStreamedClient / StreamedPayloadBasicBE.
		
#### Om payload *(response)*

##### Positiv resultat
- Må være en xml-fil som er ihht. [definert skjema](xsd/dsbm-1.0.0.xsd).
- Se eksempel på presentasjon [Eksempel](examples/example.png)

##### Negativt resultat
- @todo:Må definere hvor ack/navk-informasjon skal legges
