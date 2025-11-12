require "spec_helper"

RSpec.describe Metanorma::Bipm do
  it "processes default metadata" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee-en: TC
      :committee-fr: CT
      :committee-acronym: TCA
      :committee-number: 1
      :committee-type: A
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-acronym: WGA
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: en
      :title-en: Main Title
      :title-fr: Chef Title
      :title-cover-en: Main Title (SI)
      :title-cover-fr: Chef Title (SI)
      :title-appendix-en: Main Title (SI)
      :title-appendix-fr: Chef Title (SI)
      :title-annex-en: Main Title (SI) Annex
      :title-annex-fr: Chef Title (SI) Annexe
      :title-part-en: Part
      :title-part-fr: Partie
      :title-subpart-en: Subpart
      :title-subpart-fr: Subpartie
      :title-provenance-en: Provenance-en
      :title-provenance-fr: Provenance-fr
      :partnumber: 2
      :appendix-id: ABC
      :annex-id: DEF
      :security: Client Confidential
      :comment-period-from: 2050-01-01
      :comment-period-to: 2051-01-01
      :supersedes: A
      :superseded-by: B
      :obsoleted-date: C
      :implemented-date: D
      :si-aspect: A_e_deltanu
      :meeting-note: Note
      :fullname: Andrew Yacoot
      :affiliation: NPL
      :fullname_2: Ulrich Kuetgens
      :affiliation_2: PTB
      :fullname_3: Enrico Massa
      :affiliation_3: INRIM
      :fullname_4: Ronald Dixson
      :affiliation_4: NIST
      :role_4: WG-N co-chair
      :fullname_5: Harald Bosse
      :affiliation_5: PTB
      :role_5: WG-N co-chair
      :fullname_6: Andrew Yacoot
      :affiliation_6: NPL
      :role_6: WG-N chair
      :supersedes-date: 2018-06-11
      :supersedes-draft: 1.0
      :supersedes-edition: 1.0
      :supersedes-date_2: 2019-06-11
      :supersedes-draft_2: 2.0
      :supersedes-edition_2: 2.0
      :supersedes-date_3: 2019-06-11
      :supersedes-draft_3: 3.0
    INPUT

    output = Canon.format_xml(<<~"OUTPUT")
      <?xml version="1.0" encoding="UTF-8"?>
        <metanorma type="semantic" version="#{Metanorma::Bipm::VERSION}" xmlns="https://www.metanorma.org/ns/standoc" flavor="bipm">
          <bibdata type="standard">
            <title language="en" type="title-main">Main Title</title>
            <title language="en" type="title-cover">Main Title (SI)</title>
            <title language="en" type="title-appendix">Main Title (SI)</title>
            <title language="en" type="title-annex">Main Title (SI) Annex</title>
            <title language="en" type="title-part">Part</title>
            <title language="en" type="title-subpart">Subpart</title>
            <title language="en" type="title-provenance">Provenance-en</title>
            <title language="fr" type="title-main">Chef Title</title>
            <title language="fr" type="title-cover">Chef Title (SI)</title>
            <title language="fr" type="title-appendix">Chef Title (SI)</title>
            <title language="fr" type="title-annex">Chef Title (SI) Annexe</title>
            <title language="fr" type="title-part">Partie</title>
            <title language="fr" type="title-subpart">Subpartie</title>
            <title language="fr" type="title-provenance">Provenance-fr</title>
            <docidentifier primary="true" type="BIPM">BIPM 1000-2 AABC.DEF</docidentifier>
            <docidentifier type="BIPM-parent-document">BIPM 1000</docidentifier>
            <docnumber>1000</docnumber>
            <date type="implemented">
              <on>D</on>
            </date>
            <date type="obsoleted">
              <on>C</on>
            </date>
            <contributor>
              <role type="author"/>
              <organization>
                <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
              </organization>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Andrew Yacoot</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NPL</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Ulrich Kuetgens</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>PTB</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Enrico Massa</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>INRIM</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="editor">WG-N co-chair</role>
              <person>
                <name>
                  <completename>Ronald Dixson</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NIST</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="editor">WG-N co-chair</role>
              <person>
                <name>
                  <completename>Harald Bosse</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>PTB</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="editor">WG-N chair</role>
              <person>
                <name>
                  <completename>Andrew Yacoot</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NPL</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
      <contributor>
         <role type="author">
            <description>committee</description>
         </role>
         <organization>
            <name>Bureau International des Poids et Mesures</name>
            <subdivision type="Committee" subtype="A">
               <name language="en">TC</name>
               <name language="fr">CT</name>
               <identifier>TCA</identifier>
               <identifier type="full">TCA/WGA</identifier>
            </subdivision>
           <subdivision type="Workgroup" subtype="C">
              <name>WG</name>
              <identifier>WGA</identifier>
           </subdivision>
         </organization>
      </contributor>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
              </organization>
            </contributor>
            <edition>2</edition>
            <version>
              <revision-date>2000-01-01</revision-date>
              <draft>3.4</draft>
            </version>
            <language>en</language>
            <script>Latn</script>
            <status>
              <stage>working-draft</stage>
              <iteration>3</iteration>
            </status>
            <copyright>
              <from>2001</from>
              <owner>
                <organization>
                  <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
                  <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
                </organization>
              </owner>
            </copyright>
            <relation type="supersedes">
              <bibitem>
                <title>--</title>
                <docidentifier>A</docidentifier>
              </bibitem>
            </relation>
            <relation type="supersededBy">
              <bibitem>
                <title>--</title>
                <docidentifier>B</docidentifier>
              </bibitem>
            </relation>
            <relation type="supersedes">
              <bibitem>
                <date type="published">2018-06-11</date>
                <edition>1.0</edition>
                <version>
                  <draft>1.0</draft>
                </version>
              </bibitem>
            </relation>
            <relation type="supersedes">
              <bibitem>
                <date type="published">2019-06-11</date>
                <edition>2.0</edition>
                <version>
                  <draft>2.0</draft>
                </version>
              </bibitem>
            </relation>
            <relation type="supersedes">
              <bibitem>
                <date type="circulated">2019-06-11</date>
                <version>
                  <draft>3.0</draft>
                </version>
              </bibitem>
            </relation>
            <ext>
              <doctype>brochure</doctype>
              <flavor>bipm</flavor>
              <comment-period>
                <from>2050-01-01</from>
                <to>2051-01-01</to>
              </comment-period>
              <si-aspect>A_e_deltanu</si-aspect>
              <meeting-note>Note</meeting-note>
              <structuredidentifier>
                <docnumber>1000</docnumber>
                <part>2</part>
                <appendix>ABC</appendix>
                <annexid>DEF</annexid>
              </structuredidentifier>
            </ext>
          </bibdata>
                   <metanorma-extension>
      <semantic-metadata>
         <stage-published>false</stage-published>
      </semantic-metadata>
             <presentation-metadata>
               <name>TOC Heading Levels</name>
               <value>2</value>
             </presentation-metadata>
             <presentation-metadata>
               <name>HTML TOC Heading Levels</name>
               <value>2</value>
             </presentation-metadata>
             <presentation-metadata>
               <name>DOC TOC Heading Levels</name>
               <value>2</value>
             </presentation-metadata>
             <presentation-metadata>
               <name>PDF TOC Heading Levels</name>
               <value>2</value>
             </presentation-metadata>
           </metanorma-extension>
          #{boilerplate('en').gsub(/#{Time.now.year}/, '2001')}
          <sections/>
        </metanorma>
    OUTPUT

    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "processes default metadata in French, no components to id" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee-en: TC
      :committee-fr: CT
      :committee-number: 1
      :committee-type: A
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: fr
      :title-en: Main Title
      :title-fr: Chef Title
      :title-cover-en: Main Title (SI)
      :title-cover-fr: Chef Title (SI)
      :security: Client Confidential
      :comment-period-from: 2050-01-01
      :comment-period-to: 2051-01-01
      :supersedes: A
      :superseded-by: B
      :obsoleted-date: C
      :implemented-date: D
    INPUT

    output = Canon.format_xml(<<~"OUTPUT")
      <?xml version="1.0" encoding="UTF-8"?>
      <metanorma xmlns="https://www.metanorma.org/ns/standoc"  version="#{Metanorma::Bipm::VERSION}" type="semantic" flavor="bipm">
      <bibdata type="standard">
        <title language='en' type='title-main'>Main Title</title>
        <title language='en' type='title-cover'>Main Title (SI)</title>
        <title language='fr' type='title-main'>Chef Title</title>
        <title language='fr' type='title-cover'>Chef Title (SI)</title>
          <docidentifier primary="true" type="BIPM">BIPM 1000</docidentifier>
          <docnumber>1000</docnumber>
          <date type='implemented'>
          <on>D</on>
        </date>
        <date type='obsoleted'>
          <on>C</on>
        </date>
          <contributor>
            <role type="author"/>
            <organization>
              <name>#{Metanorma::Bipm.configuration.organization_name_long['fr']}</name>
              <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
            </organization>
          </contributor>
      <contributor>
         <role type="author">
            <description>committee</description>
         </role>
         <organization>
            <name>Bureau international des poids et mesures</name>
            <subdivision type="Committee" subtype="A">
               <name language="en">TC</name>
               <name language="fr">CT</name>
               <identifier>A 1</identifier>
               <identifier type="full">A 1/C 3</identifier>
            </subdivision>
            <subdivision type="Workgroup" subtype="C">
               <name>WG</name>
               <identifier>C 3</identifier>
            </subdivision>
         </organization>
      </contributor>
          <contributor>
            <role type="publisher"/>
            <organization>
              <name>#{Metanorma::Bipm.configuration.organization_name_long['fr']}</name>
              <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
            </organization>
          </contributor>
          <edition>2</edition>
          <version>
            <revision-date>2000-01-01</revision-date>
            <draft>3.4</draft>
          </version>
          <language>fr</language>
          <script>Latn</script>
          <status>
            <stage>working-draft</stage>
            <iteration>3</iteration>
          </status>
          <copyright>
            <from>2001</from>
            <owner>
              <organization>
                <name>#{Metanorma::Bipm.configuration.organization_name_long['fr']}</name>
                <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
              </organization>
            </owner>
          </copyright>
          <relation type='supersedes'>
            <bibitem>
              <title>--</title>
              <docidentifier>A</docidentifier>
            </bibitem>
          </relation>
          <relation type='supersededBy'>
            <bibitem>
              <title>--</title>
              <docidentifier>B</docidentifier>
            </bibitem>
          </relation>
          <ext>
            <doctype>brochure</doctype>
            <flavor>bipm</flavor>
            <comment-period>
              <from>2050-01-01</from>
              <to>2051-01-01</to>
            </comment-period>
            <structuredidentifier>
              <docnumber>1000</docnumber>
            </structuredidentifier>
          </ext>
        </bibdata>
                 <metanorma-extension>
      <semantic-metadata>
         <stage-published>false</stage-published>
      </semantic-metadata>
           <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>PDF TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
         </metanorma-extension>
        #{boilerplate('fr').gsub(/#{Time.now.year}/, '2001')}
        <sections/>
      </metanorma>
    OUTPUT

    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end
  
  it "processes default metadata for JCTLM" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :appendix-id: II
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee-en: TC
      :committee-fr: CT
      :committee-number: 1
      :committee-type: A
      :committee-acronym: JCTLM
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: fr
      :title-en: Main Title
      :title-fr: Chef Title
      :title-cover-en: Main Title (SI)
      :title-cover-fr: Chef Title (SI)
      :partnumber: 2.1
      :security: Client Confidential
      :appendix-id: ABC
      :comment-period-from: 2050-01-01
      :comment-period-to: 2051-01-01
      :supersedes: A
      :superseded-by: B
      :obsoleted-date: C
      :implemented-date: D
    INPUT
    output = Canon.format_xml(<<~"OUTPUT")
      <metanorma xmlns="https://www.metanorma.org/ns/standoc"  version="#{Metanorma::Bipm::VERSION}" type="semantic" flavor="bipm">
         <bibdata type="standard">
           <title language="en" type="title-main">Main Title</title>
           <title language="en" type="title-cover">Main Title (SI)</title>
           <title language="fr" type="title-main">Chef Title</title>
           <title language="fr" type="title-cover">Chef Title (SI)</title>
           <docidentifier primary="true" type="BIPM">BIPM 1000-2.1 AABC</docidentifier>
          <docidentifier type="BIPM-parent-document">BIPM 1000</docidentifier>
           <docnumber>1000</docnumber>
           <date type="implemented">
             <on>D</on>
           </date>
           <date type="obsoleted">
             <on>C</on>
           </date>
           <contributor>
             <role type="author"/>
             <organization>
               <name>Bureau international des poids et mesures</name>
               <abbreviation>BIPM</abbreviation>
             </organization>
           </contributor>
      <contributor>
         <role type="author">
            <description>committee</description>
         </role>
         <organization>
            <name>Bureau international des poids et mesures</name>
            <subdivision type="Committee" subtype="A">
               <name language="en">TC</name>
               <name language="fr">CT</name>
                <identifier>JCTLM</identifier>
                <identifier type="full">JCTLM/C 3</identifier>
            </subdivision>
            <subdivision type="Workgroup" subtype="C">
               <name>WG</name>
               <identifier>C 3</identifier>
            </subdivision>
         </organization>
      </contributor>
           <contributor>
             <role type="publisher"/>
             <organization>
               <name>Bureau international des poids et mesures</name>
               <abbreviation>BIPM</abbreviation>
             </organization>
           </contributor>
           <edition>2</edition>
           <version>
             <revision-date>2000-01-01</revision-date>
             <draft>3.4</draft>
           </version>
           <language>fr</language>
           <script>Latn</script>
           <status>
             <stage>working-draft</stage>
             <iteration>3</iteration>
           </status>
           <copyright>
             <from>2001</from>
             <owner>
               <organization>
                 <name>Bureau international des poids et mesures</name>
                 <abbreviation>BIPM</abbreviation>
               </organization>
             </owner>
           </copyright>
           <relation type="supersedes">
             <bibitem>
               <title>--</title>
               <docidentifier>A</docidentifier>
             </bibitem>
           </relation>
           <relation type="supersededBy">
             <bibitem>
               <title>--</title>
               <docidentifier>B</docidentifier>
             </bibitem>
           </relation>
           <ext>
             <doctype>brochure</doctype>
            <flavor>bipm</flavor>
             <comment-period>
               <from>2050-01-01</from>
               <to>2051-01-01</to>
             </comment-period>
             <structuredidentifier>
               <docnumber>1000</docnumber>
               <part>2.1</part>
               <appendix>ABC</appendix>
             </structuredidentifier>
           </ext>
         </bibdata>
         <metanorma-extension>
      <semantic-metadata>
         <stage-published>false</stage-published>
      </semantic-metadata>
           <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>PDF TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
         </metanorma-extension>
         <boilerplate>
           <copyright-statement>
             <clause id="_" obligation="normative">
               <p id="_" align="center">© Bureau international des poids et mesures 2001 tous droits réservés</p>
             </clause>
           </copyright-statement>
           <license-statement>
             <clause id="_" obligation="normative">
               <title id="_">Note concernant les droits d’auteur</title>
               <p id="_">Ce document est distribué selon les termes et conditions de la licence Creative Commons Attribution 4.0 International (<link target="http://creativecommons.org/licenses/by/4.0/:"/>), qui permet l’utilisation sans restriction, la distribution et la reproduction sur quelque support que soit, sous réserve de mentionner dûment l’auteur ou les auteurs originaux ainsi que la source de l’œuvre, d’intégrer un lien vers la licence Creative Commons et d’indiquer si des modifications ont été effectuées.</p>
             </clause>
           </license-statement>
           <feedback-statement>
             <p id="_">BIPM<br/>
       Pavillon de Breteuil<br/>
       F-92312 Sèvres Cedex<br/>
       FRANCE</p>
           </feedback-statement>
         </boilerplate>
         <sections/>
       </metanorma>
    OUTPUT

    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "processes default metadata for JCGM" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee-en: TC
      :committee-fr: CT
      :committee-number: 1
      :committee-type: A
      :committee-acronym: JCGM
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: fr
      :title-en: Main Title
      :title-fr: Chef Title
      :title-cover-en: Main Title (SI)
      :title-cover-fr: Chef Title (SI)
      :partnumber: 2.1
      :security: Client Confidential
      :appendix-id: ABC
      :comment-period-from: 2050-01-01
      :comment-period-to: 2051-01-01
      :supersedes: A
      :superseded-by: B
      :obsoleted-date: C
      :implemented-date: D
    INPUT

    output = Canon.format_xml(<<~"OUTPUT")
        <?xml version="1.0" encoding="UTF-8"?>
        <metanorma xmlns="https://www.metanorma.org/ns/standoc"  version="#{Metanorma::Bipm::VERSION}" type="semantic" flavor="bipm">
        <bibdata type='standard'>
          <title language='en' type='title-main'>Main Title</title>
          <title language='en' type='title-cover'>Main Title (SI)</title>
          <title language='fr' type='title-main'>Chef Title</title>
          <title language='fr' type='title-cover'>Chef Title (SI)</title>
          <docidentifier primary="true" type="BIPM">JCGM 1000-2.1 AABC</docidentifier>
          <docidentifier type="BIPM-parent-document">JCGM 1000</docidentifier>
          <docnumber>1000</docnumber>
          <date type='implemented'>
            <on>D</on>
          </date>
          <date type='obsoleted'>
            <on>C</on>
          </date>
          <contributor>
            <role type='author'/>
            <organization>
              <name>Bureau international des poids et mesures</name>
              <abbreviation>BIPM</abbreviation>
            </organization>
          </contributor>
                <contributor>
         <role type="author">
            <description>committee</description>
         </role>
         <organization>
            <name>Bureau international des poids et mesures</name>
            <subdivision type="Committee" subtype="A">
               <name language="en">TC</name>
               <name language="fr">CT</name>
               <identifier>JCGM</identifier>
               <identifier type="full">JCGM/C 3</identifier>
            </subdivision>
           <subdivision type="Workgroup" subtype="C">
              <name>WG</name>
              <identifier>C 3</identifier>
           </subdivision>
         </organization>
      </contributor>
          <contributor>
            <role type='publisher'/>
            <organization>
              <name>Bureau international des poids et mesures</name>
              <abbreviation>BIPM</abbreviation>
            </organization>
          </contributor>
          <edition>2</edition>
          <version>
            <revision-date>2000-01-01</revision-date>
            <draft>3.4</draft>
          </version>
          <language>fr</language>
          <script>Latn</script>
          <status>
            <stage>working-draft</stage>
            <iteration>3</iteration>
          </status>
          <copyright>
            <from>2001</from>
            <owner>
              <organization>
                <name>Bureau international des poids et mesures</name>
                <abbreviation>BIPM</abbreviation>
              </organization>
            </owner>
          </copyright>
          <relation type='supersedes'>
            <bibitem>
              <title>--</title>
              <docidentifier>A</docidentifier>
            </bibitem>
          </relation>
          <relation type='supersededBy'>
            <bibitem>
              <title>--</title>
              <docidentifier>B</docidentifier>
            </bibitem>
          </relation>
          <ext>
            <doctype>brochure</doctype>
            <flavor>bipm</flavor>
            <comment-period>
              <from>2050-01-01</from>
              <to>2051-01-01</to>
            </comment-period>
            <structuredidentifier>
              <docnumber>1000</docnumber>
              <part>2.1</part>
              <appendix>ABC</appendix>
            </structuredidentifier>
          </ext>
        </bibdata>
                 <metanorma-extension>
      <semantic-metadata>
         <stage-published>false</stage-published>
      </semantic-metadata>
           <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
             <name>PDF TOC Heading Levels</name>
             <value>2</value>
           </presentation-metadata>
         </metanorma-extension>
        #{boilerplate('jcgm').gsub(/#{Time.now.year}/, '2001')}
        <sections/>
      </metanorma>
    OUTPUT

    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "processes figures" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [[id]]
      .Figure 1
      ....
      This is a literal

      Amen
      ....
    INPUT

    output = Canon.format_xml(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections>
          <figure id="_" anchor="id">
            <name id="_">Figure 1</name>
            <pre id="_">This is a literal

              Amen</pre>
          </figure>
        </sections>
      </metanorma>
    OUTPUT

    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = Canon.format_xml(<<~"OUTPUT")
      #{BLANK_HDR}
        <preface>
          <foreword id="_" obligation="informative">
            <title id="_">Foreword</title>
            <p id="_">This is a preamble</p>
          </foreword>
        </preface>
        <sections>
          <clause id="_" obligation="normative">
            <title id="_">Section 1</title>
          </clause>
        </sections>
      </metanorma>
    OUTPUT

    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "uses xref flags" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [[a]]
      == Section 1
      <<a>>
      <<a,pagenumber%>>
      <<a,nosee%>>
      <<a,nopage%>>
    INPUT

    output = Canon.format_xml(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections>
          <clause id="_" anchor="a" obligation='normative'>
            <title id="_">Section 1</title>
            <p id='_'>
              <xref target='a'/>
              <xref target='a' pagenumber='true'/>
              <xref target='a' nosee='true'/>
              <xref target='a' nopage='true'/>
            </p>
          </clause>
        </sections>
      </metanorma>
    OUTPUT

    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    Asciidoctor.convert(input, *OPTIONS)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Times New Roman;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Times New Roman;]m)
  end

  it "uses specified fonts" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :body-font: Zapf Chancery
      :header-font: Comic Sans
      :monospace-font: Andale Mono
      :no-pdf:
    INPUT

    Asciidoctor.convert(input, *OPTIONS)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Comic Sans;]m)
  end

  it "has unnumbered clauses" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [%unnumbered]
      == Clause

      [appendix%unnumbered]
      == Appendix
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
        <sections>
          <clause id='_' unnumbered='true' obligation='normative'>
            <title id="_">Clause</title>
          </clause>
        </sections>
        <annex id='_' obligation='normative' unnumbered="true">
          <title id="_">Appendix</title>
        </annex>
      </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes the start attribute on ordered lists" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [keep-with-next=true,keep-lines-together=true,start=4]
      [loweralpha]
      . First
      . Second
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
        <sections>
          <ol keep-with-next='true' keep-lines-together='true' id='_' type='alphabet' start='4'>
            <li>
              <p id='_'>First</p>
            </li>
            <li>
              <p id='_'>Second</p>
            </li>
          </ol>
        </sections>
      </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes sections" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
      .Foreword

      Text

      [abstract]
      == Abstract

      Text

      == Acknowledgements

      [.preface]
      == Dedication

      == Introduction

      == Scope

      Text

      == Normative References

      [heading=Terms and definitions]
      == Photometric units

      === Term1

      == Terms, Definitions, Symbols and Abbreviated Terms

      [.nonterm]
      === Introduction

      ==== Intro 1

      === Intro 2

      [.nonterm]
      ==== Intro 3

      === Intro 4

      ==== Intro 5

      ===== Term1

      === Normal Terms

      ==== Term2

      === Symbols and Abbreviated Terms

      [.nonterm]
      ==== General

      ==== Symbols

      == Abbreviated Terms

      == Clause 4
      === Introduction

      === Clause 4.2

      === {blank}

      == Terms and Definitions

      [appendix]
      == Annex

      === Annex A.1

      == Bibliography

      === Bibliography Subsection
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR.sub(%r{</script>}, '</script><abstract><p>Text</p></abstract>')}
          <preface>
             <abstract id="_">
                <title id="_">Abstract</title>
                <p id="_">Text</p>
             </abstract>
             <foreword id="_" obligation="informative">
                <title id="_">Foreword</title>
                <p id="_">Text</p>
             </foreword>
             <clause id="_" obligation="informative">
                <title id="_">Dedication</title>
             </clause>
             <acknowledgements id="_" obligation="informative">
                <title id="_">Acknowledgements</title>
             </acknowledgements>
          </preface>
          <sections>
             <clause id="_" obligation="normative">
                <title id="_">Introduction</title>
             </clause>
             <clause id="_" type="scope" obligation="normative">
                <title id="_">Scope</title>
                <p id="_">Text</p>
             </clause>
             <terms id="_" obligation="normative">
                <title id="_">Photometric units</title>
                <p id="_">For the purposes of this document, the following terms and definitions apply.</p>
                <term id="_" anchor="term-Term1">
                   <preferred>
                      <expression>
                         <name>Term1</name>
                      </expression>
                   </preferred>
                </term>
             </terms>
             <clause id="_" obligation="normative" type="terms">
                <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
                <p id="_">For the purposes of this document, the following terms and definitions apply.</p>
                <clause id="_" obligation="normative">
                   <title id="_">Introduction</title>
                   <clause id="_" obligation="normative">
                      <title id="_">Intro 1</title>
                   </clause>
                </clause>
                <terms id="_" obligation="normative">
                   <title id="_">Intro 2</title>
                   <clause id="_" obligation="normative">
                      <title id="_">Intro 3</title>
                   </clause>
                </terms>
                <clause id="_" obligation="normative" type="terms">
                   <title id="_">Intro 4</title>
                   <terms id="_" obligation="normative">
                      <title id="_">Intro 5</title>
                      <term id="_" anchor="term-Term1-1">
                         <preferred>
                            <expression>
                               <name>Term1</name>
                            </expression>
                         </preferred>
                      </term>
                   </terms>
                </clause>
                <terms id="_" obligation="normative">
                   <title id="_">Normal Terms</title>
                   <term id="_" anchor="term-Term2">
                      <preferred>
                         <expression>
                            <name>Term2</name>
                         </expression>
                      </preferred>
                   </term>
                </terms>
                <definitions id="_" obligation="normative">
                   <title id="_">Symbols and Abbreviated Terms</title>
                   <clause id="_" obligation="normative">
                      <title id="_">General</title>
                   </clause>
                   <definitions id="_" type="symbols" obligation="normative">
                      <title id="_">Symbols</title>
                   </definitions>
                </definitions>
             </clause>
             <definitions id="_" type="abbreviated_terms" obligation="normative">
                <title id="_">Abbreviated Terms</title>
             </definitions>
             <clause id="_" obligation="normative">
                <title id="_">Clause 4</title>
                <clause id="_" obligation="normative">
                   <title id="_">Introduction</title>
                </clause>
                <clause id="_" obligation="normative">
                   <title id="_">Clause 4.2</title>
                </clause>
                <clause id="_" obligation="normative">
       </clause>
             </clause>
             <terms id="_" obligation="normative">
                <title id="_">Terms and Definitions</title>
                <p id="_">No terms and definitions are listed in this document.</p>
             </terms>
          </sections>
          <annex id="_" obligation="normative">
             <title id="_">Annex</title>
             <clause id="_" obligation="normative">
                <title id="_">Annex A.1</title>
             </clause>
          </annex>
          <bibliography>
             <references id="_" normative="true" obligation="informative">
                <title id="_">Normative References</title>
                <p id="_">There are no normative references in this document.</p>
             </references>
             <clause id="_" obligation="informative">
                <title id="_">Bibliography</title>
                <references id="_" normative="false" obligation="informative">
                   <title id="_">Bibliography Subsection</title>
                </references>
             </clause>
          </bibliography>
       </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes sections in JCGM" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR.sub(':novalid:', ":novalid:\n:committee-acronym: JCGM")}
      .Foreword

      Text

      [abstract]
      == Abstract

      Text

      == Introduction

      === Introduction Subsection

      === {blank}

      == Acknowledgements

      [.preface]
      == Dedication

      == Scope

      Text

      == Normative References

      [heading=Terms and definitions]
      == Photometric units

      === Term1

      == Terms, Definitions, Symbols and Abbreviated Terms

      [.nonterm]
      === Introduction

      ==== Intro 1

      === Intro 2

      [.nonterm]
      ==== Intro 3

      === Intro 4

      ==== Intro 5

      ===== Term1

      === Normal Terms

      ==== Term2

      === Symbols and Abbreviated Terms

      [.nonterm]
      ==== General

      ==== Symbols

      == Abbreviated Terms

      == Clause 4
      === Introduction

      === Clause 4.2

      === {blank}

      == Terms and Definitions

      [appendix]
      == Annex

      === Annex A.1

      == Bibliography

      === Bibliography Subsection
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR.sub(%r{</script>}, '</script><abstract><p>Text</p></abstract>').sub(%r{<boilerplate>.*</boilerplate>}m, '')}
          <preface>
             <abstract id="_">
                <title id="_">Abstract</title>
                <p id="_">Text</p>
             </abstract>
             <foreword id="_" obligation="informative">
                <title id="_">Foreword</title>
                <p id="_">Text</p>
             </foreword>
             <introduction id="_" obligation="informative">
                <title id="_">Introduction</title>
                <clause id="_" obligation="informative">
                   <title id="_">Introduction Subsection</title>
                </clause>
                <clause id="_" obligation="informative"/>
             </introduction>
             <clause id="_" obligation="informative">
                <title id="_">Dedication</title>
             </clause>
             <acknowledgements id="_" obligation="informative">
                <title id="_">Acknowledgements</title>
             </acknowledgements>
          </preface>
          <sections>
             <clause id="_" type="scope" obligation="normative">
                <title id="_">Scope</title>
                <p id="_">Text</p>
             </clause>
             <terms id="_" obligation="normative">
                <title id="_">Photometric units</title>
                <p id="_">For the purposes of this document, the following terms and definitions apply.</p>
                <term id="_" anchor="term-Term1">
                   <preferred>
                      <expression>
                         <name>Term1</name>
                      </expression>
                   </preferred>
                </term>
             </terms>
             <clause id="_" obligation="normative" type="terms">
                <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
                <p id="_">For the purposes of this document, the following terms and definitions apply.</p>
                <clause id="_" obligation="normative">
                   <title id="_">Introduction</title>
                   <clause id="_" obligation="normative">
                      <title id="_">Intro 1</title>
                   </clause>
                </clause>
                <terms id="_" obligation="normative">
                   <title id="_">Intro 2</title>
                   <clause id="_" obligation="normative">
                      <title id="_">Intro 3</title>
                   </clause>
                </terms>
                <clause id="_" obligation="normative" type="terms">
                   <title id="_">Intro 4</title>
                   <terms id="_" obligation="normative">
                      <title id="_">Intro 5</title>
                      <term id="_" anchor="term-Term1-1">
                         <preferred>
                            <expression>
                               <name>Term1</name>
                            </expression>
                         </preferred>
                      </term>
                   </terms>
                </clause>
                <terms id="_" obligation="normative">
                   <title id="_">Normal Terms</title>
                   <term id="_" anchor="term-Term2">
                      <preferred>
                         <expression>
                            <name>Term2</name>
                         </expression>
                      </preferred>
                   </term>
                </terms>
                <definitions id="_" obligation="normative">
                   <title id="_">Symbols and Abbreviated Terms</title>
                   <clause id="_" obligation="normative">
                      <title id="_">General</title>
                   </clause>
                   <definitions id="_" type="symbols" obligation="normative">
                      <title id="_">Symbols</title>
                   </definitions>
                </definitions>
             </clause>
             <definitions id="_" type="abbreviated_terms" obligation="normative">
                <title id="_">Abbreviated Terms</title>
             </definitions>
             <clause id="_" obligation="normative">
                <title id="_">Clause 4</title>
                <clause id="_" obligation="normative">
                   <title id="_">Introduction</title>
                </clause>
                <clause id="_" obligation="normative">
                   <title id="_">Clause 4.2</title>
                </clause>
                <clause id="_" obligation="normative"/>
             </clause>
             <terms id="_" obligation="normative">
                <title id="_">Terms and Definitions</title>
                <p id="_">No terms and definitions are listed in this document.</p>
             </terms>
          </sections>
          <annex id="_" obligation="normative">
             <title id="_">Annex</title>
             <clause id="_" obligation="normative">
                <title id="_">Annex A.1</title>
             </clause>
          </annex>
          <bibliography>
             <references id="_" normative="true" obligation="informative">
                <title id="_">Normative References</title>
                <p id="_">There are no normative references in this document.</p>
             </references>
             <clause id="_" obligation="informative">
                <title id="_">Bibliography</title>
                <references id="_" normative="false" obligation="informative">
                   <title id="_">Bibliography Subsection</title>
                </references>
             </clause>
          </bibliography>
       </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS)))
      .sub(%r{<boilerplate>.*</boilerplate>}m, ""))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "customises italicisation of MathML" do
    input = <<~INPUT
      = Document title
      Author
      :stem:

      [stem]
      ++++
      <math xmlns='http://www.w3.org/1998/Math/MathML'>
        <mi>A</mi>
        <mo>+</mo>
        <mi>a</mi>
        <mo>+</mo>
        <mi>Α</mi>
        <mo>+</mo>
        <mi>α</mi>
        <mo>+</mo>
        <mi>AB</mi>
      </math>
      ++++
    INPUT

    output = <<~OUTPUT
      #{BLANK_HDR}
        <sections>
          <formula id='_'>
            <stem type='MathML' block="true">
              <math xmlns='http://www.w3.org/1998/Math/MathML'>
                <mi mathvariant='normal'>A</mi>
                <mo>+</mo>
                <mi>a</mi>
                <mo>+</mo>
                <mi mathvariant='normal'>Α</mi>
                <mo>+</mo>
                <mi mathvariant='normal'>α</mi>
                <mo>+</mo>
                <mi>AB</mi>
              </math>
            </stem>
          </formula>
        </sections>
      </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "deals with quoted alt titles" do
    input = <<~INPUT
      = Document title
      Author

      == Clause

      === {blank}

      [.variant-title,type=quoted]
      *Definition of the metre* (CR, 85)
    INPUT

    output = <<~OUTPUT
      #{BLANK_HDR}
      <sections>
      <clause id='_' obligation='normative'>
        <title id="_">Clause</title>
        <clause id='_' obligation='normative'>
          <variant-title id="_" type='quoted'>
            <strong>Definition of the metre</strong>
             (CR, 85)
          </variant-title>
        </clause>
      </clause>
      </sections>
      </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "references BIPM English citations" do
    # allow(File).to receive(:exist?).and_call_original
    input = <<~INPUT
      #{LOCAL_CACHED_ISOBIB_BLANK_HDR}

      == Clause

      <<a1>>
      <<a2>>

      [bibliography]
      == Bibliography
      * [[[a1,CGPM -- Meeting 1 (1889)]]]
      * [[[a2,BIPM DECN CIPM/101-1 (2012, EN)]]]
    INPUT

    output = <<~OUTPUT
      <sections>
        <clause id="_" obligation="normative">
           <title id="_">Clause</title>
           <p id="_">
              <eref type="inline" bibitemid="a1" citeas="CGPM 1st Meeting (1889)"/>
              <eref type="inline" style="BIPM-long" bibitemid="a2" citeas="CIPM Decision 101-1 (2012)"/>
           </p>
        </clause>
      </sections>
    OUTPUT
    doc = Asciidoctor.convert(input, *OPTIONS)
    expect(Canon.format_xml(strip_guid(
                              Nokogiri::XML(doc)
                              .at("//xmlns:sections").to_xml,
                            )))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "references BIPM French citations" do
    # allow(File).to receive(:exist?).with(/index\.yaml/).and_return false
    # allow(File).to receive(:exist?).and_call_original
    input = <<~INPUT
      #{LOCAL_CACHED_ISOBIB_BLANK_HDR.sub(/:nodoc:/, ":nodoc:\n:language: fr")}

      == Clause

      <<a1>>
      <<a2>>

      [bibliography]
      == Bibliography
      * [[[a2,BIPM DECN CIPM/101-1 (2012, FR)]]]
      * [[[a1,CGPM -- Meeting 1 (1889)]]]
    INPUT

    output = <<~OUTPUT
      <sections>
        <clause id="_" obligation="normative">
           <title id="_">Clause</title>
           <p id="_">
              <eref type="inline" bibitemid="a1" citeas="CGPM 1&lt;sup&gt;e&lt;/sup&gt; réunion (1889)"/>
              <eref type="inline" style="BIPM-long" bibitemid="a2" citeas="Décision CIPM/101-1 (2012)"/>
           </p>
        </clause>
      </sections>
    OUTPUT
    expect(Canon.format_xml(strip_guid(
                              Nokogiri::XML(Asciidoctor.convert(input,
                                                                *OPTIONS))
                              .at("//xmlns:sections").to_xml,
                            )))
      .to be_equivalent_to Canon.format_xml(output)
  end
end
