# e-tinglysing-afpant-1.0.0
## Sammendrag
Bruker i avsender-bank m� innhente hvilket organisasjonsnummer forsendelsen skal til (dette hentes normalt sett ut fra signert kopi av kj�pekontrakt, og er enten organisasjonsnummeret til eiendomsmeglerforetaket eller oppgj�rsforetaket).

Deretter produseres det et **ZIP**-arkiv som inneholder:
* Kj�pers pantedokument SDO (1 eller flere filer)
* Eventuelt f�lgebrev (PDF/XML) (med forutsetninger for oversendelse av pantedokument, evt innbetalingsinformasjon)
* Dersom f�lgebrev produseres som XML m� dokumentet validere i henhold til afpant-folgebrev XSD. 

**NB**: Overf�rsel av mer enn 1 pantedokument-SDO i samme forsendelse skal normalt sett benyttes for � kunne tinglyse separate pant p� hver av hjemmelshavere (men p� samme matrikkelenhet). For eksempel i tilfeller hvor det er to debitorer (l�ntakere) som ikke er ektefeller/samboere/registrerte partnere.

Avsender-bank angir metadata-keys p� Altinn-forsendelse (i manifestet) som indikerer om avsender-bank �nsker avlesingskvittering (maskinell og/eller pr email), og hvorvidt f�lgebrevet er inkludert i ZIP eller om det sendes out-of-band (f.eks via fax eller mail direkte til megler/oppgj�r).
Mottaker (systemleverand�r) pakker ut ZIP og parser SDO for � trekke ut n�kkeldata (kreditor, debitor(er), matrikkelenhet(er)) som brukes for � rute forsendelsen til korrekt oppdrag hos korrekt megler/oppgj�rsforetak.

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
                <td><p>Dette serialiseres som en json array av alle notifications avsender �nsker. F�lgende strenger kan v�re verdi i array:</p><ul><li>EmailNotificationWhenRoutedSuccessfully</li><li>EmailNotificationWhenFailed</li><li>AltinnNotification</li></ul><p>Hvis du f.eks. har �EmailNotificationWhenFailed� og �AltinnNotification� skal mottaker sende epost hvis behandling av pantedokumentet feiler og uansett sende en ack/nack gjennom Altinn.</p></td>
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
                <td><p>String[] (enum[])</p></td>
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
                <td><p>altinnReceiptReference</p></td>
                <td><p>String</p></td>
                <td><p>Altinn kvitteringsreferanse p� opprinnelig innsendt pantedokument-SDO fra bank.</p></td>
            </tr>
            <tr>
                <td><p>status</p></td>
                <td><p>String (enum)</p></td>
                <td><p>Denne kan v�re en av f�lgende statuser:</p><ul><li>RoutedSuccessfully</li><li>UnknownCadastre</li><li>UnknownCreditor</li><li>UnknownDebitor</li><li>Rejected</li></ul></td>
            </tr>
            <tr>
                <td><p>externalSystemId</p></td>
                <td><p>String</p></td>
                <td><p>Optional: ID/oppdragsnummer/key i eksternt meglersystem/fagsystem.</p></td>
            </tr>
        </tbody>
    </table>