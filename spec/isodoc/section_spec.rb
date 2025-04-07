require "spec_helper"

RSpec.describe IsoDoc::Bipm do
  it "processes duplicate ids between Semantic and Presentation XML titles" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
           <sections>
           <clause id="A1">
           <title>Title <bookmark id="A2"/> <index><primary>title</primary></index></title>
           </clause>
           <clause id="A2">
           <variant-title type='quoted'>Title <bookmark id="A3"/> <index><primary>title2</primary></index></variant-title>
           </clause>
           </sections>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <clause id="A1" displayorder="2">
                <title id="_">
                   Title
                   <bookmark original-id="A2"/>
                </title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A1">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">
                      Title
                      <bookmark id="A2"/>
                      <bookmark id="_"/>
                   </semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Chapter</span>
                   <semx element="autonum" source="A1">1</semx>
                </fmt-xref-label>
             </clause>
             <clause id="A2" displayorder="3">
                <title type="quoted">
                   <blacksquare/>
                   Title
                   <bookmark original-id="A3"/>
                </title>
                <fmt-title type="quoted" depth="1">
                   <blacksquare/>
                   Title
                   <bookmark id="A3"/>
                   <bookmark id="_"/>
                </fmt-title>
             </clause>
          </sections>
          <indexsect id="_" displayorder="4">
             <title>Index</title>
             <clause id="_">
                <title>T</title>
                <ul>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      title,
                      <xref target="_" pagenumber="true" id="_"/>
                      <semx element="xref" source="_">
                         <fmt-xref target="_" pagenumber="true">
                            <span class="fmt-element-name">Chapter</span>
                            <semx element="autonum" source="A1">1</semx>
                         </fmt-xref>
                      </semx>
                   </li>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      title2,
                      <xref target="_" pagenumber="true" id="_"/>
                      <semx element="xref" source="_">
                         <fmt-xref target="_" pagenumber="true">
                            <span class="fmt-element-name">Chapter</span>
                            <semx element="autonum" source="A1">1</semx>
                         </fmt-xref>
                      </semx>
                   </li>
                </ul>
             </clause>
          </indexsect>
       </iso-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "generates document control text" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::Bipm::VERSION}" type="semantic">
        <bibdata type="standard">
          <title language='en' format='text/plain' type='title-main'>Main Title</title>
          <title language='en' format='text/plain' type='title-cover'>Main Title (SI)</title>
          <title language='en' format='text/plain' type='title-appendix'>Main Title (SI)</title>
            <contributor>
              <role type="author"/>
              <organization>
                <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
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
        <sections>
        <clause/>
        </sections>
      </bipm-standard>
    INPUT

    presxml = Xml::C14n.format(<<~"OUTPUT")
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" version="#{Metanorma::Bipm::VERSION}" type="presentation">
        <bibdata type="standard">
        <title language="en" format="text/plain" type="title-main">Main Title</title>
        <title language="en" format="text/plain" type="title-cover">Main Title (SI)</title>
        <title language="en" format="text/plain" type="title-appendix">Main Title (SI)</title>
          <contributor>
            <role type="author"/>
            <organization>
              <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
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
              <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
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
                 <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <clause displayorder="2"/>
          </sections>
          <doccontrol displayorder="999">
             <fmt-title>Document Control</fmt-title>
             <table unnumbered="true">
                <tbody>
                   <tr>
                      <th>Authors:</th>
                      <td/>
                      <td>
                         Andrew Yacoot (NPL)
                         <span class="fmt-enum-comma">,</span>
                         Ulrich Kuetgens (PTB)
                         <span class="fmt-enum-comma">,</span>
                         <span class="fmt-conn">and</span>
                         Enrico Massa (INRIM)
                      </td>
                   </tr>
                   <tr>
                      <td>Draft 1.0 Version 1.0</td>
                      <td>2018-06-11</td>
                      <td>
                         WG-N co-chairs: Ronald Dixson (NIST)
                         <span class="fmt-conn">and</span>
                         Harald Bosse (PTB)
                      </td>
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

    output = Xml::C14n.format(<<~"OUTPUT")
      #{HTML_HDR}
               <br/>
            <div id="_" class="TOC">
              <h1 class="IntroTitle">Contents</h1>
            </div>
            <div> <h1/> </div>
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
    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to(be_equivalent_to(Xml::C14n.format(presxml)))
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to(be_equivalent_to(output))
  end

  it "generates shorter document control text" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::Bipm::VERSION}" type="semantic">
        <bibdata type="standard">
          <title language='en' format='text/plain' type='title-main'>Main Title</title>
          <title language='en' format='text/plain' type='title-cover'>Main Title (SI)</title>
          <title language='en' format='text/plain' type='title-appendix'>Main Title (SI)</title>
            <contributor>
              <role type="author"/>
              <organization>
                <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
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
        <sections>
        <clause/>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~PRESXML
      <bipm-standard xmlns='https://www.metanorma.org/ns/bipm' version="#{Metanorma::Bipm::VERSION}" type='presentation'>
      <bibdata type='standard'>
             <title language='en' format='text/plain' type='title-main'>Main Title</title>
             <title language='en' format='text/plain' type='title-cover'>Main Title (SI)</title>
             <title language='en' format='text/plain' type='title-appendix'>Main Title (SI)</title>
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
             <preface>
              <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
              </clause>
            </preface>
            <sections>
           <clause displayorder="2"/>
         </sections>
         <doccontrol displayorder="999">
             <fmt-title>Document Control</fmt-title>
             <table unnumbered='true'>
               <tbody>
                 <tr>
                   <th>Authors:</th>
                   <td/>
                   <td>Andrew Yacoot (NPL) <span class="fmt-conn">and</span> Ulrich Kuetgens (PTB)</td>
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
               <br/>
            <div id="_" class="TOC">
              <h1 class="IntroTitle">Contents</h1>
            </div>
            <div> <h1/> </div>
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
    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to(be_equivalent_to(Xml::C14n.format(presxml)))
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to(be_equivalent_to(output))
  end

    it "processes simple terms & definitions" do
    input = <<~INPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
          <terms id="H" obligation="normative">
            <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <term id="J">
              <preferred><expression><name>Term2</name></expression></preferred>
              <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
            </term>
            <term id="K">
              <preferred><expression><name>Term3</name></expression></preferred>
                   <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f893">
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termnote id="_671a1994-4783-40d0-bc81-987d06ffb74e"  keep-with-next="true" keep-lines-together="true">
        <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
      </termnote>
      <termnote id="_671a1994-4783-40d0-bc81-987d06ffb74f">
      <ul><li>A</li></ul>
        <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
      </termnote>
              <termsource status="identical">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.2</referenceFrom></locality></origin>
      </termsource>
            </term>
          </terms>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~INPUT
       <bipm-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <terms id="H" obligation="normative" displayorder="2">
                <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Chapter</span>
                   <semx element="autonum" source="H">1</semx>
                </fmt-xref-label>
                <term id="J">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="J">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="J">1</semx>
                   </fmt-xref-label>
                   <preferred id="_">
                      <expression>
                         <name>Term2</name>
                      </expression>
                   </preferred>
                   <fmt-preferred>
                      <p>
                         <semx element="preferred" source="_">
                            <strong>Term2</strong>
                         </semx>
                      </p>
                   </fmt-preferred>
                   <termsource status="modified" id="_">
                      <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                         <locality type="clause">
                            <referenceFrom>3.1</referenceFrom>
                         </locality>
                      </origin>
                      <modification>
                         <p original-id="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
                      </modification>
                   </termsource>
                   <fmt-termsource status="modified">
                      [Modified from:
                      <semx element="termsource" source="_">
                         <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_">
                            <locality type="clause">
                               <referenceFrom>3.1</referenceFrom>
                            </locality>
                         </origin>
                         <semx element="origin" source="_">
                            <fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                               ISO 7301:2011, Clause 3.1
                            </fmt-origin>
                         </semx>
                         —
                         <semx element="modification" source="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</semx>
                      </semx>
                      ]
                   </fmt-termsource>
                </term>
                <term id="K">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="K">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="K">2</semx>
                   </fmt-xref-label>
                   <preferred id="_">
                      <expression>
                         <name>Term3</name>
                      </expression>
                   </preferred>
                   <fmt-preferred>
                      <p>
                         <semx element="preferred" source="_">
                            <strong>Term3</strong>
                         </semx>
                      </p>
                   </fmt-preferred>
                   <termexample id="_" autonum="">
                      <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">EXAMPLE</span>
                         </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                      </fmt-xref-label>
                      <fmt-xref-label container="K">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Section</span>
                            <semx element="autonum" source="H">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="K">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                      </fmt-xref-label>
                      <ul>
                         <li>
                            <fmt-name>
                               <semx element="autonum" source="">•</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <termnote id="_" keep-with-next="true" keep-lines-together="true" autonum="1">
                      <fmt-name>
                         <span class="fmt-caption-label">
                            Note
                            <semx element="autonum" source="_">1</semx>
                            to entry
                         </span>
                         <span class="fmt-label-delim">: </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="K">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Section</span>
                            <semx element="autonum" source="H">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="K">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </termnote>
                   <termnote id="_" autonum="2">
                      <fmt-name>
                         <span class="fmt-caption-label">
                            Note
                            <semx element="autonum" source="_">2</semx>
                            to entry
                         </span>
                         <span class="fmt-label-delim">: </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="K">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Section</span>
                            <semx element="autonum" source="H">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="K">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <ul>
                         <li>
                            <fmt-name>
                               <semx element="autonum" source="">•</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                      <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </termnote>
                   <termsource status="identical" id="_">
                      <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                         <locality type="clause">
                            <referenceFrom>3.2</referenceFrom>
                         </locality>
                      </origin>
                   </termsource>
                   <fmt-termsource status="identical">
                      [
                      <semx element="termsource" source="_">
                         <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_">
                            <locality type="clause">
                               <referenceFrom>3.2</referenceFrom>
                            </locality>
                         </origin>
                         <semx element="origin" source="_">
                            <fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                               <locality type="clause">
                                  <referenceFrom>3.2</referenceFrom>
                               </locality>
                               ISO 7301:2011, Clause 3.2
                            </fmt-origin>
                         </semx>
                      </semx>
                      ]
                   </fmt-termsource>
                </term>
             </terms>
          </sections>
       </bipm-standard>
    INPUT

    output = Xml::C14n.format(<<~OUTPUT)
      <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
         <div class="title-section">
            <p> </p>
         </div>
         <br/>
         <div class="prefatory-section">
            <p> </p>
         </div>
         <br/>
         <div class="main-section">
            <br/>
            <div id="_" class="TOC">
               <h1 class="IntroTitle">Contents</h1>
            </div>
            <div id="H">
               <h1>1.  Terms, Definitions, Symbols and Abbreviated Terms</h1>
               <p class="TermNum" id="J">1.1.</p>
               <p class="Terms" style="text-align:left;">
                  <b>Term2</b>
               </p>
               <p>[Modified from:
        ISO 7301:2011, Clause 3.1
           — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here
      ]</p>
               <p class="TermNum" id="K">1.2.</p>
               <p class="Terms" style="text-align:left;">
                  <b>Term3</b>
               </p>
               <div id="_" class="example">
                  <p class="example-title">EXAMPLE</p>
                  <div class="ul_wrap">
                     <ul>
                        <li>A</li>
                     </ul>
                  </div>
               </div>
               <div id="_" class="Note" style="page-break-after: avoid;page-break-inside: avoid;">
                  <p>
                     <span class="termnote_label">Note 1 to entry: </span>
                     The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.
                  </p>
               </div>
               <div id="_" class="Note">
                  <p>
                     <span class="termnote_label">Note 2 to entry: </span>
                  </p>
                  <div class="ul_wrap">
                     <ul>
                        <li>A</li>
                     </ul>
                  </div>
                  <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
               </div>
               <p>[
        ISO 7301:2011, Clause 3.2
      ]</p>
            </div>
         </div>
      </body>
    OUTPUT

    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to(be_equivalent_to(Xml::C14n.format(presxml)))
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to(be_equivalent_to(output))

    presxml = <<~INPUT
       <bipm-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
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
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <terms id="H" obligation="normative" displayorder="2">
                <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="H">1</semx>
                </fmt-xref-label>
                <term id="J">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="J">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="J">1</semx>
                   </fmt-xref-label>
                   <preferred id="_">
                      <expression>
                         <name>Term2</name>
                      </expression>
                   </preferred>
                   <fmt-preferred>
                      <p>
                         <semx element="preferred" source="_">
                            <strong>Term2</strong>
                         </semx>
                      </p>
                   </fmt-preferred>
                   <termsource status="modified" id="_">
                      <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                         <locality type="clause">
                            <referenceFrom>3.1</referenceFrom>
                         </locality>
                      </origin>
                      <modification>
                         <p original-id="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
                      </modification>
                   </termsource>
                   <fmt-termsource status="modified">
                      [Modified from:
                      <semx element="termsource" source="_">
                         <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_">
                            <locality type="clause">
                               <referenceFrom>3.1</referenceFrom>
                            </locality>
                         </origin>
                         <semx element="origin" source="_">
                            <fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                               ISO 7301:2011,
                               <span class="citesec">3.1</span>
                            </fmt-origin>
                         </semx>
                         —
                         <semx element="modification" source="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</semx>
                      </semx>
                      ]
                   </fmt-termsource>
                </term>
                <term id="K">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="K">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="K">2</semx>
                   </fmt-xref-label>
                   <preferred id="_">
                      <expression>
                         <name>Term3</name>
                      </expression>
                   </preferred>
                   <fmt-preferred>
                      <p>
                         <semx element="preferred" source="_">
                            <strong>Term3</strong>
                         </semx>
                      </p>
                   </fmt-preferred>
                   <termexample id="_" autonum="">
                      <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">EXAMPLE</span>
                         </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                      </fmt-xref-label>
                      <fmt-xref-label container="K">
                         <span class="fmt-xref-container">
                            <semx element="autonum" source="H">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="K">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                      </fmt-xref-label>
                      <ul>
                         <li>
                            <fmt-name>
                               <semx element="autonum" source="">•</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <termnote id="_" keep-with-next="true" keep-lines-together="true" autonum="1">
                      <fmt-name>
                         <span class="fmt-caption-label">
                            Note
                            <semx element="autonum" source="_">1</semx>
                            to entry
                         </span>
                         <span class="fmt-label-delim">: </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="K">
                         <span class="fmt-xref-container">
                            <semx element="autonum" source="H">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="K">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </termnote>
                   <termnote id="_" autonum="2">
                      <fmt-name>
                         <span class="fmt-caption-label">
                            Note
                            <semx element="autonum" source="_">2</semx>
                            to entry
                         </span>
                         <span class="fmt-label-delim">: </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="K">
                         <span class="fmt-xref-container">
                            <semx element="autonum" source="H">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="K">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <ul>
                         <li>
                            <fmt-name>
                               <semx element="autonum" source="">•</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                      <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </termnote>
                   <termsource status="identical" id="_">
                      <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                         <locality type="clause">
                            <referenceFrom>3.2</referenceFrom>
                         </locality>
                      </origin>
                   </termsource>
                   <fmt-termsource status="identical">
                      [
                      <semx element="termsource" source="_">
                         <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_">
                            <locality type="clause">
                               <referenceFrom>3.2</referenceFrom>
                            </locality>
                         </origin>
                         <semx element="origin" source="_">
                            <fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                               <locality type="clause">
                                  <referenceFrom>3.2</referenceFrom>
                               </locality>
                               ISO 7301:2011,
                               <span class="citesec">3.2</span>
                            </fmt-origin>
                         </semx>
                      </semx>
                      ]
                   </fmt-termsource>
                </term>
             </terms>
          </sections>
       </bipm-standard>
    INPUT

    output = Xml::C14n.format(<<~OUTPUT)
      <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
         <div class="title-section">
            <p> </p>
         </div>
         <br/>
         <div class="prefatory-section">
            <p> </p>
         </div>
         <br/>
         <div class="main-section">
            <br/>
            <div id="_" class="TOC">
               <h1 class="IntroTitle">Contents</h1>
            </div>
            <div id="H">
               <h1>1.  Terms, Definitions, Symbols and Abbreviated Terms</h1>
               <p class="TermNum" id="J">1.1.</p>
               <p class="Terms" style="text-align:left;">
                  <b>Term2</b>
               </p>
               <p>
                  [Modified from: ISO 7301:2011,
                  <span class="citesec">3.1</span>
                  — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here ]
               </p>
               <p class="TermNum" id="K">1.2.</p>
               <p class="Terms" style="text-align:left;">
                  <b>Term3</b>
               </p>
               <div id="_" class="example">
                  <p class="example-title">EXAMPLE</p>
                  <div class="ul_wrap">
                     <ul>
                        <li>A</li>
                     </ul>
                  </div>
               </div>
               <div id="_" class="Note" style="page-break-after: avoid;page-break-inside: avoid;">
                  <p>
                     <span class="termnote_label">Note 1 to entry: </span>
                     The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.
                  </p>
               </div>
               <div id="_" class="Note">
                  <p>
                     <span class="termnote_label">Note 2 to entry: </span>
                  </p>
                  <div class="ul_wrap">
                     <ul>
                        <li>A</li>
                     </ul>
                  </div>
                  <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
               </div>
               <p>
                  [ ISO 7301:2011,
                  <span class="citesec">3.2</span>
                  ]
               </p>
            </div>
         </div>
      </body>
    OUTPUT
    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input.sub("<sections>",
                                   "<bibdata>#{jcgm_ext}</bibdata><sections>"), true)
    expect(Xml::C14n.format(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to(be_equivalent_to(Xml::C14n.format(presxml)))
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to(be_equivalent_to(output))
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
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to Xml::C14n.format(<<~OUTPUT)
       <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
          <bibdata>
             <language current="true">en</language>
             <script current="true">Latn</script>
          </bibdata>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <clause id="A" displayorder="2">
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Chapter</span>
                   <semx element="autonum" source="A">1</semx>
                </fmt-xref-label>
                <bookmark id="_"/>
                <bookmark id="_"/>
                <bookmark id="_"/>
                <bookmark id="_"/>
                <bookmark id="_"/>
                <clause id="B">
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="B">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="B">1</semx>
                   </fmt-xref-label>
                   <bookmark id="_"/>
                   <bookmark id="_"/>
                   <bookmark id="_"/>
                   <bookmark id="_"/>
                </clause>
             </clause>
          </sections>
          <indexsect id="_" displayorder="3">
             <title>Index</title>
             <clause id="_">
                <title>D</title>
                <ul>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      <em>Dasein</em>
                      , see
                      <em>Eman</em>
                      cipation, être
                   </li>
                </ul>
             </clause>
             <clause id="_">
                <title>E</title>
                <ul>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      élongé,
                      <xref target="_" pagenumber="true" id="_"/>
                      <semx element="xref" source="_">
                         <fmt-xref target="_" pagenumber="true">
                            <span class="fmt-element-name">Chapter</span>
                            <semx element="autonum" source="A">1</semx>
                         </fmt-xref>
                      </semx>
                   </li>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      <em>Eman</em>
                      cipation,
                      <xref target="_" pagenumber="true" id="_"/>
                      <semx element="xref" source="_">
                         <fmt-xref target="_" pagenumber="true">
                            <span class="fmt-element-name">Chapter</span>
                            <semx element="autonum" source="A">1</semx>
                         </fmt-xref>
                      </semx>
                      ,
                      <xref target="_" pagenumber="true" id="_"/>
                      <semx element="xref" source="_">
                         <fmt-xref target="_" pagenumber="true">
                            <span class="fmt-element-name">Section</span>
                            <semx element="autonum" source="A">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="B">1</semx>
                         </fmt-xref>
                      </semx>
                      <ul>
                         <li>
                            <fmt-name>
                               <semx element="autonum" source="">−</semx>
                            </fmt-name>
                            dans la France,
                            <xref target="_" pagenumber="true" id="_"/>
                            <semx element="xref" source="_">
                               <fmt-xref target="_" pagenumber="true">
                                  <span class="fmt-element-name">Chapter</span>
                                  <semx element="autonum" source="A">1</semx>
                               </fmt-xref>
                            </semx>
                            <ul>
                               <li>
                                  <fmt-name>
                                     <semx element="autonum" source="">o</semx>
                                  </fmt-name>
                                  à Paris,
                                  <xref target="_" pagenumber="true" id="_"/>
                                  <semx element="xref" source="_">
                                     <fmt-xref target="_" pagenumber="true">
                                        <span class="fmt-element-name">Section</span>
                                        <semx element="autonum" source="A">1</semx>
                                        <span class="fmt-autonum-delim">.</span>
                                        <semx element="autonum" source="B">1</semx>
                                     </fmt-xref>
                                  </semx>
                               </li>
                               <li>
                                  <fmt-name>
                                     <semx element="autonum" source="">o</semx>
                                  </fmt-name>
                                  en Bretagne,
                                  <xref target="_" pagenumber="true" id="_"/>
                                  <semx element="xref" source="_">
                                     <fmt-xref target="_" pagenumber="true">
                                        <span class="fmt-element-name">Chapter</span>
                                        <semx element="autonum" source="A">1</semx>
                                     </fmt-xref>
                                  </semx>
                               </li>
                            </ul>
                         </li>
                         <li>
                            <fmt-name>
                               <semx element="autonum" source="">−</semx>
                            </fmt-name>
                            dans les États-Unis,
                            <xref target="_" pagenumber="true" id="_"/>
                            <semx element="xref" source="_">
                               <fmt-xref target="_" pagenumber="true">
                                  <span class="fmt-element-name">Section</span>
                                  <semx element="autonum" source="A">1</semx>
                                  <span class="fmt-autonum-delim">.</span>
                                  <semx element="autonum" source="B">1</semx>
                               </fmt-xref>
                            </semx>
                         </li>
                      </ul>
                   </li>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      être
                      <ul>
                         <li>
                            <fmt-name>
                               <semx element="autonum" source="">−</semx>
                            </fmt-name>
                            Husserl, see zebra, see also
                            <em>Eman</em>
                            cipation, zebra
                            <ul>
                               <li>
                                  <fmt-name>
                                     <semx element="autonum" source="">o</semx>
                                  </fmt-name>
                                  en allemand,
                                  <xref target="_" pagenumber="true" id="_"/>
                                  <semx element="xref" source="_">
                                     <fmt-xref target="_" pagenumber="true">
                                        <span class="fmt-element-name">Chapter</span>
                                        <semx element="autonum" source="A">1</semx>
                                     </fmt-xref>
                                  </semx>
                               </li>
                            </ul>
                         </li>
                      </ul>
                   </li>
                </ul>
             </clause>
             <clause id="_">
                <title>Z</title>
                <ul>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      zebra,
                      <xref target="_" pagenumber="true" id="_"/>
                      <semx element="xref" source="_">
                         <fmt-xref target="_" pagenumber="true">
                            <span class="fmt-element-name">Section</span>
                            <semx element="autonum" source="A">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="B">1</semx>
                         </fmt-xref>
                      </semx>
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
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to Xml::C14n.format(<<~OUTPUT)
       <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
          <bibdata>
             <language current="true">fr</language>
             <script current="true">Latn</script>
          </bibdata>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Table des matières</fmt-title>
             </clause>
          </preface>
          <sections>
             <clause id="A" displayorder="2">
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">chapitre</span>
                   <semx element="autonum" source="A">1</semx>
                </fmt-xref-label>
                <xref target="I" id="_"/>
                <semx element="xref" source="_">
                   <fmt-xref target="I">
                      <semx element="indexsect" source="I">Index</semx>
                   </fmt-xref>
                </semx>
                <bookmark id="_"/>
                <bookmark id="_"/>
                <bookmark id="_"/>
                <bookmark id="_"/>
                <bookmark id="_"/>
                <clause id="B">
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="B">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">section</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="B">1</semx>
                   </fmt-xref-label>
                   <bookmark id="_"/>
                   <bookmark id="_"/>
                   <bookmark id="_"/>
                   <bookmark id="_"/>
                   <bookmark id="End"/>
                </clause>
             </clause>
          </sections>
          <indexsect id="I" displayorder="3">
             <title id="_">Index</title>
             <fmt-title depth="1">
                <semx element="title" source="_">Index</semx>
             </fmt-title>
             <p>Voici un index</p>
             <clause id="_">
                <title>D</title>
                <ul>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      <em>Dasein</em>
                      ,
                      <em>voir</em>
                      Emancipation, être
                   </li>
                </ul>
             </clause>
             <clause id="_">
                <title>E</title>
                <ul>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      élongé,
                      <xref target="_" to="End" pagenumber="true" id="_"/>
                      <semx element="xref" source="_">
                         <fmt-xref target="_" to="End" pagenumber="true">
                            <span class="fmt-element-name">chapitre</span>
                            <semx element="autonum" source="A">1</semx>
                         </fmt-xref>
                      </semx>
                   </li>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      Emancipation,
                      <xref target="_" pagenumber="true" id="_"/>
                      <semx element="xref" source="_">
                         <fmt-xref target="_" pagenumber="true">
                            <span class="fmt-element-name">chapitre</span>
                            <semx element="autonum" source="A">1</semx>
                         </fmt-xref>
                      </semx>
                      ,
                      <xref target="_" pagenumber="true" id="_"/>
                      <semx element="xref" source="_">
                         <fmt-xref target="_" pagenumber="true">
                            <span class="fmt-element-name">section</span>
                            <semx element="autonum" source="A">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="B">1</semx>
                         </fmt-xref>
                      </semx>
                      <ul>
                         <li>
                            <fmt-name>
                               <semx element="autonum" source="">−</semx>
                            </fmt-name>
                            dans la France,
                            <xref target="_" pagenumber="true" id="_"/>
                            <semx element="xref" source="_">
                               <fmt-xref target="_" pagenumber="true">
                                  <span class="fmt-element-name">chapitre</span>
                                  <semx element="autonum" source="A">1</semx>
                               </fmt-xref>
                            </semx>
                            <ul>
                               <li>
                                  <fmt-name>
                                     <semx element="autonum" source="">o</semx>
                                  </fmt-name>
                                  à Paris,
                                  <xref target="_" pagenumber="true" id="_"/>
                                  <semx element="xref" source="_">
                                     <fmt-xref target="_" pagenumber="true">
                                        <span class="fmt-element-name">section</span>
                                        <semx element="autonum" source="A">1</semx>
                                        <span class="fmt-autonum-delim">.</span>
                                        <semx element="autonum" source="B">1</semx>
                                     </fmt-xref>
                                  </semx>
                               </li>
                               <li>
                                  <fmt-name>
                                     <semx element="autonum" source="">o</semx>
                                  </fmt-name>
                                  en Bretagne,
                                  <xref target="_" pagenumber="true" id="_"/>
                                  <semx element="xref" source="_">
                                     <fmt-xref target="_" pagenumber="true">
                                        <span class="fmt-element-name">chapitre</span>
                                        <semx element="autonum" source="A">1</semx>
                                     </fmt-xref>
                                  </semx>
                               </li>
                            </ul>
                         </li>
                         <li>
                            <fmt-name>
                               <semx element="autonum" source="">−</semx>
                            </fmt-name>
                            dans les États-Unis,
                            <xref target="_" pagenumber="true" id="_"/>
                            <semx element="xref" source="_">
                               <fmt-xref target="_" pagenumber="true">
                                  <span class="fmt-element-name">section</span>
                                  <semx element="autonum" source="A">1</semx>
                                  <span class="fmt-autonum-delim">.</span>
                                  <semx element="autonum" source="B">1</semx>
                               </fmt-xref>
                            </semx>
                         </li>
                      </ul>
                   </li>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      être
                      <ul>
                         <li>
                            <fmt-name>
                               <semx element="autonum" source="">−</semx>
                            </fmt-name>
                            Husserl,
                            <em>voir</em>
                            zebra,
                            <em>voir aussi</em>
                            Emancipation, zebra
                            <ul>
                               <li>
                                  <fmt-name>
                                     <semx element="autonum" source="">o</semx>
                                  </fmt-name>
                                  en allemand,
                                  <xref target="_" pagenumber="true" id="_"/>
                                  <semx element="xref" source="_">
                                     <fmt-xref target="_" pagenumber="true">
                                        <span class="fmt-element-name">chapitre</span>
                                        <semx element="autonum" source="A">1</semx>
                                     </fmt-xref>
                                  </semx>
                               </li>
                            </ul>
                         </li>
                      </ul>
                   </li>
                </ul>
             </clause>
             <clause id="_">
                <title>Z</title>
                <ul>
                   <li>
                      <fmt-name>
                         <semx element="autonum" source="">•</semx>
                      </fmt-name>
                      zebra,
                      <xref target="_" pagenumber="true" id="_"/>
                      <semx element="xref" source="_">
                         <fmt-xref target="_" pagenumber="true">
                            <span class="fmt-element-name">section</span>
                            <semx element="autonum" source="A">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="B">1</semx>
                         </fmt-xref>
                      </semx>
                   </li>
                </ul>
             </clause>
          </indexsect>
       </bipm-standard>
      OUTPUT
  end
end
