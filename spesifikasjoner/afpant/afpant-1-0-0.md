# e-tinglysing-afpant-1.0.0
## Altinn Formidlingstjeneste - servicedetaljer
<table>
	<tbody>
		<tr>
			<td><p><strong>Navn</strong></p></td>
			<td><p><strong>ServiceCode</strong></p></td>
			<td><p><strong>ServiceEditionCode</strong></p></td>
		</tr>
		<tr>
			<td><p>AFPANT (Altinn Test TT02)</p></td>
			<td><p>4752</p></td>
			<td><p>1</p></td>
		</tr>
		<tr>
			<td><p>AFPANT (Altinn Prod)</p></td>
			<td><p>4752</p></td>
			<td><p>1</p></td>
		</tr>
	</tbody>
</table>

## AFPANT-tilgang for systemleverand�rer/datasentraler
Kartverket m� gi rettigheter (READ+WRITE) i tjenesteeierstyrt rettighetsregister for alle systemleverand�rer/datasentraler som skal koble seg direkte til denne tjenesten.
Bestillinger av denne tilgangen m� gj�res via Kartverket JIRA (http://jira.statkart.no:8080/).

## Delegering av roller fra egne kunder til systemleverand�r/datasentral
Systemleverand�rer/datasentraler som skal utf�re sending/mottak p� vegne av *andre organisasjoner* (eks meglerforetak/bank) m� registrere seg selv hos Kartverket (ref ovenst�ende punkt), og skal bruke sitt *eget* organisasjonsnummer som "reportee" mot Altinn. Systemleverand�rer/datasentraler som opererer p� vegne av andre m� ogs� hente meldinger for sitt *eget organisasjonsnummer* (for det er dit ACK/NACK meldinger fra mottakersystem sendes). 

*Hver organisasjon/kunde* som en systemleverand�r/datasentral opererer p� vegne av (eks meglerforetak/bank) m� logge p� Altinn for � delegere rettigheter til sin gjeldende systemleverand�r/datasentral sitt organisasjonsnummer for tjenesten *4752* (AFPANT).
![Oppskrift for � delegere rollen 'Utfyller/Innsender' eller enkeltrettighet til systemleverand�r/datasentral sitt organisasjonsnummer finnes her](https://www.altinn.no/no/Portalhjelp/Administrere-rettigheter-og-prosessteg/Gi-roller-og-rettigheter/)

 
## Sammendrag
Bruker i avsender-bank m� innhente hvilket organisasjonsnummer forsendelsen skal til (dette hentes normalt sett ut fra signert kopi av kj�pekontrakt, og er enten organisasjonsnummeret til eiendomsmeglerforetaket eller oppgj�rsforetaket).

Deretter produseres det et **ZIP**-arkiv som inneholder f�lgende filer:
* Kj�pers pantedokument SDO (kun 1 pantedokument pr forsendelse)
* Eventuelt f�lgebrev (PDF/XML) (med forutsetninger for oversendelse av pantedokument, evt innbetalingsinformasjon)
* Dersom f�lgebrev produseres som XML m� dokumentet validere i henhold til <a href="https://github.com/Websystemer-AS/e-tinglysing-afpant/blob/master/spesifikasjoner/afpant/afpant-folgebrev/afpant-folgebrev-1-0-0.md">afpant-folgebrev spesifikasjon</a>.

**NB**: Dersom mer enn 1 pantedokument fra samme l�nesak skal tinglyses p� samme matrikkelenhet m� dette sendes som to separate forsendelser. For eksempel i tilfeller hvor det er to debitorer (l�ntakere) som ikke er ektefeller/samboere/registrerte partnere som skal ha likestilt prioritet, men separate pantedokumenter.

Avsender-bank angir metadata-keys p� Altinn-forsendelse (i manifestet) som indikerer om avsender-bank �nsker avlesingskvittering (maskinell og/eller pr email), og hvorvidt f�lgebrevet er inkludert i ZIP eller om det sendes out-of-band (f.eks via fax eller mail direkte til megler/oppgj�r).
Mottaker (systemleverand�r) pakker ut ZIP og parser SDO for � trekke ut n�kkeldata (kreditor, debitor(er), matrikkelenhet(er)) som brukes for � rute forsendelsen til korrekt oppdrag hos korrekt megler/oppgj�rsforetak.

## Validering og ruting hos mottakende system
Hver enkelt systemleverand�r som skal behandle forsendelser via AFPANT vil fors�ke rute forsendelsen til korrekt meglersak/oppdrag i sine egne kundedatabaser.
For � rute forsendelsen blir pantedokumentet pakket ut fra SDO, og matrikkelenheter/debitorer ekstraheres.

### Krav til filnavn i ZIP-arkiv
- Eventuelt f�lgebrev m� f�lge konvensjonen: "coverletter_&ast;.[pdf|xml]"
- Pantedokumentet m� f�lge konvensjonen: "signedmortgagedeed_&ast;.sdo"
Wildcard "&ast;" kan erstattes med en vilk�rlig streng (m� v�re et gyldig filnavn), f.eks l�nesaksnummer eller annen relevant referanse for avsender.

### Implementasjonsbeskrivelse: ruting
- mottakende systemleverand�r s�ker blant alle sine kunders matrikkelenhet(er)
- utvalget avgrenses til matrikkelenheter som tilh�rer meglersaker hvor organisasjonsnummeret til _enten_ meglerforetaket eller oppgj�rsforetaket p� meglersaken er lik organisasjonsnummeret pantedokumentet er sendt til
- utvalget avgrenses til meglersaker hvor **alle debitorene i pantedokumentet ogs� er registrert som kj�pere p� meglersaken** (hvis det mangler f�dselsnummer/orgnummer p� kj�per(e) kan leverand�r selv velge graden av fuzzy matching som skal tillates) 
- dersom det er registrert flere kj�pere p� meglersaken enn det finnes debitorer/signaturer i pantedokumentet skal mottakende system avvise forsendelsen med en SignedMortgageDeedProcessedMessage (NACK) hvor status = DebitorMismatch.

### H�ndtering av feil
- Den f�rste feilen som oppst�r stopper videre behandling av forsendelsen.
- SignedMortgageDeedProcessedMessage (NACK) returneres og vil ha utfyllende beskrivelse i property statusDescription.

## Avlesningskvittering
Avsender-bank kan angi hvorvidt mottakende fagsystem skal returnere en avlesningskvittering, og man kan velge f�lgende metoder:
* Avsender-bank angir i Altinn-metadata keys (senderName/senderEmail/senderPhone) kontaktinformasjonen til kontaktperson i bank og key (notificationMode) om de �nsker emailvarsling fra mottakende fagsystem ved suksessfull ruting og/eller feil.
* Avsender-bank angir i Altinn-metadata key (notificationMode) enum verdi �AltinnNotification�. Dette betyr at avsender-bank �nsker en strukturert ack/nack-melding fra mottakende fagsystem ved behandling. Ack/nack-meldingen kan da brukes av avsender-bank til � oppdatere state/workflow i eget (bank)fagsystem.
* Avsender-bank angir i Altinn-metadata key (coverLetter) enum verdi som tilsier hvorvidt f�lgebrevet ligger som PDF/XML inne i ZIP eller om det sendes til megler/oppgj�r p� annet vis. Eventuell PDF/XML er ment til manuell behandling av oppgj�rsansvarlig p� lik linje med dagens papirbaserte f�lgebrev. 

## Altinn Formidlingstjenester manifest metadata-keys ved innsending fra banksystem til meglersystem
<table>
	<tbody>
		<tr>
			<td><p><strong>Key</strong></p></td>
			<td><p><strong>Type</strong></p></td>
			<td><p><strong>Required</strong></p></td>
			<td><p><strong>Beskrivelse</strong></p></td>
		</tr>
		<tr>
			<td><p>messageType</p></td>
			<td><p>String</p></td>
			<td><p>Yes</p></td>
			<td><p>Denne kan v�re en av f�lgende:</p><ul><li>SignedMortgageDeed</li></ul></td>
		</tr>
		<tr>
			<td><p>notificationMode</p></td>
			<td><p>String[] (enum[])</p></td>
			<td><p>No</p></td>
			<td><p>Kommaseparert liste over alle notifications avsender �nsker. F�lgende strenger kan v�re verdi i array:</p><ul><li>EmailNotificationWhenRoutedSuccessfully</li><li>EmailNotificationWhenFailed</li><li>AltinnNotification</li></ul><p>Hvis du f.eks. har �EmailNotificationWhenFailed� og �AltinnNotification� skal mottaker sende epost hvis behandling av pantedokumentet feiler og uansett sende en ack/nack gjennom Altinn.</p></td>
		</tr>
		<tr>
			<td><p>senderName</p></td>
			<td><p>String</p></td>
			<td><p>No</p></td>
			<td><p>Navn p� avsender (mennesket)</p></td>
		</tr>
		<tr>
			<td><p>senderEmail</p></td>
			<td><p>String</p></td>
			<td><p>No</p></td>
			<td><p>Required hvis notificationMode EmailNotificationWhenRoutedSuccessfully eller EmailNotificationWhenFailed er angitt.<br> Email til avsender</p></td>
		</tr>
		<tr>
			<td><p>senderPhone</p></td>
			<td><p>String</p></td>
			<td><p>No</p></td>
			<td><p>Tlf til avsender</p></td>
		</tr>
		<tr>
			<td><p>coverLetter</p></td>
			<td><p>String (enum)</p></td>
			<td><p>Yes</p></td>
			<td><p>Denne kan v�re en av f�lgende statuser:</p><ul><li>FileAttached</li><li>SentOutOfBand</li><li>Omitted</li></ul></td>
		</tr>
		<tr>
			<td><p>payload</p></td>
			<td><p>String</p></td>
			<td><p>Yes</p></td>
			<td><p>Base64-encodet streng av ZIP-arkivet.</p></td>
		</tr>
	</tbody>
</table>

## Manifest metadata-keys ved retur av ACK/NACK notification fra fagsystem til bank (etter behandling av mottatt pantedokument):
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
			<td><p>Denne kan v�re en av f�lgende:</p><ul><li>SignedMortgageDeedProcessed</li></ul></td>
		</tr>
		<tr>
			<td><p>payload</p></td>
			<td><p>String</p></td>
			<td><p>Base64-encodet streng av SignedMortgageDeedProcessedMessage-objektet (serialisert som XML).</p></td>
		</tr>
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
			<td><p>Denne kan v�re en av f�lgende:</p><ul><li>SignedMortgageDeedProcessed</li></ul></td>
		</tr>
		<tr>
			<td><p>status</p></td>
			<td><p>String (enum)</p></td>
			<td><p>Denne kan v�re en av f�lgende statuser:</p><ul><li>RoutedSuccessfully</li><li>UnknownCadastre (ukjent matrikkelenhet)</li><li>DebitorMismatch (fant matrikkelenhet, men antall kj�pere eller navn/id p� kj�pere matcher ikke debitorer i pantedokumentet)</li><li>Rejected (sendt til et organisasjonsnummer som ikke lenger har et aktivt kundeforhold hos leverand�ren - feil config i Altinn AFPANT, eller ugyldig forsendelse)</li></ul></td>
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