require "spec_helper"

RSpec.describe Metanorma::BIPM do
  it "processes default metadata" do
    input = <<~"INPUT"
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
      :comment-period-from: X
      :comment-period-to: Y
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

    output = xmlpp(<<~"OUTPUT")
      <?xml version="1.0" encoding="UTF-8"?>
      <bipm-standard type="semantic" version="#{Metanorma::BIPM::VERSION}" xmlns="https://www.metanorma.org/ns/bipm">
        <bibdata type="standard">
          <title format="text/plain" language="en" type="main">Main Title</title>
          <title format="text/plain" language="en" type="cover">Main Title (SI)</title>
          <title format="text/plain" language="en" type="appendix">Main Title (SI)</title>
          <title format="text/plain" language="en" type="annex">Main Title (SI) Annex</title>
          <title format="text/plain" language="en" type="part">Part</title>
          <title format="text/plain" language="en" type="subpart">Subpart</title>
          <title format="text/plain" language="en" type="provenance">Provenance-en</title>
          <title format="text/plain" language="fr" type="main">Chef Title</title>
          <title format="text/plain" language="fr" type="cover">Chef Title (SI)</title>
          <title format="text/plain" language="fr" type="appendix">Chef Title (SI)</title>
          <title format="text/plain" language="fr" type="annex">Chef Title (SI) Annexe</title>
          <title format="text/plain" language="fr" type="part">Partie</title>
          <title format="text/plain" language="fr" type="subpart">Subpartie</title>
          <title format="text/plain" language="fr" type="provenance">Provenance-fr</title>
          <docidentifier type="BIPM">#{Metanorma::BIPM.configuration.organization_name_short} 1000</docidentifier>
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
              <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
              <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
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
            <role type="publisher"/>
            <organization>
              <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
              <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
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
                <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
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
            <editorialgroup>
              <committee acronym="TCA">
                <variant language="en" script="Latn">TC</variant>
                <variant language="fr" script="Latn">CT</variant>
              </committee>
              <workgroup acronym="WGA">WG</workgroup>
            </editorialgroup>
            <comment-period>
              <from>X</from>
              <to>Y</to>
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
        #{boilerplate('en').gsub(/#{Time.now.year}/, '2001')}

        <sections/>
      </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "processes default metadata in French" do
    input = <<~"INPUT"
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
      :committee-acronym: TCA
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
      :comment-period-from: X
      :comment-period-to: Y
      :supersedes: A
      :superseded-by: B
      :obsoleted-date: C
      :implemented-date: D
    INPUT

    output = xmlpp(<<~"OUTPUT")
      <?xml version="1.0" encoding="UTF-8"?>
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::BIPM::VERSION}" type="semantic">
      <bibdata type="standard">
        <title language='en' format='text/plain' type='main'>Main Title</title>
        <title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
        <title language='fr' format='text/plain' type='main'>Chef Title</title>
        <title language='fr' format='text/plain' type='cover'>Chef Title (SI)</title>
          <docidentifier type="BIPM">BIPM 1000</docidentifier>
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
              <name>#{Metanorma::BIPM.configuration.organization_name_long['fr']}</name>
              <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
            </organization>
          </contributor>
          <contributor>
            <role type="publisher"/>
            <organization>
              <name>#{Metanorma::BIPM.configuration.organization_name_long['fr']}</name>
              <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
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
                <name>#{Metanorma::BIPM.configuration.organization_name_long['fr']}</name>
                <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
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
            <editorialgroup>
              <committee acronym="TCA">
                <variant language='en' script='Latn'>TC</variant>
                <variant language='fr' script='Latn'>CT</variant>
              </committee>
              <workgroup>WG</workgroup>
            </editorialgroup>
            <comment-period>
              <from>X</from>
              <to>Y</to>
            </comment-period>
            <structuredidentifier>
              <docnumber>1000</docnumber>
              <part>2.1</part>
              <appendix>ABC</appendix>
            </structuredidentifier>
          </ext>
        </bibdata>
        #{boilerplate('fr').gsub(/#{Time.now.year}/, '2001')}
        <sections/>
      </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "processes default metadata for JCGM" do
    input = <<~"INPUT"
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
      :comment-period-from: X
      :comment-period-to: Y
      :supersedes: A
      :superseded-by: B
      :obsoleted-date: C
      :implemented-date: D
    INPUT

    output = xmlpp(<<~"OUTPUT")
      <?xml version="1.0" encoding="UTF-8"?>
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::BIPM::VERSION}" type="semantic">
        <bibdata type='standard'>
          <title language='en' format='text/plain' type='main'>Main Title</title>
          <title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
          <title language='fr' format='text/plain' type='main'>Chef Title</title>
          <title language='fr' format='text/plain' type='cover'>Chef Title (SI)</title>
          <docidentifier type='BIPM'>JCGM 1000</docidentifier>
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
            <editorialgroup>
              <committee acronym='JCGM'>
                <variant language='en' script='Latn'>TC</variant>
                <variant language='fr' script='Latn'>CT</variant>
              </committee>
              <workgroup>WG</workgroup>
            </editorialgroup>
            <comment-period>
              <from>X</from>
              <to>Y</to>
            </comment-period>
            <structuredidentifier>
              <docnumber>1000</docnumber>
              <part>2.1</part>
              <appendix>ABC</appendix>
            </structuredidentifier>
          </ext>
        </bibdata>
        #{boilerplate('jcgm').gsub(/#{Time.now.year}/, '2001')}
        <sections/>
      </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
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

    output = xmlpp(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections>
          <figure id="id">
            <name>Figure 1</name>
            <pre id="_">This is a literal

              Amen</pre>
          </figure>
        </sections>
      </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = xmlpp(<<~"OUTPUT")
      #{BLANK_HDR}
        <preface>
          <foreword id="_" obligation="informative">
            <title>Foreword</title>
            <p id="_">This is a preamble</p>
          </foreword>
        </preface>
        <sections>
          <clause id="_" obligation="normative">
            <title>Section 1</title>
          </clause>
        </sections>
      </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
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

    output = xmlpp(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections>
          <clause id='a' obligation='normative'>
            <title>Section 1</title>
            <p id='_'>
              <xref target='a'/>
              <xref target='a' pagenumber='true'/>
              <xref target='a' nosee='true'/>
              <xref target='a' nopage='true'/>
            </p>
          </clause>
        </sections>
      </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~"INPUT"
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
    input = <<~"INPUT"
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
            <title>Clause</title>
          </clause>
        </sections>
        <annex id='_' obligation='normative' unnumbered="true">
          <title>Appendix</title>
        </annex>
      </bipm-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
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
      </bipm-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes sections" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
      .Foreword

      Text

      [abstract]
      == Abstract

      Text

      == Introduction

      === Introduction Subsection

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
      #{BLANK_HDR.sub(%r{</script>}, '</script><abstract><p>Text</p></abstract>')}
        <preface>
          <abstract id='_'>
            <title>Abstract</title>
            <p id='_'>Text</p>
          </abstract>
          <foreword id='_' obligation='informative'>
            <title>Foreword</title>
            <p id='_'>Text</p>
          </foreword>
          <clause id='_' obligation='informative'>
            <title>Dedication</title>
          </clause>
          <acknowledgements id='_' obligation='informative'>
            <title>Acknowledgements</title>
          </acknowledgements>
        </preface>
        <sections>
          <clause id='_' obligation='normative'>
            <title>Introduction</title>
            <clause id='_' obligation='normative'>
              <title>Introduction Subsection</title>
            </clause>
          </clause>
          <clause id='_' type='scope' obligation='normative'>
            <title>Scope</title>
            <p id='_'>Text</p>
          </clause>
          <terms id='_' obligation='normative'>
            <title>Photometric units</title>
            <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
            <term id='term-Term1'>
              <preferred><expression><name>Term1</name></expression></preferred>
            </term>
          </terms>
          <clause id='_' obligation='normative'>
            <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
            <clause id='_' obligation='normative'>
              <title>Introduction</title>
              <clause id='_' obligation='normative'>
                <title>Intro 1</title>
              </clause>
            </clause>
            <terms id='_' obligation='normative'>
              <title>Intro 2</title>
              <clause id='_' obligation='normative'>
                <title>Intro 3</title>
              </clause>
            </terms>
            <clause id='_' obligation='normative'>
              <title>Intro 4</title>
              <terms id='_' obligation='normative'>
                <title>Intro 5</title>
                <term id='term-Term1-1'>
                  <preferred><expression><name>Term1</name></expression></preferred>
                </term>
              </terms>
            </clause>
            <terms id='_' obligation='normative'>
              <title>Normal Terms</title>
              <term id='term-Term2'>
                <preferred><expression><name>Term2</name></expression></preferred>
              </term>
            </terms>
            <definitions id='_' obligation='normative'>
              <title>Symbols and Abbreviated Terms</title>
              <clause id='_' obligation='normative'>
                <title>General</title>
              </clause>
              <definitions id='_' obligation='normative' type='symbols'>
                <title>Symbols</title>
              </definitions>
            </definitions>
          </clause>
          <definitions id='_' type='abbreviated_terms' obligation='normative'>
            <title>Abbreviated Terms</title>
          </definitions>
          <clause id='_' obligation='normative'>
            <title>Clause 4</title>
            <clause id='_' obligation='normative'>
              <title>Introduction</title>
            </clause>
            <clause id='_' obligation='normative'>
              <title>Clause 4.2</title>
            </clause>
            <clause id='_' obligation='normative'> </clause>
          </clause>
          <terms id='_' obligation='normative'>
             <title>Terms and Definitions</title>
             <p id='_'>No terms and definitions are listed in this document.</p>
           </terms>
        </sections>
        <annex id='_' obligation='normative'>
          <title>Annex</title>
          <clause id='_' obligation='normative'>
            <title>Annex A.1</title>
          </clause>
        </annex>
        <bibliography>
          <references id='_' normative='true' obligation='informative'>
            <title>Normative References</title>
            <p id='_'>There are no normative references in this document.</p>
          </references>
          <clause id='_' obligation='informative'>
            <title>Bibliography</title>
            <references id='_' normative='false' obligation='informative'>
              <title>Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </bipm-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes sections in JCGM" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR.sub(/:novalid:/, ":novalid:\n:committee-acronym: JCGM")}
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
        <abstract id='_'>
          <title>Abstract</title>
          <p id='_'>Text</p>
        </abstract>
        <foreword id='_' obligation='informative'>
          <title>Foreword</title>
          <p id='_'>Text</p>
        </foreword>
        <introduction id='_' obligation='informative'>
          <title>Introduction</title>
          <clause id='_' obligation='informative'>
            <title>Introduction Subsection</title>
          </clause>
          <clause id='_' obligation='informative' inline-header='true'> </clause>
        </introduction>
        <clause id='_' obligation='informative'>
          <title>Dedication</title>
        </clause>
        <acknowledgements id='_' obligation='informative'>
          <title>Acknowledgements</title>
        </acknowledgements>
      </preface>
      <sections>
        <clause id='_' type='scope' obligation='normative'>
          <title>Scope</title>
          <p id='_'>Text</p>
        </clause>
        <terms id='_' obligation='normative'>
          <title>Photometric units</title>
          <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
          <term id='term-Term1'>
            <preferred><expression><name>Term1</name></expression></preferred>
          </term>
        </terms>
        <clause id='_' obligation='normative'>
          <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
          <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
          <clause id='_' obligation='normative'>
            <title>Introduction</title>
            <clause id='_' obligation='normative'>
              <title>Intro 1</title>
            </clause>
          </clause>
          <terms id='_' obligation='normative'>
            <title>Intro 2</title>
            <clause id='_' obligation='normative'>
              <title>Intro 3</title>
            </clause>
          </terms>
          <clause id='_' obligation='normative'>
            <title>Intro 4</title>
            <terms id='_' obligation='normative'>
              <title>Intro 5</title>
              <term id='term-Term1-1'>
                <preferred><expression><name>Term1</name></expression></preferred>
              </term>
            </terms>
          </clause>
          <terms id='_' obligation='normative'>
            <title>Normal Terms</title>
            <term id='term-Term2'>
              <preferred><expression><name>Term2</name></expression></preferred>
            </term>
          </terms>
          <definitions id='_' obligation='normative'>
            <title>Symbols and Abbreviated Terms</title>
            <clause id='_' obligation='normative'>
              <title>General</title>
            </clause>
            <definitions id='_' obligation='normative' type='symbols'>
              <title>Symbols</title>
            </definitions>
          </definitions>
        </clause>
        <definitions id='_' type='abbreviated_terms' obligation='normative'>
          <title>Abbreviated Terms</title>
        </definitions>
        <clause id='_' obligation='normative'>
          <title>Clause 4</title>
          <clause id='_' obligation='normative'>
            <title>Introduction</title>
          </clause>
          <clause id='_' obligation='normative'>
            <title>Clause 4.2</title>
          </clause>
          <clause id='_' obligation='normative' inline-header='true'> </clause>
        </clause>
        <terms id='_' obligation='normative'>
                  <title>Terms and Definitions</title>
                  <p id='_'>No terms and definitions are listed in this document.</p>
                </terms>
      </sections>
      <annex id='_' obligation='normative'>
        <title>Annex</title>
        <clause id='_' obligation='normative'>
          <title>Annex A.1</title>
        </clause>
      </annex>
      <bibliography>
        <references id='_' normative='true' obligation='informative'>
          <title>Normative References</title>
          <p id='_'>There are no normative references in this document.</p>
        </references>
        <clause id='_' obligation='informative'>
          <title>Bibliography</title>
          <references id='_' normative='false' obligation='informative'>
            <title>Bibliography Subsection</title>
          </references>
        </clause>
      </bibliography>
           </bipm-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS)))
      .sub(%r{<boilerplate>.*</boilerplate>}m, ""))
      .to be_equivalent_to xmlpp(output)
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
            <stem type='MathML'>
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
      </bipm-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
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
        <title>Clause</title>
        <clause id='_' obligation='normative'>
          <variant-title type='quoted'>
            <strong>Definition of the metre</strong>
             (CR, 85)
          </variant-title>
        </clause>
      </clause>
      </sections>
      </bipm-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "references BIPM citations" do
    VCR.use_cassette "bipm" do
      input = <<~INPUT
        = Document title
        Author

        == Clause

        <<a1>>
        <<a2>>

        [bibliography]
        == Bibliography
        * [[[a1,BIPM CGPM Resolution 1889-00]]]
        * [[[a2,BIPM CIPM Decision 2016-01]]]
      INPUT

      output = <<~OUTPUT
        <sections>
         <clause id='_' obligation='normative'>
           <title>Clause</title>
           <p id='_'>
             <eref type='inline' bibitemid='a1' citeas='CGPM Resolution (1889)'/>
             <eref type='inline' bibitemid='a2' citeas='CIPM Decision 1 (2016)'/>
           </p>
         </clause>
       </sections>
      OUTPUT
      expect(xmlpp(strip_guid(
        Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
        .at("//xmlns:sections").to_xml)))
        .to be_equivalent_to xmlpp(output)
    end
  end
end
