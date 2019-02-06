# Kjøpekontrakt

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
  </tbody>
</table
<br>

| *Payload zip-fil* |
|-------------------| 
| En ZIP-fil som inneholder en XML med requestdata ihht. [definert skjema.](https://xsd/dsbm-1.0.0.xsd) |

### Requestdata
- Må være en xml-fil som er i henhold til xsd-filen.
- Avsenderinfo (orgnr)
- Kontaktperson
- Objektinformasjon
- Kjøper
- Banks referanse/saksnr

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
- Må være en xml-fil som er i [henhold til xsd-filen](xsd/dsbm-1.0.0.xsd).
- Se eksempel på presentasjon [Eksempel](examples/example.png)
- Må definer hvor ack/navk-informasjon skal legges
