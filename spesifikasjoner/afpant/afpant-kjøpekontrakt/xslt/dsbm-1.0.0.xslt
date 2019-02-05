<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
  <xsl:decimal-format name="nb-no-space" decimal-separator="," grouping-separator=" " NaN=" "/>
  <xsl:template match="/kjoepekontrakt">
    <html>
      <head>
        <title>Kjøpekontrakt</title>
        <style type="text/css">
          .overskrift {
          color: #255473;
          }

          .seksjonsoverskrift {
          color: #255473;
          font-weight: bold;
          padding-bottom: 8px;
          }

          .rolleoverskrift{
          padding-top: 8px;
          color:#255473;
          font-weight:bold;
          }

          .liste {
          padding-top: 2px;
          padding-bottom: 8px;
          }

          .listeelement {
          font-weight: normal;
          padding-bottom: 8px;
          }

          .innhold {
          padding-left: 8px;
          }

          body {
          margin: 0;
          padding: 0;
          height: 100%;

          }

          .hovedseksjon {
          padding: 5px 5px 5px 5px;
          margin-bottom: 4px;
          }

          #container {
          min-height: 100%;
          position: relative;
          margin: 10px 10px 10px 10px;
          font-family: helvetica;
          max-width: 210mm
          }

          #header {
          padding-left: 5px;
          padding-top: 1px;
          padding-bottom: 1px;
          }

          #body {
          padding-top: 10px;
          padding-bottom: 50px;
          widht: 100%;
          }

          #footer {
          position: absolute;
          bottom: 0;
          width: 100%;
          height: 50px;
          background: #BDCBBD !important;
          color: #255473;
          text-align: center;
          }

          .tabell{
          display: table;
          width: 100%;
          }
          .rad {
          display: table-row;
          }
          .celle, .divTableHead {
          border: 0px;
          display: table-cell;
          padding: 1px 1px;
          }
          .kropp {
          display: table-row-group;
          }
        </style>
      </head>
      <body>
        <div id="container">
          <div id="header">
            <xsl:call-template name="overskrift"/>
          </div>
          <div id="body">
            <xsl:call-template name="aktoerer"/>
            <xsl:call-template name="eiendom"/>
            <xsl:call-template name="oppgjoer"/>
            <xsl:call-template name="megler"/>
            <xsl:call-template name="ressurser"/>
            <xsl:call-template name="footer"/>
            <hr/>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="megler">
    <div class="hovedseksjon">
      <xsl:call-template name="seksjon">
        <xsl:with-param name="tittel" select="'Melger'"/>
      </xsl:call-template>
      <div class="tabell innhold">
        <div class="rad">
          <div class="celle">
            <xsl:if test="megler/anvarligMegler">
              <div style="padding-bottom:8px;">
                <xsl:call-template name="organisasjon">
                  <xsl:with-param name="organisasjon" select="megler"/>
                </xsl:call-template>
              </div>
              <xsl:call-template name="kontaktperson">
                <xsl:with-param name="kontakt" select="megler/anvarligMegler"/>
                <xsl:with-param name="referanse" select="megler/referanse"/>
              </xsl:call-template>
            </xsl:if>
          </div>
          <div class="celle">
            <xsl:if test="megler/oppgjorsavdeling">
              <xsl:text>Oppgjør:&#x20;</xsl:text>
              <div style="padding-bottom:8px;">
                <xsl:call-template name="organisasjon">
                  <xsl:with-param name="organisasjon" select="megler/oppgjorsavdeling"/>
                </xsl:call-template>
              </div>
            </xsl:if>
            <div>
              <div>Referanse:</div>
              <xsl:value-of select="megler/referanse"/>
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="ressurser">
    <div class="hovedseksjon">
      <xsl:call-template name="seksjon">
        <xsl:with-param name="tittel" select="'Vedlegg'"/>
      </xsl:call-template>
      <div class="tabell innhold">
        <div class="rad" style="font-style: italic;">
          <div class="celle">Filnavn</div>
          <div class="celle">Beskrivelse</div>
        </div>
        <xsl:for-each select="metadata/ressurser/vedlegg">
          <xsl:call-template name="vedlegg">
            <xsl:with-param name="vedlegg" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="vedlegg">
    <xsl:param name="vedlegg"></xsl:param>
    <div class="rad">
      <div class="celle">
        <xsl:value-of select="$vedlegg/navn"></xsl:value-of>
      </div>
      <div class="celle">
        <xsl:value-of select="$vedlegg/beskrivelse"></xsl:value-of>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="organisasjon">
    <xsl:param name="organisasjon"/>
    <xsl:value-of select="$organisasjon/foretaksnavn"/>
    <xsl:text>&#x20;org.nr.&#x20;</xsl:text>
    <xsl:call-template name="orgnr">
      <xsl:with-param name="id" select="$organisasjon/@id"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="oppgjoer">
    <div class="hovedseksjon">
      <xsl:call-template name="seksjon">
        <xsl:with-param name="tittel" select="'Oppgjør'"/>
      </xsl:call-template>
      <div class="innhold">
        <div class="tabell">
          <div class="kropp">
            <div class="rad">
              <div class="celle">
                <xsl:text>Kjøpesum:&#x20;</xsl:text>
              </div>
              <div class="celle">
                <xsl:call-template name="formatNumber">
                  <xsl:with-param name="prefix" select="'kr. '"/>
                  <xsl:with-param name="numericValue" select="oppgjorsinformasjon/salgssum"/>
                </xsl:call-template>
              </div>
            </div>
            <div class="rad">
              <div class="celle">
                <xsl:text>Omkostninger:&#x20;</xsl:text>
              </div>
              <div class="celle">
                <xsl:call-template name="formatNumber">
                  <xsl:with-param name="prefix" select="'kr. '"/>
                  <xsl:with-param name="numericValue" select="oppgjorsinformasjon/omkostningerKjoeper"/>
                </xsl:call-template>
              </div>
            </div>
            <div class="rad">
              <div class="celle">
                <xsl:text>Andel fellesgjeld:&#x20;</xsl:text>

              </div>
              <div class="celle">
                <xsl:call-template name="formatNumber">
                  <xsl:with-param name="prefix" select="'kr. '"/>
                  <xsl:with-param name="numericValue" select="oppgjorsinformasjon/andelFellesgjeld"/>
                </xsl:call-template>
              </div>
            </div>
            <div class="rad">
              <div class="celle">
                <xsl:text>Andel fellesformue:&#x20;</xsl:text>

              </div>
              <div class="celle">
                <xsl:call-template name="formatNumber">
                  <xsl:with-param name="prefix" select="'kr. '"/>
                  <xsl:with-param name="numericValue" select="oppgjorsinformasjon/andelFellesformue"/>
                </xsl:call-template>
              </div>
            </div>
            <div class="rad">
              <div class="celle">
                <xsl:text>Akseptdato:&#x20;</xsl:text>
              </div>
              <div class="celle">
                <xsl:call-template name="dato">
                  <xsl:with-param name="dato" select="oppgjorsinformasjon/akseptdato"/>
                </xsl:call-template>
              </div>
            </div>
            <div class="rad">
              <div class="celle">
                <xsl:text>Overtagelsesdato:&#x20;</xsl:text>
              </div>
              <div class="celle">
                <xsl:call-template name="dato">
                  <xsl:with-param name="dato" select="oppgjorsinformasjon/overtagelsesdato"/>
                </xsl:call-template>
              </div>
            </div>
            <div class="rad">
              <div class="celle">
                <xsl:text>Spesielle forhold:&#x20;</xsl:text>
              </div>
              <div class="celle">
                <xsl:if test="oppgjorsinformasjon/spesielleForhold='true'">Ja</xsl:if>
                <xsl:if test="oppgjorsinformasjon/spesielleForhold='false'">Nei</xsl:if>
              </div>
            </div>
            <div class="rad">
              <div class="celle">
                <xsl:text>Elektronisk tinglysing:&#x20;</xsl:text>
              </div>
              <div class="celle">
                <xsl:if test="oppgjorsinformasjon/onskerElektroniskTinglysing">Ja</xsl:if>
                <xsl:if test="not(oppgjorsinformasjon/onskerElektroniskTinglysing)">Nei</xsl:if>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="eiendom">
    <div class="hovedseksjon">
      <xsl:call-template name="seksjon">
        <xsl:with-param name="tittel" select="'Salgsobjekt'"/>
      </xsl:call-template>
      <div class="liste">
        <xsl:for-each select="salgsobjekt/registerenheter/registerenhet">
          <div class="listeelement">
            <xsl:call-template name="registerenhet">
              <xsl:with-param name="registerenhet" select="."/>
            </xsl:call-template>
          </div>
        </xsl:for-each>
        <div class="innhold">
          <a href="{salgsobjekt/salgsoppgave}" target="_blank">Salgsoppgave</a>
          <xsl:text>&#x20;|&#x20;</xsl:text>
          <a href="{salgsobjekt/nettannonse}" target="_blank">Nettannonse</a>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="registerenhet">
    <xsl:param name="registerenhet"/>
    <div class="innhold">
      <xsl:if test="$registerenhet/matrikkel">
        <xsl:call-template name="eiendomsnivaatype">
          <xsl:with-param name="matrikkel" select="$registerenhet/matrikkel"/>
        </xsl:call-template>
        <xsl:if test="$registerenhet/adresse">
          <xsl:call-template name="adresse">
            <xsl:with-param name="adresse" select="$registerenhet/adresse"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="matrikkel">
          <xsl:with-param name="matrikkel" select="$registerenhet/matrikkel"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$registerenhet/borettsandel">
        <xsl:text>Borettsandel</xsl:text>
        <xsl:if test="$registerenhet/adresse">
          <xsl:call-template name="adresse">
            <xsl:with-param name="adresse" select="$registerenhet/adresse"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="borettsandel">
          <xsl:with-param name="borettsandel" select="$registerenhet/borettsandel"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$registerenhet/aksjeleilighet">
        <xsl:text>Aksjeleilighet</xsl:text>
        <xsl:if test="$registerenhet/adresse">
          <xsl:call-template name="adresse">
            <xsl:with-param name="adresse" select="$registerenhet/adresse"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="aksjeleilighet">
          <xsl:with-param name="aksjeleilighet" select="$registerenhet/aksjeleilighet"/>
        </xsl:call-template>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template name="aksjeleilighet">
    <xsl:param name="aksjeleilighet"/>
    <div>
      <xsl:value-of select="$aksjeleilighet/@organisasjonsnavn"/>
      <xsl:text>,&#x20;org.nr.&#x20;</xsl:text>
      <xsl:call-template name="orgnr">
        <xsl:with-param name="id" select="$aksjeleilighet/@organisasjonsnummer"/>
      </xsl:call-template>
      <xsl:text>,&#x20;leilighetsnummer:&#x20;</xsl:text>
      <xsl:value-of select="$aksjeleilighet/@leilighetsnummer"/>
    </div>
  </xsl:template>

  <xsl:template name="borettsandel">
    <xsl:param name="borettsandel"/>
    <div>
      <xsl:value-of select="$borettsandel/@borettslagnavn"/>
      <xsl:text>,&#x20;org.nr.&#x20;</xsl:text>
      <xsl:call-template name="orgnr">
        <xsl:with-param name="id" select="$borettsandel/@organisasjonsnummer"/>
      </xsl:call-template>
      <xsl:text>,&#x20;andelnr.&#x20;</xsl:text>
      <xsl:value-of select="$borettsandel/@andelsnummer"/>
    </div>
  </xsl:template>

  <xsl:template name="matrikkel">
    <xsl:param name="matrikkel"/>
    <div>
      <xsl:text>Kommune:&#x20;</xsl:text>
      <xsl:value-of select="$matrikkel/@kommunenavn"/>
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="$matrikkel/@kommunenummer"/>
      <xsl:text>,&#x20;gårdsnr.:&#x20;</xsl:text>
      <xsl:value-of select="$matrikkel/@gaardsnummer"/>
      <xsl:text>,&#x20;bruksnr.:&#x20;</xsl:text>
      <xsl:value-of select="$matrikkel/@bruksnummer"/>
      <xsl:if test="not($matrikkel/@seksjonsnummer = '0')">
        <xsl:text>,&#x20;sekjsonsnr.:&#x20;</xsl:text>
        <xsl:value-of select="$matrikkel/@seksjonsnummer"/>
      </xsl:if>
      <xsl:if test="not($matrikkel/@festenummer = '0')">
        <xsl:text>,&#x20;festenr.:&#x20;</xsl:text>
        <xsl:value-of select="$matrikkel/@festenummer"/>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template name="eiendomsnivaatype">
    <xsl:param name="matrikkel"/>
    <xsl:if test="$matrikkel/@eiendomsnivaa = 'E'">Grunneiendom</xsl:if>
    <xsl:if test="$matrikkel/@eiendomsnivaa = 'F'">Festeeiendom</xsl:if>
    <xsl:if test="contains($matrikkel/@eiendomsnivaa, 'F_')">Fremfeste
      <xsl:value-of select="$matrikkel/@eiendomsnivaa"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="adresse">
    <xsl:param name="adresse"/>
    <div>
      <xsl:value-of select="$adresse/gatenavn"/>
      <xsl:text>,&#x20;</xsl:text>
      <xsl:value-of select="$adresse/postnummer"/>
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="$adresse/poststed"/>
    </div>
  </xsl:template>

  <xsl:template name="aktoerer">
    <div class="hovedseksjon">
      <xsl:call-template name="seksjon">
        <xsl:with-param name="tittel" select="'Parter'"/>
      </xsl:call-template>
      <div class="tabell">
        <div class="kropp">
          <div class="rad">
            <div class="celle">
              <div class="innhold rolleoverskrift">
                <xsl:value-of select="'Kjøpere:'"/>
              </div>
            </div>
          </div>
          <div class="rad" style="font-style: italic; ">
            <div class="celle">
              <div class="innhold">Navn</div>
            </div>
            <div class="celle">Id</div>
            <div class="celle">Andel</div>
          </div>
          <xsl:for-each select="parter/rettssubjekt">
            <xsl:if test="contains(./@rolle,'kjoeper')">
              <xsl:call-template name="person_row">
                <xsl:with-param name="rettsubjekt" select="."/>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
          <div class="rad">
            <div class="celle">
              <div class="innhold rolleoverskrift">
                <xsl:value-of select="'Selgere:'"/>
              </div>
            </div>
          </div>
          <div class="rad" style="font-style: italic; ">
            <div class="celle">
              <div class="innhold">Navn</div>
            </div>
            <div class="celle">Id</div>
            <div class="celle">Andel</div>
          </div>
          <xsl:for-each select="parter/rettssubjekt">
            <xsl:if test="contains(./@rolle,'selger')">
              <xsl:call-template name="person_row">
                <xsl:with-param name="rettsubjekt" select="."/>
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="person_oneliner">
    <xsl:param name="rettsubjekt"/>
    <div>
      <xsl:if test="$rettsubjekt/person">
        <xsl:value-of select="$rettsubjekt/person/fornavn"/>
        <xsl:text>&#x20;</xsl:text>
        <xsl:value-of select="$rettsubjekt/person/etternavn"/>,
        <xsl:text>fnr.</xsl:text>
        <xsl:call-template name="foedselsnr">
          <xsl:with-param name="id" select="$rettsubjekt/person/@id"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$rettsubjekt/organisasjon">
        <xsl:value-of select="$rettsubjekt/organisasjon/navn"/>,
        <xsl:text>org.nr.</xsl:text>
        <xsl:call-template name="orgnr">
          <xsl:with-param name="id" select="$rettsubjekt/organisasjon/@id"/>
        </xsl:call-template>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template name="person_row">
    <xsl:param name="rettsubjekt"/>
    <div class="rad">
      <xsl:if test="$rettsubjekt/person">
        <div class="celle">
          <div class="innhold">
            <xsl:value-of select="$rettsubjekt/person/fornavn"/>
            <xsl:text>&#x20;</xsl:text>
            <xsl:value-of select="$rettsubjekt/person/etternavn"/>
          </div>
        </div>
        <div class="celle">
          <xsl:call-template name="foedselsnr">
            <xsl:with-param name="id" select="$rettsubjekt/person/@id"/>
          </xsl:call-template>
        </div>
      </xsl:if>
      <xsl:if test="$rettsubjekt/organisasjon">
        <div class="celle">
          <div class="innhold">
            <xsl:value-of select="$rettsubjekt/organisasjon/foretaksnavn"/>
          </div>
        </div>
        <div class="celle">
          <xsl:call-template name="orgnr">
            <xsl:with-param name="id" select="$rettsubjekt/organisasjon/@id"/>
          </xsl:call-template>
        </div>
      </xsl:if>
      <div class="celle">
        <xsl:value-of select="$rettsubjekt/andel/@teller"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$rettsubjekt/andel/@nevner"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="kontaktperson">
    <xsl:param name="kontakt"/>
    <xsl:param name="referanse"/>
    <div>
      <xsl:value-of select="$kontakt/navn"/>
    </div>
    <div>
      <div>
        <a href="tel:{$kontakt/telefon}">
          <xsl:value-of select="format-number( number($kontakt/telefon), '## ## ## ##', 'nb-no-space')"/>
        </a>
        (telefon)
      </div>
      <div>
        <a href="tel:{$kontakt/telefonDirekte}">
          <xsl:value-of select="format-number( number($kontakt/telefonDirekte), '## ## ## ##', 'nb-no-space')"/>
        </a>
        <xsl:text>&#x20;(direkte)</xsl:text>
      </div>
      <div>
        <a href="mailto:{$kontakt/epost}?Subject=Angående%20kjøpekontrakt%20med%20oppdragsnummer%20{$referanse}">
          <xsl:value-of select="$kontakt/epost"/>
        </a>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="orgnr">
    <xsl:param name="id"/>
    <xsl:if test="$id">
      <xsl:value-of select="substring( format-number($id, '000000000'),1,3)"/>
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="substring( format-number($id, '000000000'), 4,3)"/>
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="substring( format-number($id, '000000000'), 7,3)"/>
      <a href="https://w2.brreg.no/enhet/sok/detalj.jsp?orgnr={$id}" target="_blank" style="text-decoration: none;">
        <xsl:text>&#10697;</xsl:text>
      </a>
    </xsl:if>
  </xsl:template>

  <xsl:template name="foedselsnr">
    <xsl:param name="id"/>
    <xsl:if test="$id">
      <xsl:value-of select="substring( format-number($id, '00000000000'),1,6)"/>
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="substring( format-number($id, '00000000000'), 7,5)"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="overskrift">
    <h1 class="overskrift">Kjøpekontrakt</h1>
  </xsl:template>

  <xsl:template name="seksjon">
    <xsl:param name="tittel"/>
    <div class="seksjonsoverskrift">
      <xsl:value-of select="$tittel"/>
    </div>
  </xsl:template>

  <xsl:template name="info">
    <xsl:text>Linker:&#x20;</xsl:text>
    <a href="{salgsoppgave}" target="_blank">Salgsoppgave</a>
    <xsl:text>&#x20;|&#x20;</xsl:text>
    <a href="{nettannonse}" target="_blank">Nettannonse</a>
  </xsl:template>

  <xsl:template name="tiddato">
    <xsl:param name="dato"/>
    <xsl:value-of select="substring($dato, 9, 2)"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="substring($dato, 6, 2)"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="substring($dato, 1, 4)"/>
    <xsl:text>&#x20;kl.&#x20;</xsl:text>
    <xsl:value-of select="substring($dato, 12, 8)"/>
  </xsl:template>

  <xsl:template name="dato">
    <xsl:param name="dato"/>
    <xsl:value-of select="substring($dato, 9, 2)"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="substring($dato, 6, 2)"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="substring($dato, 1, 4)"/>
  </xsl:template>

  <xsl:template name="formatNumber">
    <xsl:param name="prefix"/>
    <xsl:param name="numericValue" select="."/>
    <xsl:if test="string-length($prefix) &gt; 0">
      <xsl:value-of select="$prefix"/>
    </xsl:if>
    <xsl:value-of select="format-number( number($numericValue), '### ### ### ###,00', 'nb-no-space')"/>
  </xsl:template>

  <xsl:template name="footer">
    <div style="padding-bottom:16px;">
      <small style="float:right;">
        DSBM-kjøpekontrakt opprettet
        <xsl:call-template name="tiddato">
          <xsl:with-param name="dato" select="metadata/opprettet"/>
        </xsl:call-template>
      </small>
    </div>
  </xsl:template>

</xsl:stylesheet>