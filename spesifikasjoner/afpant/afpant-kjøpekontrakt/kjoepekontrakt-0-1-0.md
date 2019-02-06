# kjøpekontrakt

## Altinn Formidlingstjeneste: Manifest
Altinn ServiceEngine Broker støtter at avsender angir egendefinerte key/value pairs i Manifest.PropertyList (Manifest-objektet angis i ServiceEngine BrokerServiceInitiation.Manifest property). 

Ved bruk av ServiceEngine webservices vil Altinn Formidlingstjenester automatisk legge til en fil med navn "manifest.xml" i ZIP-filen som avsender tilknytter forsendelsen.

"Manifest.xml"-filen er av type BrokerServiceManifest.

## Forspørsel fra banksystem til meglersystem
<table>
	<thead>
		<tr>
			<th colspan="4">Manifest metadata (BrokerServiceInitiation.Manifest.PropertyList)</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><p><strong>Manifest key</strong></p></td>
			<td><p><strong>Type</strong></p></td>
			<td><p><strong>Required</strong></p></td>
			<td><p><strong>Beskrivelse</strong></p></td>
		</tr>
		<tr>
			<td><p>messageType</p></td>
			<td><p>String</p></td>
			<td><p>Yes</p></td>
			<td><p>Denne kan være en av følgende:</p><ul><li>RealEstatePurchaseContractRequest</li></ul></td>
		</tr>
		<tr><td colspan="4"><strong>Payload (ZIP-fil)</strong></td></tr>
		<tr><td colspan="4">En ZIP-fil som inneholder en XML med requestdata ihht. gitte xsd.<br>
		Tilknytting av ZIP-fil til forsendelsen kan gjøres ved bruk av BrokerServiceExternalBasicStreamedClient / StreamedPayloadBasicBE.</td></tr>
	</tbody>
</table>


### Requestdata
- Må være en xml-fil som er i henhold til xsd-filen.
- Avsenderinfo (orgnr)
- kontaktperson
- Objektinformasjon
- Kjøper
- banks referanse/saksnr

## Svar fra meglersystem til banksystem
<table>
	<thead>
		<tr>
			<th colspan="4">Manifest metadata (BrokerServiceInitiation.Manifest.PropertyList)</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><p><strong>Manifest key</strong></p></td>
			<td><p><strong>Type</strong></p></td>
			<td><p><strong>Required</strong></p></td>
			<td><p><strong>Beskrivelse</strong></p></td>
		</tr>
		<tr>
			<td><p>messageType</p></td>
			<td><p>String</p></td>
			<td><p>Yes</p></td>
			<td><p>Denne kan være en av følgende:</p><ul><li>RealEstatePurchaseContractRespone</li></ul></td>
		</tr>
    </tbody>
</table>
<table>
	<thead>
		<tr><td colspan="4"><strong>Payload (ZIP-fil)</strong></td></tr>
	</thead>
	<tbody>
		<tr><td colspan="4">En ZIP-fil som inneholder en XML med responsdata ihht. gitte xsd.<br>
		Tilknytting av ZIP-fil til forsendelsen kan gjøres ved bruk av BrokerServiceExternalBasicStreamedClient / StreamedPayloadBasicBE.</td></tr>
	</tbody>
</table>

### Xml med informasjon om kjøpekontrakten
- Må være en xml-fil som er i henhold til xsd-filen.
-- se eksempel på presentasjon[![Eksempel](examples/example.png | width=25)




### Implementasjonsbeskrivelse: ruting
- mottakende systemleverandør søker blant alle sine kunders matrikkelenhet(er)
- utvalget avgrenses til matrikkelenheter som tilhører meglersaker hvor organisasjonsnummeret til _enten_ meglerforetaket eller oppgjørsforetaket på meglersaken er lik organisasjonsnummeret pantedokumentet er sendt til ("reportee")
- utvalget avgrenses til meglersaker hvor **alle debitorene i pantedokumentet også er registrert som kjøpere på meglersaken** (hvis det mangler fødselsnummer/orgnummer på kjøper(e) kan leverandør selv velge graden av fuzzy matching som skal tillates) 
- dersom det er registrert flere kjøpere på meglersaken enn det finnes debitorer/signaturer i pantedokumentet skal mottakende system avvise forsendelsen med en SignedMortgageDeedProcessedMessage (NACK) hvor status = DebitorMismatch.

### Håndtering av feil
- Den første feilen som oppstår stopper videre behandling av forsendelsen.
- SignedMortgageDeedProcessedMessage (NACK) returneres og vil ha utfyllende beskrivelse i property statusDescription. 
- SignedMortgageDeedProcessedMessage.statusDescription må være angitt på norsk.

## Avlesningskvittering
Avsender-bank kan angi hvorvidt mottakende fagsystem skal returnere en avlesningskvittering, og man kan velge følgende metoder:
* Avsender-bank angir i manifest metadata keys (senderName/senderEmail/senderPhone) kontaktinformasjonen til kontaktperson i bank og key (notificationMode) om de ønsker emailvarsling fra mottakende fagsystem ved suksessfull ruting og/eller feil.
* Avsender-bank angir i manifest metadata key (notificationMode) enum verdi «AltinnNotification». Dette betyr at avsender-bank ønsker en strukturert ack/nack-melding fra mottakende fagsystem ved behandling. Ack/nack-meldingen kan da brukes av avsender-bank til å oppdatere state/workflow i eget (bank)fagsystem.
* Avsender-bank angir i manifest metadata key (coverLetter) enum verdi som tilsier hvorvidt følgebrevet ligger som PDF/XML inne i ZIP eller om det sendes til megler/oppgjør på annet vis. Eventuell PDF/XML er ment til manuell behandling av oppgjørsansvarlig på lik linje med dagens papirbaserte følgebrev. 



## Retur av ACK/NACK notification fra fagsystem til bank (etter behandling av mottatt pantedokument):
<table>
	<thead>
		<tr>
			<th colspan="4">Manifest metadata (BrokerServiceInitiation.Manifest.PropertyList)</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><p><strong>Manifest key</strong></p></td>
			<td><p><strong>Type</strong></p></td>
			<td><p><strong>Beskrivelse</strong></p></td>
		</tr>
		<tr>
			<td><p>messageType</p></td>
			<td><p>String</p></td>
			<td><p>Denne kan være en av følgende:</p><ul><li>SignedMortgageDeedProcessed</li></ul></td>
		</tr>
		<tr><td colspan="3"><strong>Payload (ZIP-fil)</strong></td></tr>
		<tr><td colspan="3">En ZIP-fil som inneholder en XML fil av SignedMortgageDeedProcessedMessage-objektet.</td></tr>
	</tbody>
</table>

## SignedMortgageDeedProcessedMessage objekt
<table>
	<tbody>
		<tr>
			<td><p><strong>Key</strong></p></td>
			<td><p><strong>Type</strong></p></td>
			<td><p><strong>Beskrivelse</strong></p></td>
		</tr>
		<tr>
			<td><p>messageType</p></td>
			<td><p>String</p></td>
			<td><p>Denne kan være en av følgende:</p><ul><li>SignedMortgageDeedProcessed</li></ul></td>
		</tr>
		<tr>
			<td><p>status</p></td>
			<td><p>String (enum)</p></td>
			<td>Denne kan være en av følgende statuser:	<ul><li>RoutedSuccessfully</li><li>UnknownCadastre (ukjent matrikkelenhet)</li><li>DebitorMismatch (fant matrikkelenhet, men antall kjøpere eller navn/id på kjøpere matcher ikke debitorer i pantedokumentet)</li><li>Rejected (sendt til et organisasjonsnummer som ikke lenger har et aktivt kundeforhold hos leverandøren - feil config i Altinn AFPANT, eller ugyldig forsendelse)</li></ul> Kun status 'RoutedSuccessfully' er å anse som ACK (positive acknowledgement). Øvrige statuser er å anse som NACK (negative acknowledgement).</td>
		</tr>
		<tr>
			<td><p>statusDescription</p></td>
			<td><p>String</p></td>
			<td><p>Inneholder en utfyllende human-readable beskrivelse om hvorfor en forsendelse ble NACK'et.</td>
		</tr>
		<tr>
			<td><p>externalSystemId</p></td>
			<td><p>String</p></td>
			<td><p>Optional: ID/oppdragsnummer/key i eksternt meglersystem/fagsystem.</p></td>
		</tr>
	</tbody>
</table>
