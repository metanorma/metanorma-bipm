require "spec_helper"

RSpec.describe IsoDoc::BIPM do
  it "inserts part in appendix title" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
      <bibdata>
      <title type="main" language="en">Maintitle</title>
      <title type="part" language="en">Parttitle</title>
      <title type="main" language="fr">Titrechef</title>
      <title type="part" language="fr">Titrepartie</title>
      <ext>
      <structuredidentifier>
      <appendix>3</appendix>
      </structuredidentifier>
      </ext>
      </bibdata>
      </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
      <bipm-standard xmlns='https://open.ribose.com/standards/bipm' type='presentation'>
        <bibdata>
           <title type='main' language='en'>Maintitle</title>
           <title type='part' language='en'>Parttitle</title>
           <title type='part-with-numbering' language='en'>Part 3: Parttitle</title>
           <title type='main' language='fr'>Titrechef</title>
           <title type='part' language='fr'>Titrepartie</title>
           <title type='part-with-numbering' language='fr'>Partie 3&#xA0;: Titrepartie</title>
          <ext>
            <structuredidentifier>
              <appendix>3</appendix>
            </structuredidentifier>
          </ext>
        </bibdata>
      </bipm-standard>
    OUTPUT

    expect(strip_guid(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to output

    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
      <bibdata>
      <title type="main" language="en">Maintitle</title>
      <title type="part" language="en">Parttitle</title>
      <title type="main" language="fr">Titrechef</title>
      <title type="part" language="fr">Titrepartie</title>
      </bibdata>
      </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
      <bipm-standard xmlns='https://open.ribose.com/standards/bipm' type='presentation'>
        <bibdata>
          <title type='main' language='en'>Maintitle</title>
          <title type='part' language='en'>Parttitle</title>
          <title type='main' language='fr'>Titrechef</title>
          <title type='part' language='fr'>Titrepartie</title>
        </bibdata>
      </bipm-standard>
    OUTPUT

    expect(strip_guid(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to output
  end

  it "processes pre" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <preface>
          <foreword>
            <pre>ABC</pre>
          </foreword>
        </preface>
      </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
      #{HTML_HDR}
      <br/>
          <div>
            <h1 class="ForewordTitle">Foreword</h1>
            <pre>ABC</pre>
          </div>
          <p class="zzSTDTitle1"/>
        </div>
      </body>
    OUTPUT

    expect(strip_guid(xmlpp(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to be_equivalent_to output
  end

  it "processes table" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <sections>
          <clause id="A">
            <table id="B">
              <name>First Table</name>
            </table>
            <table id="C" unnumbered="true">
              <name>Second Table</name>
            </table>
          </clause>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
        <sections>
          <clause id="A" displayorder="1">
            <title>1.</title>
            <table id="B">
              <name>Table 1.<tab/>First Table</name>
            </table>
             <table id='C' unnumbered='true'>
               <name>Second Table</name>
             </table>
          </clause>
        </sections>
      </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
      #{HTML_HDR}
          <p class="zzSTDTitle1"/>
          <div id='A'>
            <h1>1.</h1>
            <p class='TableTitle' style='text-align:center;'>Table 1.&#160; First Table</p>
            <table id='B' class='MsoISOTable' style='border-width:1px;border-spacing:0;'/>
            <p class='TableTitle' style='text-align:center;'>Second Table</p>
            <table id='C' class='MsoISOTable' style='border-width:1px;border-spacing:0;'/>
          </div>
        </div>
      </body>
    OUTPUT
    stripped_presxml =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_presxml).to(be_equivalent_to(xmlpp(presxml)))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "processes simple terms & definitions" do
    input = <<~"INPUT"
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
          <terms id="H" obligation="normative">
            <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <term id="J">
              <preferred>Term2</preferred>
              <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
            </term>
          </terms>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~"INPUT"
      <bipm-standard xmlns="http://riboseinc.com/isoxml"  type='presentation'>
        <sections>
          <terms id="H" obligation="normative" displayorder="2">
            <title depth='1'>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <term id="J">
              <name>1.1.</name>
              <preferred>Term2</preferred>
              <termsource status="modified">[Adapted from
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality>ISO 7301:2011, Clause 3.1</origin>, modified &#x2013;
          The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here]
      </termsource>
            </term>
          </terms>
        </sections>
      </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
      <body lang='EN-US' xml:lang='EN-US' link='blue' vlink='#954F72' class='container'>
        <div class='title-section'>
          <p>&#160;</p>
        </div>
        <br/>
        <div class='prefatory-section'>
          <p>&#160;</p>
        </div>
        <br/>
        <div class='main-section'>
          <p class='zzSTDTitle1'/>
          <div id='H'>
            <h1>1.&#160; Terms, Definitions, Symbols and Abbreviated Terms</h1>
            <p class='TermNum' id='J'>1.1.</p>
            <p class='Terms' style='text-align:left;'>Term2</p>
            <p>
              [Adapted from
              ISO 7301:2011, Clause 3.1, modified &#8211; The term "cargo rice" is shown as deprecated, and
              Note 1 to entry is not included here]
            </p>
          </div>
        </div>
      </body>
    OUTPUT

    stripped_presxml =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_presxml).to(be_equivalent_to(xmlpp(presxml)))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "processes simple terms & definitions in JCGM" do
    input = <<~"INPUT"
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata>
          <ext>
            <editorialgroup>
              <committee acronym="JCGM">
                Joint Committee for Guides in Metrology
                Comité commun pour les guides en métrologie
              </committee>
            </editorialgroup>
          </ext>
        </bibdata>
        <sections>
          <terms id="H" obligation="normative">
            <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <term id="J">
              <preferred>Term2</preferred>
              <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
            </term>
          </terms>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~"INPUT"
      <bipm-standard xmlns="http://riboseinc.com/isoxml"  type='presentation'>
      <bibdata>
          <ext>
            <editorialgroup>
              <committee acronym="JCGM">
                Joint Committee for Guides in Metrology
                Comité commun pour les guides en métrologie
              </committee>
            </editorialgroup>
          </ext>
        </bibdata>
        <sections>
          <terms id="H" obligation="normative" displayorder="2">
            <title depth="1">1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <term id="J">
              <name>1.1.</name>
              <preferred>Term2</preferred>
              <termsource status="modified">[Adapted from
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality>ISO 7301:2011, <span class='citesec'>3.1</span></origin>, modified &#x2013;
          The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here]
      </termsource>
            </term>
          </terms>
        </sections>
      </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
      <body lang='EN-US' xml:lang='EN-US' link='blue' vlink='#954F72' class='container'>
        <div class='title-section'>
          <p>&#160;</p>
        </div>
        <br/>
        <div class='prefatory-section'>
          <p>&#160;</p>
        </div>
        <br/>
        <div class='main-section'>
          <p class='zzSTDTitle1'/>
          <div id='H'>
            <h1>1.&#160; Terms, Definitions, Symbols and Abbreviated Terms</h1>
            <p class='TermNum' id='J'>1.1.</p>
            <p class='Terms' style='text-align:left;'>Term2</p>
            <p>
              [Adapted from ISO 7301:2011, 3.1, modified &#8211; The term "cargo rice" is shown as deprecated, and
              Note 1 to entry is not included here]
            </p>
          </div>
        </div>
      </body>
    OUTPUT

    stripped_presxml =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_presxml).to(be_equivalent_to(xmlpp(presxml)))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "injects JS into blank html" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    output = xmlpp(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections/>
      </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm,
                                                       header_footer: true))))
      .to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Times New Roman})
  end

  it "processes ordered lists" do
    input = <<~"INPUT"
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
          <clause id="A">
            <title>Clause</title>
            <ol start="4" type="arabic">
              <li>
                <ol type="roman_upper">
                  <li>A</li>
                </ol>
              </li>
            </ol>
          </clause>
        </sections>
      </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
      #{HTML_HDR}
          <p class="zzSTDTitle1"/>
          <div id='A'>
            <h1>Clause</h1>
            <ol type='1' start='4'>
              <li>
                <ol type='I'>
                  <li>A</li>
                </ol>
              </li>
            </ol>
          </div>
        </div>
      </body>
    OUTPUT
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "generates document control text" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::BIPM::VERSION}" type="semantic">
        <bibdata type="standard">
          <title language='en' format='text/plain' type='main'>Main Title</title>
          <title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
          <title language='en' format='text/plain' type='appendix'>Main Title (SI)</title>
            <contributor>
              <role type="author"/>
              <organization>
                <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
              </organization>
            </contributor>
              <contributor>
              <role type='author'/>
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
              <role type='author'/>
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
              <role type='author'/>
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
               <role type='editor'>WG-N co-chair</role>
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
             <role type='editor'>WG-N co-chair</role>
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
             <role type='editor'>WG-N chair</role>
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
          <relation type='supersedes'>
            <bibitem>
              <date type='published'>2018-06-11</date>
              <edition>1.0</edition>
              <version>
                <draft>1.0</draft>
              </version>
            </bibitem>
          </relation>
          <relation type='supersedes'>
            <bibitem>
              <date type='published'>2019-06-11</date>
              <edition>2.0</edition>
              <version>
                <draft>2.0</draft>
              </version>
            </bibitem>
          </relation>
          <relation type='supersedes'>
            <bibitem>
              <date type='circulated'>2019-06-11</date>
              <version>
                <draft>3.0</draft>
              </version>
            </bibitem>
          </relation>
        </bibdata>
        <sections/>
      </bipm-standard>
    INPUT

    presxml = xmlpp(<<~"OUTPUT")
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" version="#{Metanorma::BIPM::VERSION}" type="presentation">
        <bibdata type="standard">
        <title language="en" format="text/plain" type="main">Main Title</title>
        <title language="en" format="text/plain" type="cover">Main Title (SI)</title>
        <title language="en" format="text/plain" type="appendix">Main Title (SI)</title>
          <contributor>
            <role type="author"/>
            <organization>
              <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
              <abbreviation>BIPM</abbreviation>
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
              <abbreviation>BIPM</abbreviation>
            </organization>
          </contributor>
          <edition language=''>2</edition><edition language='en'>second edition</edition>
        <version>
          <revision-date>2000-01-01</revision-date>
          <draft>3.4</draft>
        </version>
          <language current="true">en</language>
          <script current="true">Latn</script>
          <status>
            <stage>working-draft</stage>
            <iteration>3</iteration>
          </status>
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
        </bibdata>
        <sections/>
        <doccontrol>
           <title>Document Control</title>
           <table unnumbered='true'>
             <tbody>
               <tr>
                 <th>Authors:</th>
                 <td/>
                 <td>Andrew Yacoot (NPL), Ulrich Kuetgens (PTB), and Enrico Massa (INRIM)</td>
               </tr>
               <tr>
                 <td>Draft 1.0 Version 1.0</td>
                 <td>2018-06-11</td>
                 <td>WG-N co-chairs: Ronald Dixson (NIST) and Harald Bosse (PTB)</td>
               </tr>
               <tr>
                 <td>Draft 2.0 Version 2.0</td>
                 <td>2019-06-11</td>
                 <td>WG-N chair: Andrew Yacoot (NPL)</td>
               </tr>
               <tr>
                 <td>Draft 3.0 </td>
                 <td>2019-06-11</td>
                 <td/>
               </tr>
             </tbody>
           </table>
         </doccontrol>
      </bipm-standard>
    OUTPUT

    output = xmlpp(<<~"OUTPUT")
      #{HTML_HDR}
            <p class='zzSTDTitle1'>Main Title</p>
            <div class='doccontrol'>
              <h1>Document Control</h1>
              <table class='MsoISOTable' style='border-width:1px;border-spacing:0;'>
                 <tbody>
                   <tr>
                     <th style='font-weight:bold;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;' scope='row'>Authors:</th>
                     <td style='border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'/>
                     <td style='border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'>Andrew Yacoot (NPL), Ulrich Kuetgens (PTB), and Enrico Massa (INRIM)</td>
                   </tr>
                   <tr>
                     <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>Draft 1.0 Version 1.0</td>
                     <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>2018-06-11</td>
                     <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>WG-N co-chairs: Ronald Dixson (NIST) and Harald Bosse (PTB)</td>
                   </tr>
                   <tr>
                     <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>Draft 2.0 Version 2.0</td>
                     <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>2019-06-11</td>
                     <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>WG-N chair: Andrew Yacoot (NPL)</td>
                   </tr>
                   <tr>
                     <td style='border-top:none;border-bottom:solid windowtext 1.5pt;'>Draft 3.0 </td>
                     <td style='border-top:none;border-bottom:solid windowtext 1.5pt;'>2019-06-11</td>
                     <td style='border-top:none;border-bottom:solid windowtext 1.5pt;'/>
                   </tr>
                 </tbody>
               </table>
            </div>
          </div>
        </body>
    OUTPUT

    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
    expect(stripped_html).to(be_equivalent_to(presxml))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "generates shorter document control text" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::BIPM::VERSION}" type="semantic">
        <bibdata type="standard">
          <title language='en' format='text/plain' type='main'>Main Title</title>
          <title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
          <title language='en' format='text/plain' type='appendix'>Main Title (SI)</title>
            <contributor>
              <role type="author"/>
              <organization>
                <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
              </organization>
            </contributor>
              <contributor>
              <role type='author'/>
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
              <role type='author'/>
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
          <relation type='supersedes'>
            <bibitem>
              <date type='published'>2018-06-11</date>
              <edition>1.0</edition>
              <version>
                <draft>1.0</draft>
              </version>
            </bibitem>
          </relation>
        </bibdata>
        <sections/>
      </bipm-standard>
    INPUT

    presxml = <<~PRESXML
      <bipm-standard xmlns='https://www.metanorma.org/ns/bipm' version="#{Metanorma::BIPM::VERSION}" type='presentation'>
      <bibdata type='standard'>
             <title language='en' format='text/plain' type='main'>Main Title</title>
             <title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
             <title language='en' format='text/plain' type='appendix'>Main Title (SI)</title>
             <contributor>
               <role type='author'/>
               <organization>
                 <name>Bureau International des Poids et Mesures</name>
                 <abbreviation>BIPM</abbreviation>
               </organization>
             </contributor>
             <contributor>
               <role type='author'/>
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
               <role type='author'/>
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
               <role type='publisher'/>
               <organization>
                 <name>Bureau International des Poids et Mesures</name>
                 <abbreviation>BIPM</abbreviation>
               </organization>
             </contributor>
             <edition language=''>2</edition><edition language='en'>second edition</edition>
             <version>
               <revision-date>2000-01-01</revision-date>
               <draft>3.4</draft>
             </version>
             <language current='true'>en</language>
             <script current='true'>Latn</script>
             <status>
               <stage>working-draft</stage>
               <iteration>3</iteration>
             </status>
             <relation type='supersedes'>
               <bibitem>
                 <date type='published'>2018-06-11</date>
                 <edition>1.0</edition>
                 <version>
                   <draft>1.0</draft>
                 </version>
               </bibitem>
             </relation>
           </bibdata>
           <sections/>
           <doccontrol>
             <title>Document Control</title>
             <table unnumbered='true'>
               <tbody>
                 <tr>
                   <th>Authors:</th>
                   <td/>
                   <td>Andrew Yacoot (NPL) and Ulrich Kuetgens (PTB)</td>
                 </tr>
                 <tr>
                   <td>Draft 1.0 Version 1.0</td>
                   <td>2018-06-11</td>
                   <td/>
                 </tr>
               </tbody>
             </table>
           </doccontrol>
         </bipm-standard>
    PRESXML

    output = <<~HTML
      <body lang='EN-US' xml:lang='EN-US' link='blue' vlink='#954F72' class='container'>
           <div class='title-section'>
             <p>&#160;</p>
           </div>
           <br/>
           <div class='prefatory-section'>
             <p>&#160;</p>
           </div>
           <br/>
           <div class='main-section'>
             <p class='zzSTDTitle1'>Main Title</p>
             <div class='doccontrol'>
               <h1>Document Control</h1>
               <table class='MsoISOTable' style='border-width:1px;border-spacing:0;'>
                 <tbody>
                   <tr>
                     <th style='font-weight:bold;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;' scope='row'>Authors:</th>
                     <td style='border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'/>
                     <td style='border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'>Andrew Yacoot (NPL) and Ulrich Kuetgens (PTB)</td>
                   </tr>
                   <tr>
                     <td style='border-top:none;border-bottom:solid windowtext 1.5pt;'>Draft 1.0 Version 1.0</td>
                     <td style='border-top:none;border-bottom:solid windowtext 1.5pt;'>2018-06-11</td>
                     <td style='border-top:none;border-bottom:solid windowtext 1.5pt;'/>
                   </tr>
                 </tbody>
               </table>
             </div>
           </div>
         </body>
    HTML

    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
    expect(stripped_html).to(be_equivalent_to(xmlpp(presxml)))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "processes nested roman and alphabetic lists" do
    input = <<~"INPUT"
      <bipm-standard type="semantic" version="#{Metanorma::BIPM::VERSION}" xmlns="https://www.metanorma.org/ns/bipm">
        <preface>
          <ol id="_a165a98f-d641-4ccc-9c7e-d3268d93130c" type="alphabet_upper">
            <li>
              <p id="_484e82a7-48a3-4d88-a575-34143c9f7813">a</p>
              <ol id="_512ecf9b-3920-4726-892c-6c5563d97cea" type="alphabet">
                <li>
                  <p id="_ce9cb812-6652-4cf4-bf61-7237df4f3958">a1</p>
                </li>
              </ol>
            </li>
            <li>
              <p id="_8a13966e-2d6c-4b76-94e3-240d5a00a66b">a2</p>
              <ol id="_b9fb9f0c-29a0-498c-ae78-42b5fab5c418" start="5" type="alphabet">
                <li>
                  <p id="_36f055e4-5cfa-430c-80b9-8a53617af152">b</p>
                  <ol id="_fccf5477-00b4-42dc-8a32-d7838b3a6880" start="10" type="alphabet">
                    <li>
                      <p id="_388d07a4-882d-4f1b-8832-aca813714043">c</p>
                    </li>
                  </ol>
                </li>
                <li>
                  <ol id="_e883e785-1a4f-4af1-be63-28187c9b8c6a" start="2" type="roman">
                    <li>
                      <p>c1</p>
                    </li>
                  </ol>
                  <p id="_16e6dafe-d3f2-44c5-bb79-303bc9385d92">d</p>
                  <ol id="_e883e785-1a4f-4af1-be63-28187c9b8c69" type="roman">
                    <li>
                      <p id="_c11e737b-0f02-4d80-9733-84561d743cbf">e</p>
                      <ol id="_46c2218e-d5e4-4aca-940e-37e8c6099a27" start="12" type="roman">
                        <li>
                          <p id="_5c9d3bb2-1a86-4724-8f87-56a2df85f6d9">f</p>
                        </li>
                        <li>
                          <p id="_23f4cf36-19c6-48ac-be10-0740cc143a29">g</p>
                        </li>
                      </ol>
                    </li>
                    <li>
                      <p id="_20c2f77a-932c-41ac-8077-8bab94e56232">h</p>
                    </li>
                  </ol>
                </li>
                <li>
                  <p id="_58854800-eef7-4c13-843a-1ad6eb028cc8">i</p>
                </li>
              </ol>
            </li>
            <li>
              <p id="_0227008e-aaac-4b64-8914-3c1c8a27b587">j</p>
            </li>
          </ol>
        </preface>
      </bipm-standard>
    INPUT

    expect(xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to be_equivalent_to <<~"OUTPUT"

        <body lang='EN-US' xml:lang='EN-US' link='blue' vlink='#954F72' class='container'>
          <div class='title-section'>
            <p>&#160;</p>
          </div>
          <br/>
          <div class='prefatory-section'>
            <p>&#160;</p>
          </div>
          <br/>
          <div class='main-section'>
            <ol type='A' id='_'>
              <li>
                <p id='_'>a</p>
                <ol type='a' id='_' class='alphabet'>
                  <li>
                    <p id='_'>a1</p>
                  </li>
                </ol>
              </li>
              <li>
                <p id='_'>a2</p>
                <ol type='a' id='_' style='counter-reset: alphabet 4;' start='5' class='alphabet'>
                  <li>
                    <p id='_'>b</p>
                    <ol type='a' id='_' start='10'>
                      <li>
                        <p id='_'>c</p>
                      </li>
                    </ol>
                  </li>
                  <li>
                    <ol type='i' id='_' style='counter-reset: roman 1;' start='2' class='roman'>
                      <li>
                        <p>c1</p>
                      </li>
                    </ol>
                    <p id='_'>d</p>
                    <ol type='i' id='_' class='roman'>
                      <li>
                        <p id='_'>e</p>
                        <ol type='i' id='_' start='12'>
                          <li>
                            <p id='_'>f</p>
                          </li>
                          <li>
                            <p id='_'>g</p>
                          </li>
                        </ol>
                      </li>
                      <li>
                        <p id='_'>h</p>
                      </li>
                    </ol>
                  </li>
                  <li>
                    <p id='_'>i</p>
                  </li>
                </ol>
              </li>
              <li>
                <p id='_'>j</p>
              </li>
            </ol>
            <p class='zzSTDTitle1'/>
          </div>
        </body>
    OUTPUT
  end

  it "generates an index in English" do
    input = <<~INPUT
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <bibdata>
          <language>en</language>
          <script>Latn</script>
        </bibdata>
        <sections>
          <clause id="A">
            <index><primary>&#xE9;long&#xE9;</primary></index>
            <index><primary>&#xEA;tre</primary><secondary>Husserl</secondary><tertiary>en allemand</tertiary></index>
            <index><primary><em>Eman</em>cipation</primary></index>
            <index><primary><em>Eman</em>cipation</primary><secondary>dans la France</secondary></index>
            <index><primary><em>Eman</em>cipation</primary><secondary>dans la France</secondary><tertiary>en Bretagne</tertiary></index>
            <clause id="B">
              <index><primary><em>Eman</em>cipation</primary></index>
              <index><primary>zebra</primary></index>
              <index><primary><em>Eman</em>cipation</primary><secondary>dans les &#xC9;tats-Unis</secondary></index>
              <index><primary><em>Eman</em>cipation</primary><secondary>dans la France</secondary><tertiary>&#xE0; Paris</tertiary></index>
              <index-xref also="true"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target>zebra</target></index-xref>
              <index-xref also="true"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target><em>Eman</em>cipation</target></index-xref>
              <index-xref also="false"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target>zebra</target></index-xref>
              <index-xref also="false"><primary><em>Dasein</em></primary><target>&#xEA;tre</target></index-xref>
              <index-xref also="false"><primary><em>Dasein</em></primary><target><em>Eman</em>cipation</target></index-xref>
            </clause>
          </clause>
        </sections>
      </bipm-standard>
    INPUT
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(<<~"OUTPUT")

        <bipm-standard xmlns='https://open.ribose.com/standards/bipm' type='presentation'>
          <bibdata>
            <language current='true'>en</language>
            <script current='true'>Latn</script>
          </bibdata>
          <sections>
            <clause id='A' displayorder="1">
              <title>1.</title>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <clause id='B'>
                <title>1.1.</title>
                <bookmark id='_'/>
                <bookmark id='_'/>
                <bookmark id='_'/>
                <bookmark id='_'/>
              </clause>
            </clause>
          </sections>
          <indexsect id='_' displayorder="2">
            <title>Index</title>
            <clause id='_'>
              <title>D</title>
              <ul>
                <li>
                  <em>Dasein</em>
                  , see <em>Eman</em>cipation, &#xEA;tre
                </li>
              </ul>
            </clause>
            <clause id='_'>
              <title>E</title>
              <ul>
                <li>
                  &#xE9;long&#xE9;,
                  <xref target='_' pagenumber='true'>Chapter 1</xref>
                </li>
                <li>
                  <em>Eman</em>cipation,
                  <xref target='_' pagenumber='true'>Chapter 1</xref>
                  ,
                  <xref target='_' pagenumber='true'>Section 1.1</xref>
                  <ul>
                    <li>
                      dans la France,
                      <xref target='_' pagenumber='true'>Chapter 1</xref>
                      <ul>
                        <li>
                          &#xE0; Paris,
                          <xref target='_' pagenumber='true'>Section 1.1</xref>
                        </li>
                        <li>
                          en Bretagne,
                          <xref target='_' pagenumber='true'>Chapter 1</xref>
                        </li>
                      </ul>
                    </li>
                    <li>
                      dans les &#xC9;tats-Unis,
                      <xref target='_' pagenumber='true'>Section 1.1</xref>
                    </li>
                  </ul>
                </li>
                <li>
                  &#xEA;tre
                  <ul>
                    <li>
                      Husserl, see zebra, see also <em>Eman</em>cipation, zebra
                      <ul>
                        <li>
                          en allemand,
                          <xref target='_' pagenumber='true'>Chapter 1</xref>
                        </li>
                      </ul>
                    </li>
                  </ul>
                </li>
              </ul>
            </clause>
            <clause id='_'>
              <title>Z</title>
              <ul>
                <li>
                  zebra,
                  <xref target='_' pagenumber='true'>Section 1.1</xref>
                </li>
              </ul>
            </clause>
          </indexsect>
        </bipm-standard>
    OUTPUT
  end

  it "generates an index in French" do
    input = <<~INPUT
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <bibdata>
          <language>fr</language>
          <script>Latn</script>
        </bibdata>
        <sections>
          <clause id="A">
            <xref target="I"/>
            <index to="End"><primary>&#xE9;long&#xE9;</primary></index>
            <index><primary>&#xEA;tre</primary><secondary>Husserl</secondary><tertiary>en allemand</tertiary></index>
            <index><primary>Emancipation</primary></index>
            <index><primary>Emancipation</primary><secondary>dans la France</secondary></index>
            <index><primary>Emancipation</primary><secondary>dans la France</secondary><tertiary>en Bretagne</tertiary></index>
            <clause id="B">
              <index><primary>Emancipation</primary></index>
              <index><primary>zebra</primary></index>
              <index><primary>Emancipation</primary><secondary>dans les &#xC9;tats-Unis</secondary></index>
              <index><primary>Emancipation</primary><secondary>dans la France</secondary><tertiary>&#xE0; Paris</tertiary></index>
              <index-xref also="true"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target>zebra</target></index-xref>
              <index-xref also="true"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target>Emancipation</target></index-xref>
              <index-xref also="false"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target>zebra</target></index-xref>
              <index-xref also="false"><primary><em>Dasein</em></primary><target>&#xEA;tre</target></index-xref>
              <index-xref also="false"><primary><em>Dasein</em></primary><target>Emancipation</target></index-xref>
              <bookmark id="End"/>
            </clause>
          </clause>
        </sections>
        <indexsect id="I">
          <title>Index</title>
          <p>Voici un index</p>
        </indexsect>
      </bipm-standard>
    INPUT
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(<<~"OUTPUT")
        <bipm-standard xmlns='https://open.ribose.com/standards/bipm' type='presentation'>
          <bibdata>
            <language current='true'>fr</language>
            <script current='true'>Latn</script>
          </bibdata>
          <sections>
            <clause id='A' displayorder="1">
              <title>1.</title>
              <xref target='I'>Index</xref>
              <bookmark to='End' id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <clause id='B'>
                <title>1.1.</title>
                <bookmark id='_'/>
                <bookmark id='_'/>
                <bookmark id='_'/>
                <bookmark id='_'/>
                <bookmark id='End'/>
              </clause>
            </clause>
          </sections>
          <indexsect id='I' displayorder="2">
            <title>Index</title>
            <p>Voici un index</p>
            <clause id='_'>
              <title>D</title>
              <ul>
                <li>
                  <em>Dasein</em>
                  ,
                  <em>voir</em>
                   Emancipation, &#xEA;tre
                </li>
              </ul>
            </clause>
            <clause id='_'>
              <title>E</title>
              <ul>
                <li>
                  &#xE9;long&#xE9;,
                  <xref target='_' to='End' pagenumber='true'>chap&#xEE;tre 1</xref>
                </li>
                <li>
                  Emancipation,
                  <xref target='_' pagenumber='true'>chap&#xEE;tre 1</xref>
                  ,
                  <xref target='_' pagenumber='true'>section 1.1</xref>
                  <ul>
                    <li>
                      dans la France,
                      <xref target='_' pagenumber='true'>chap&#xEE;tre 1</xref>
                      <ul>
                        <li>
                          &#xE0; Paris,
                          <xref target='_' pagenumber='true'>section 1.1</xref>
                        </li>
                        <li>
                          en Bretagne,
                          <xref target='_' pagenumber='true'>chap&#xEE;tre 1</xref>
                        </li>
                      </ul>
                    </li>
                    <li>
                      dans les &#xC9;tats-Unis,
                      <xref target='_' pagenumber='true'>section 1.1</xref>
                    </li>
                  </ul>
                </li>
                <li>
                  &#xEA;tre
                  <ul>
                    <li>
                      Husserl,
                      <em>voir</em>
                       zebra,
                      <em>voir aussi</em>
                       Emancipation, zebra
                      <ul>
                        <li>
                          en allemand,
                          <xref target='_' pagenumber='true'>chap&#xEE;tre 1</xref>
                        </li>
                      </ul>
                    </li>
                  </ul>
                </li>
              </ul>
            </clause>
            <clause id='_'>
              <title>Z</title>
              <ul>
                <li>
                  zebra,
                  <xref target='_' pagenumber='true'>section 1.1</xref>
                </li>
              </ul>
            </clause>
          </indexsect>
        </bipm-standard>
    OUTPUT
  end

  it "processes bibliographic localities" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          <script>Latn</script>
          </bibdata>
          <preface><foreword>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
        <eref bibitemid="ISO712"><locality type="clause"><referenceFrom>3</referenceFrom></locality></eref>
        <eref bibitemid="ISO712"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></eref>
        <eref bibitemid="ISO712"><locality type="table"><referenceFrom>3.1</referenceFrom></locality></eref>
        </p>
        </foreword></preface>
        <bibliography><references id="_normative_references" obligation="informative" normative="true"><title>Normative References</title>
        <bibitem id="ISO712" type="standard">
        <title format="text/plain">Cereals or cereal products</title>
        <title type="main" format="text/plain">Cereals and cereal products</title>
        <docidentifier type="ISO">ISO 712</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
          </organization>
        </contributor>
      </bibitem>
      </references>
      </bibliography>
      </iso-standard>
    INPUT

    presxml = <<~PRESXML
      <foreword displayorder="1">
        <p id='_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f'>
          <eref bibitemid='ISO712'>
            <locality type='clause'>
              <referenceFrom>3</referenceFrom>
            </locality>
            ISO 712, Clause 3
          </eref>
          <eref bibitemid='ISO712'>
            <locality type='clause'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            ISO 712, Clause 3.1
          </eref>
          <eref bibitemid='ISO712'>
            <locality type='table'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            ISO 712, Table 3.1
          </eref>
        </p>
      </foreword>
    PRESXML

    expect(xmlpp(Nokogiri::XML(IsoDoc::BIPM::PresentationXMLConvert.new({})
    .convert("test", input, true))
    .at(".//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "processes bibliographic localities in JCGM" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          <script>Latn</script>
          <ext>
                  <editorialgroup>
                    <committee acronym="JCGM">
                      <variant language="en" script="Latn">TC</variant>
                      <variant language="fr" script="Latn">CT</variant>
                    </committee>
                    <workgroup acronym="B">WC</committee>
                  </editorialgroup>
                 </ext>
          </bibdata>
          <preface><foreword>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
        <eref bibitemid="ISO712"><locality type="clause"><referenceFrom>3</referenceFrom></locality></eref>
        <eref bibitemid="ISO712"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></eref>
        <eref bibitemid="ISO712"><locality type="table"><referenceFrom>3.1</referenceFrom></locality></eref>
        </p>
        </foreword></preface>
        <bibliography><references id="_normative_references" obligation="informative" normative="true"><title>Normative References</title>
        <bibitem id="ISO712" type="standard">
        <title format="text/plain">Cereals or cereal products</title>
        <title type="main" format="text/plain">Cereals and cereal products</title>
        <docidentifier type="ISO">ISO 712</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
          </organization>
        </contributor>
      </bibitem>
      </references>
      </bibliography>
      </iso-standard>
    INPUT

    presxml = <<~PRESXML
      <foreword displayorder="1">
        <p id='_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f'>
          <eref bibitemid='ISO712'>
            <locality type='clause'>
              <referenceFrom>3</referenceFrom>
            </locality>
            [ISO 712], <span class='citesec'>Clause 3</span>
          </eref>
          <eref bibitemid='ISO712'>
            <locality type='clause'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            [ISO 712], <span class='citesec'>3.1</span>
          </eref>
          <eref bibitemid='ISO712'>
            <locality type='table'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            [ISO 712], <span class='citetbl'>Table 3.1</span>
          </eref>
        </p>
      </foreword>
    PRESXML

    expect(xmlpp(Nokogiri::XML(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at(".//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "handles brackets for multiple erefs in JCGM" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          <script>Latn</script>
          <ext>
           <editorialgroup>
                    <committee acronym="JCGM">
                      <variant language="en" script="Latn">TC</variant>
                      <variant language="fr" script="Latn">CT</variant>
                    </committee>
                    <workgroup acronym="B">WC</committee>
                  </editorialgroup>
                 </ext>
                    </bibdata>
          <preface><foreword>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
        <eref bibitemid="ISO712"/> <eref bibitemid="ISO712"/>
        and
        <eref bibitemid="ISO712"/>, <eref bibitemid="ISO712"/>
        and
        <eref bibitemid="ISO712"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></eref>
        <eref bibitemid="ISO712"><locality type="table"><referenceFrom>3.1</referenceFrom></locality></eref>
        </p>
        </foreword></preface>
        <bibliography><references id="_normative_references" obligation="informative" normative="true"><title>Normative References</title>
        <bibitem id="ISO712" type="standard">
        <title format="text/plain">Cereals or cereal products</title>
        <title type="main" format="text/plain">Cereals and cereal products</title>
        <docidentifier type="ISO">ISO 712</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
          </organization>
        </contributor>
      </bibitem>
      </references>
      </bibliography>
      </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <foreword displayorder="1">
        <p id='_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f'>
           [
          <eref bibitemid='ISO712'>ISO 712</eref>
          ] [
          <eref bibitemid='ISO712'>ISO 712</eref>
          ] and [
          <eref bibitemid='ISO712'>ISO 712</eref>
          ,
          <eref bibitemid='ISO712'>ISO 712</eref>
          ] and
          <eref bibitemid='ISO712'>
            <locality type='clause'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            [ISO 712], <span class='citesec'>3.1</span>
          </eref>
          <eref bibitemid='ISO712'>
            <locality type='table'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            [ISO 712], <span class='citetbl'>Table 3.1</span>
          </eref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at(".//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "processes notes in French" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>fr</language>
          <script>Latn</script>
          </bibdata>
          <preface><foreword id="A">
        <p id="B">abc</p>
        <note id="C">Hello</note>
        <ul id="D">
        <li><p id="E">List item</p>
        <note id="F">List note</note>
        </li>
        </ul>
        </foreword></preface>
        <sections><clause id="A1">
        <p id="B1">abc</p>
        <note id="C1">Hello</note>
        <ul id="D1">
        <li><p id="E1">List item</p>
        <note id="F1">List note</note>
        </li>
        </ul>
        </clause></sections>
      </iso-standard>
    INPUT

    presxml = <<~PRESXML
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <bibdata>
           <language current='true'>fr</language>
           <script current='true'>Latn</script>
         </bibdata>
         <preface>
           <foreword id='A' displayorder='1'>
             <p id='B'>abc</p>
             <note id='C'>
               <name>NOTE&#xA0;:</name>
               Hello
             </note>
             <ul id='D'>
               <li>
                 <p id='E'>List item</p>
                 <note id='F'>
                   <name>NOTE&#xA0;:</name>
                   List note
                 </note>
               </li>
             </ul>
           </foreword>
         </preface>
         <sections>
           <clause id='A1' displayorder='2'>
             <title>1.</title>
             <p id='B1'>abc</p>
             <note id='C1'>
               <name>Note&#xA0;:</name>
               Hello
             </note>
             <ul id='D1'>
               <li>
                 <p id='E1'>List item</p>
                 <note id='F1'>
                   <name>Remarque&#xA0;:</name>
                   List note
                 </note>
               </li>
             </ul>
           </clause>
         </sections>
       </iso-standard>
    PRESXML

    xml = Nokogiri::XML(IsoDoc::BIPM::PresentationXMLConvert.new({})
    .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    expect(xmlpp(xml.to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end
end
