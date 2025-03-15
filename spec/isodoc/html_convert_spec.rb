require "spec_helper"

RSpec.describe IsoDoc::Bipm do
  it "processes table" do
    input = <<~INPUT
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <sections>
          <clause id="A">
           <table id="tableD-1" alt="tool tip" summary="long desc" width="70%" keep-with-next="true" keep-lines-together="true">
          <name>Repeatability and reproducibility of <em>husked</em> rice yield<fn reference="1"><p>X</p></fn></name>
          <colgroup>
          <col width="30%"/>
          <col width="20%"/>
          <col width="20%"/>
          <col width="20%"/>
          <col width="10%"/>
          </colgroup>
          <thead>
            <tr>
              <td rowspan="2" align="left">Description</td>
              <td colspan="4" align="center">Rice sample</td>
            </tr>
            <tr>
              <td valign="top" align="left">Arborio</td>
              <td valign="middle" align="center">Drago<fn reference="a">
          <p id="_0fe65e9a-5531-408e-8295-eeff35f41a55">Parboiled rice.</p>
        </fn></td>
              <td valign="bottom" align="center">Balilla<fn reference="a">
          <p id="_0fe65e9a-5531-408e-8295-eeff35f41a55">Parboiled rice.</p>
        </fn></td>
              <td align="center">Thaibonnet</td>
            </tr>
            </thead>
            <tbody>
            <tr>
              <th align="left">Number of laboratories retained after eliminating outliers</th>
              <td align="center">13</td>
              <td align="center">11</td>
              <td align="center">13</td>
              <td align="center">13</td>
            </tr>
            <tr>
              <td align="left">Mean value, g/100 g</td>
              <td align="center">81,2</td>
              <td align="center">82,0</td>
              <td align="center">81,8</td>
              <td align="center">77,7</td>
            </tr>
            </tbody>
            <tfoot>
            <tr>
              <td align="left">Reproducibility limit, <stem type="AsciiMath">R</stem> (= 2,83 <stem type="AsciiMath">s_R</stem>)</td>
              <td align="center">2,89</td>
              <td align="center">0,57</td>
              <td align="center">2,26</td>
              <td align="center"><dl><dt>6,06</dt><dd>Definition</dd></dl></td>
            </tr>
          </tfoot>
          <dl key="true">
             <name>Key</name>
          <dt>Drago</dt>
        <dd>A type of rice</dd>
        </dl>
              <source status="generalisation">
          <origin bibitemid="ISO712" type="inline" citeas="">
            <localityStack>
              <locality type="section">
                <referenceFrom>1</referenceFrom>
              </locality>
            </localityStack>
          </origin>
          <modification>
            <p id="_">with adjustments</p>
          </modification>
        </source>
              <source status="specialisation">
          <origin bibitemid="ISO712" type="inline" citeas="">
            <localityStack>
              <locality type="section">
                <referenceFrom>2</referenceFrom>
              </locality>
            </localityStack>
          </origin>
        </source>
        <note><p>This is a table about rice</p></note>
        </table>
            <table id="C" unnumbered="true">
              <name>Second Table</name>
            </table>
          </clause>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~INPUT
       <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
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
                <table id="B" autonum="1">
                   <name id="_">First Table</name>
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Table</span>
                         <semx element="autonum" source="B">1</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         .
                         <tab/>
                      </span>
                      <semx element="name" source="_">First Table</semx>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Table</span>
                      <semx element="autonum" source="B">1</semx>
                   </fmt-xref-label>
                </table>
                <table id="C" unnumbered="true">
                   <name id="_">Second Table</name>
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Table</span>
                      </span>
                      <span class="fmt-caption-delim">
                         .
                         <tab/>
                      </span>
                      <semx element="name" source="_">Second Table</semx>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Table</span>
                      <semx element="autonum" source="C">(??)</semx>
                   </fmt-xref-label>
                </table>
             </clause>
          </sections>
       </bipm-standard>
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
      #{HTML_HDR}
            <br/>
          <div id="_" class="TOC">
            <h1 class="IntroTitle">Contents</h1>
          </div>
          <div id='A'>
            <h1>1.</h1>
            <p class='TableTitle' style='text-align:center;'>Table 1.&#160; First Table</p>
            <table id='B' class='MsoISOTable' style='border-width:1px;border-spacing:0;'/>
            <p class='TableTitle' style='text-align:center;'>Table.  Second Table</p>
            <table id='C' class='MsoISOTable' style='border-width:1px;border-spacing:0;'/>
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

jcgm = <<~JCGM
         <ext>
            <editorialgroup>
              <committee acronym="JCGM">
                Joint Committee for Guides in Metrology
                Comité commun pour les guides en métrologie
              </committee>
            </editorialgroup>
          </ext>
JCGM
presxml = <<~OUTPUT
OUTPUT
output = <<~OUTPUT
OUTPUT
    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input.sub("<sections>", "<bibdata>#{jcgm}</bibdata><sections>"), true)
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
                         <li>A</li>
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
                         <li>A</li>
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
  end

  it "processes simple terms & definitions in JCGM" do
    input = <<~INPUT
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
                         <li>A</li>
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
                         <li>A</li>
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
      .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to(be_equivalent_to(Xml::C14n.format(presxml)))
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to(be_equivalent_to(output))
  end

  it "injects JS into blank html" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections/>
      </bipm-standard>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor
      .convert(input, backend: :bipm, header_footer: true))))
      .to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Times New Roman})
  end

  it "processes ordered lists" do
    input = <<~INPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
          <clause id="A" displayorder="1">
            <fmt-title>Clause</fmt-title>
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

    output = Xml::C14n.format(<<~"OUTPUT")
      #{HTML_HDR}
          <div id='A'>
            <h1>Clause</h1>
            <div class="ol_wrap">
            <ol type='1' start='4'>
              <li>
              <div class="ol_wrap">
                <ol type='I'>
                  <li>A</li>
                </ol>
                </div>
              </li>
            </ol>
            </div>
          </div>
        </div>
      </body>
    OUTPUT
    stripped_html = Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "processes nested roman and alphabetic lists" do
    input = <<~"INPUT"
      <bipm-standard type="semantic" version="#{Metanorma::Bipm::VERSION}" xmlns="https://www.metanorma.org/ns/bipm">
        <preface>
        <foreword displayorder="1"><fmt-title>Foreword</fmt-title>
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
          </foreword>
        </preface>
      </bipm-standard>
    INPUT

    output = <<~OUTPUT
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
           <div>
             <h1 class="ForewordTitle">Foreword</h1>
             <div class="ol_wrap">
               <ol type="A" id="_">
                 <li>
                   <p id="_">a</p>
                   <div class="ol_wrap">
                     <ol type="a" id="_" class="alphabet">
                       <li>
                         <p id="_">a1</p>
                       </li>
                     </ol>
                   </div>
                 </li>
                 <li>
                   <p id="_">a2</p>
                   <div class="ol_wrap">
                     <ol type="a" id="_" style="counter-reset: alphabet 4;" start="5" class="alphabet">
                       <li>
                         <p id="_">b</p>
                         <div class="ol_wrap">
                           <ol type="a" id="_" start="10">
                             <li>
                               <p id="_">c</p>
                             </li>
                           </ol>
                         </div>
                       </li>
                       <li>
                         <div class="ol_wrap">
                           <ol type="i" id="_" style="counter-reset: roman 1;" start="2" class="roman">
                             <li>
                               <p>c1</p>
                             </li>
                           </ol>
                         </div>
                         <p id="_">d</p>
                         <div class="ol_wrap">
                           <ol type="i" id="_" class="roman">
                             <li>
                               <p id="_">e</p>
                               <div class="ol_wrap">
                                 <ol type="i" id="_" start="12">
                                   <li>
                                     <p id="_">f</p>
                                   </li>
                                   <li>
                                     <p id="_">g</p>
                                   </li>
                                 </ol>
                               </div>
                             </li>
                             <li>
                               <p id="_">h</p>
                             </li>
                           </ol>
                         </div>
                       </li>
                       <li>
                         <p id="_">i</p>
                       </li>
                     </ol>
                   </div>
                 </li>
                 <li>
                   <p id="_">j</p>
                 </li>
               </ol>
             </div>
           </div>
         </div>
       </body>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"))))
      .to be_equivalent_to Xml::C14n.format(output)
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
                      être
                      <ul>
                         <li>
                            Husserl, see zebra, see also
                            <em>Eman</em>
                            cipation, zebra
                            <ul>
                               <li>
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
                      être
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
       <foreword id="_" displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p id="_">
             <eref bibitemid="ISO712" id="_">
                <locality type="clause">
                   <referenceFrom>3</referenceFrom>
                </locality>
             </eref>
             <semx element="eref" source="_">
                <fmt-xref target="ISO712">ISO 712, Clause 3</fmt-xref>
             </semx>
             <eref bibitemid="ISO712" id="_">
                <locality type="clause">
                   <referenceFrom>3.1</referenceFrom>
                </locality>
             </eref>
             <semx element="eref" source="_">
                <fmt-xref target="ISO712">ISO 712, Clause 3.1</fmt-xref>
             </semx>
             <eref bibitemid="ISO712" id="_">
                <locality type="table">
                   <referenceFrom>3.1</referenceFrom>
                </locality>
             </eref>
             <semx element="eref" source="_">
                <fmt-xref target="ISO712">ISO 712, Table 3.1</fmt-xref>
             </semx>
          </p>
       </foreword>
    PRESXML

    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
        .new(presxml_options)
    .convert("test", input, true))
    .at(".//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes bibliographic localities in JCGM" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          <script>Latn</script>
          <ext>
                  <editorialgroup>
                    <committee acronym="JCGM" language="en" script="Latn">TC</committee>
                    <committee acronym="JCGM" language="fr" script="Latn">CT</committee>
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
       <foreword id="_" displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p id="_">
             <eref bibitemid="ISO712" id="_">
                <locality type="clause">
                   <referenceFrom>3</referenceFrom>
                </locality>
             </eref>
             <semx element="eref" source="_">
                <fmt-xref target="ISO712">
                   [ISO 712],
                   <span class="citesec">Clause 3</span>
                </fmt-xref>
             </semx>
             <eref bibitemid="ISO712" id="_">
                <locality type="clause">
                   <referenceFrom>3.1</referenceFrom>
                </locality>
             </eref>
             <semx element="eref" source="_">
                <fmt-xref target="ISO712">
                   [ISO 712],
                   <span class="citesec">3.1</span>
                </fmt-xref>
             </semx>
             <eref bibitemid="ISO712" id="_">
                <locality type="table">
                   <referenceFrom>3.1</referenceFrom>
                </locality>
             </eref>
             <semx element="eref" source="_">
                <fmt-xref target="ISO712">
                   [ISO 712],
                   <span class="citetbl">Table 3.1</span>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    PRESXML

    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at(".//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "handles brackets for multiple erefs in JCGM" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          <script>Latn</script>
          <ext>
           <editorialgroup>
                    <committee acronym="JCGM" language="en" script="Latn">TC</committee>
                    <committee acronym="JCGM" language="fr" script="Latn">CT</committee>
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
       <foreword id="_" displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title depth="1">
             <semx element="title" source="_">Foreword</semx>
          </fmt-title>
          <p id="_">
             <eref bibitemid="ISO712" id="_"/>
             <semx element="eref" source="_">
                [
                <fmt-xref target="ISO712">ISO 712</fmt-xref>
                ]
             </semx>
             <eref bibitemid="ISO712" id="_"/>
             <semx element="eref" source="_">
                [
                <fmt-xref target="ISO712">ISO 712</fmt-xref>
                ]
             </semx>
             and
             <eref bibitemid="ISO712" id="_"/>
             <semx element="eref" source="_">
                [
                <fmt-xref target="ISO712">ISO 712</fmt-xref>
                ]
             </semx>
             ,
             <eref bibitemid="ISO712" id="_"/>
             <semx element="eref" source="_">
                [
                <fmt-xref target="ISO712">ISO 712</fmt-xref>
                ]
             </semx>
             and
             <eref bibitemid="ISO712" id="_">
                <locality type="clause">
                   <referenceFrom>3.1</referenceFrom>
                </locality>
             </eref>
             <semx element="eref" source="_">
                <fmt-xref target="ISO712">
                   [ISO 712],
                   <span class="citesec">3.1</span>
                </fmt-xref>
             </semx>
             <eref bibitemid="ISO712" id="_">
                <locality type="table">
                   <referenceFrom>3.1</referenceFrom>
                </locality>
             </eref>
             <semx element="eref" source="_">
                <fmt-xref target="ISO712">
                   [ISO 712],
                   <span class="citetbl">Table 3.1</span>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at(".//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes notes" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
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
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <bibdata>
             <language current="true">en</language>
             <script current="true">Latn</script>
          </bibdata>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
             <foreword id="A" displayorder="2">
                <title id="_">Foreword</title>
                <fmt-title depth="1">
                   <semx element="title" source="_">Foreword</semx>
                </fmt-title>
                <p id="B">abc</p>
                <note id="C" autonum="1">
                   <fmt-name>
                      <span class="fmt-caption-label">NOTE</span>
                      <span class="fmt-label-delim">
                         :
                         <tab/>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Note</span>
                      <semx element="autonum" source="C">1</semx>
                   </fmt-xref-label>
                   <fmt-xref-label container="A">
                      <span class="fmt-xref-container">
                         <semx element="foreword" source="A">Foreword</semx>
                      </span>
                      <span class="fmt-comma">,</span>
                      <span class="fmt-element-name">Note</span>
                      <semx element="autonum" source="C">1</semx>
                   </fmt-xref-label>
                   Hello
                </note>
                <ul id="D">
                   <li>
                      <p id="E">List item</p>
                      <note id="F" autonum="2">
                         <fmt-name>
                            <span class="fmt-caption-label">NOTE</span>
                            <span class="fmt-label-delim">
                               :
                               <tab/>
                            </span>
                         </fmt-name>
                         <fmt-xref-label>
                            <span class="fmt-element-name">Note</span>
                            <semx element="autonum" source="F">2</semx>
                         </fmt-xref-label>
                         <fmt-xref-label container="A">
                            <span class="fmt-xref-container">
                               <semx element="foreword" source="A">Foreword</semx>
                            </span>
                            <span class="fmt-comma">,</span>
                            <span class="fmt-element-name">Note</span>
                            <semx element="autonum" source="F">2</semx>
                         </fmt-xref-label>
                         List note
                      </note>
                   </li>
                </ul>
             </foreword>
          </preface>
          <sections>
             <clause id="A1" displayorder="3">
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A1">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Chapter</span>
                   <semx element="autonum" source="A1">1</semx>
                </fmt-xref-label>
                <p id="B1">abc</p>
                <note id="C1" autonum="1">
                   <fmt-name>
                      <span class="fmt-caption-label">Note</span>
                      <span class="fmt-label-delim">
                         :
                         <tab/>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Note</span>
                      <semx element="autonum" source="C1">1</semx>
                   </fmt-xref-label>
                   <fmt-xref-label container="A1">
                      <span class="fmt-xref-container">
                         <span class="fmt-element-name">Chapter</span>
                         <semx element="autonum" source="A1">1</semx>
                      </span>
                      <span class="fmt-comma">,</span>
                      <span class="fmt-element-name">Note</span>
                      <semx element="autonum" source="C1">1</semx>
                   </fmt-xref-label>
                   Hello
                </note>
                <ul id="D1">
                   <li>
                      <p id="E1">List item</p>
                      <note id="F1" autonum="2">
                         <fmt-name>
                            <span class="fmt-caption-label">Note</span>
                            <span class="fmt-label-delim">
                               :
                               <tab/>
                            </span>
                         </fmt-name>
                         <fmt-xref-label>
                            <span class="fmt-element-name">Note</span>
                            <semx element="autonum" source="F1">2</semx>
                         </fmt-xref-label>
                         <fmt-xref-label container="A1">
                            <span class="fmt-xref-container">
                               <span class="fmt-element-name">Chapter</span>
                               <semx element="autonum" source="A1">1</semx>
                            </span>
                            <span class="fmt-comma">,</span>
                            <span class="fmt-element-name">Note</span>
                            <semx element="autonum" source="F1">2</semx>
                         </fmt-xref-label>
                         List note
                      </note>
                   </li>
                </ul>
             </clause>
          </sections>
       </iso-standard>
    PRESXML

    xml = Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
    .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)

        presxml = <<~PRESXML
              <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <bibdata>
             <language current="true">fr</language>
             <script current="true">Latn</script>
          </bibdata>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Table des matières</fmt-title>
             </clause>
             <foreword id="A" displayorder="2">
                <title id="_">Avant-propos</title>
                <fmt-title depth="1">
                   <semx element="title" source="_">Avant-propos</semx>
                </fmt-title>
                <p id="B">abc</p>
                <note id="C" autonum="1">
                   <fmt-name>
                      <span class="fmt-caption-label">NOTE</span>
                      <span class="fmt-label-delim">
                          :
                         <tab/>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">note</span>
                      <semx element="autonum" source="C">1</semx>
                   </fmt-xref-label>
                   <fmt-xref-label container="A">
                      <span class="fmt-xref-container">
                         <semx element="foreword" source="A">Avant-propos</semx>
                      </span>
                      <span class="fmt-comma">,</span>
                      <span class="fmt-element-name">note</span>
                      <semx element="autonum" source="C">1</semx>
                   </fmt-xref-label>
                   Hello
                </note>
                <ul id="D">
                   <li>
                      <p id="E">List item</p>
                      <note id="F" autonum="2">
                         <fmt-name>
                            <span class="fmt-caption-label">NOTE</span>
                            <span class="fmt-label-delim">
                                :
                               <tab/>
                            </span>
                         </fmt-name>
                         <fmt-xref-label>
                            <span class="fmt-element-name">note</span>
                            <semx element="autonum" source="F">2</semx>
                         </fmt-xref-label>
                         <fmt-xref-label container="A">
                            <span class="fmt-xref-container">
                               <semx element="foreword" source="A">Avant-propos</semx>
                            </span>
                            <span class="fmt-comma">,</span>
                            <span class="fmt-element-name">note</span>
                            <semx element="autonum" source="F">2</semx>
                         </fmt-xref-label>
                         List note
                      </note>
                   </li>
                </ul>
             </foreword>
          </preface>
          <sections>
             <clause id="A1" displayorder="3">
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A1">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">chapitre</span>
                   <semx element="autonum" source="A1">1</semx>
                </fmt-xref-label>
                <p id="B1">abc</p>
                <note id="C1" autonum="1">
                   <fmt-name>
                      <span class="fmt-caption-label">Note</span>
                      <span class="fmt-label-delim">
                          :
                         <tab/>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">note</span>
                      <semx element="autonum" source="C1">1</semx>
                   </fmt-xref-label>
                   <fmt-xref-label container="A1">
                      <span class="fmt-xref-container">
                         <span class="fmt-element-name">chapitre</span>
                         <semx element="autonum" source="A1">1</semx>
                      </span>
                      <span class="fmt-comma">,</span>
                      <span class="fmt-element-name">note</span>
                      <semx element="autonum" source="C1">1</semx>
                   </fmt-xref-label>
                   Hello
                </note>
                <ul id="D1">
                   <li>
                      <p id="E1">List item</p>
                      <note id="F1" autonum="2">
                         <fmt-name>
                            <span class="fmt-caption-label">Remarque</span>
                            <span class="fmt-label-delim">
                                :
                               <tab/>
                            </span>
                         </fmt-name>
                         <fmt-xref-label>
                            <span class="fmt-element-name">note</span>
                            <semx element="autonum" source="F1">2</semx>
                         </fmt-xref-label>
                         <fmt-xref-label container="A1">
                            <span class="fmt-xref-container">
                               <span class="fmt-element-name">chapitre</span>
                               <semx element="autonum" source="A1">1</semx>
                            </span>
                            <span class="fmt-comma">,</span>
                            <span class="fmt-element-name">note</span>
                            <semx element="autonum" source="F1">2</semx>
                         </fmt-xref-label>
                         List note
                      </note>
                   </li>
                </ul>
             </clause>
          </sections>
       </iso-standard>
    PRESXML

    xml = Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input.sub("<language>en</language>", "<language>fr</language>"), true))
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

    it "processes IsoXML footnotes" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata>
      <title><fn reference="43"><p>C</p></fn></title>
      </bibdata>
      <boilerplate>
      <copyright-statement>
      <clause><title><fn reference="44"><p>D</p></fn><</title>
      </clause>
      </copyright-statement>
      </boilerplate>
          <preface>
          <foreword id="F"><title>Foreword</title>
          <p>A.<fn reference="2">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Formerly denoted as 15 % (m/m).</p>
      </fn></p>
          <p>B.<fn reference="2">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Formerly denoted as 15 % (m/m).</p>
      </fn></p>
          <p>C.<fn reference="1">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Hello! denoted as 15 % (m/m).</p>
      </fn></p>
          </foreword>
          </preface>
          <sections>
          <clause id="A">
          A.<fn reference="42">
          <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Third footnote.</p>
      </fn></p>
          <p>B.<fn reference="2">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Formerly denoted as 15 % (m/m).</p>
      </fn></p>
          </clause>
          <bibliography><references id="_normative_references" obligation="informative" normative="true"><title>Normative References</title>
          <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
      <bibitem id="ISO712" type="standard">
        <title format="text/plain">Cereals or cereal products</title>
        <title type="main" format="text/plain">Cereals and cereal products<fn reference="7">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">ISO is a standards organisation.</p>
      </fn></title>
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
   presxml = <<~INPUT
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <bibdata>
             <title>
                <fn reference="1" original-reference="43" id="_" target="_">
                   <p>C</p>
                   <fmt-fn-label>
                      <sup>
                         <semx element="autonum" source="_">1</semx>
                      </sup>
                   </fmt-fn-label>
                </fn>
             </title>
          </bibdata>
          
          <boilerplate>
             <copyright-statement>
                <clause>
                   <title id="_">
                      <fn reference="2" original-reference="44" id="_" target="_">
                         <p>D</p>
                         <fmt-fn-label>
                            <sup>
                               <semx element="autonum" source="_">2</semx>
                            </sup>
                         </fmt-fn-label>
                      </fn>
                   </title>
                   <fmt-title depth="1">
                      <semx element="title" source="_">
                         <fn reference="2" original-reference="44" id="_" target="_">
                            <p>D</p>
                            <fmt-fn-label>
                               <sup>
                                  <semx element="autonum" source="_">2</semx>
                               </sup>
                            </fmt-fn-label>
                         </fn>
                      </semx>
                   </fmt-title>
                </clause>
             </copyright-statement>
          </boilerplate>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Table of contents</fmt-title>
             </clause>
             <foreword id="F" displayorder="2">
                <title id="_">Foreword</title>
                <fmt-title depth="1">
                   <semx element="title" source="_">Foreword</semx>
                </fmt-title>
                <p>
                   A.
                   <fn reference="3" original-reference="2" id="_" target="_">
                      <p original-id="_">Formerly denoted as 15 % (m/m).</p>
                      <fmt-fn-label>
                         <sup>
                            <semx element="autonum" source="_">3</semx>
                         </sup>
                      </fmt-fn-label>
                   </fn>
                </p>
                <p>
                   B.
                   <fn reference="3" original-reference="2" id="_" target="_">
                      <p id="_">Formerly denoted as 15 % (m/m).</p>
                      <fmt-fn-label>
                         <sup>
                            <semx element="autonum" source="_">3</semx>
                         </sup>
                      </fmt-fn-label>
                   </fn>
                </p>
                <p>
                   C.
                   <fn reference="4" original-reference="1" id="_" target="_">
                      <p original-id="_">Hello! denoted as 15 % (m/m).</p>
                      <fmt-fn-label>
                         <sup>
                           <semx element="autonum" source="_">4</semx>
                         </sup>
                      </fmt-fn-label>
                   </fn>
                </p>
             </foreword>
          </preface>
          <sections>
             <clause id="A" displayorder="5">
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">2</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">2</semx>
                </fmt-xref-label>
                A.
                <fn reference="6" original-reference="42" id="_" target="_">
                   <p original-id="_">Third footnote.</p>
                   <fmt-fn-label>
                      <sup>
                         <semx element="autonum" source="_">6</semx>
                      </sup>
                   </fmt-fn-label>
                </fn>
             </clause>
             <p displayorder="3">
                B.
                <fn reference="3" original-reference="2" id="_" target="_">
                   <p id="_">Formerly denoted as 15 % (m/m).</p>
                   <fmt-fn-label>
                      <sup>
                         <semx element="autonum" source="_">3</semx>
                      </sup>
                   </fmt-fn-label>
                </fn>
             </p>
             <references id="_" obligation="informative" normative="true" displayorder="4">
                <title id="_">Normative References</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Normative References</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
                <bibitem id="ISO712" type="standard">
                   <formattedref>
                      International Organization for Standardization.
                      <em>
                         Cereals and cereal products
                         <fn reference="5" original-reference="7" id="_" target="_">
                            <p original-id="_">ISO is a standards organisation.</p>
                            <fmt-fn-label>
                               <sup>
                                  <semx element="autonum" source="_">5</semx>
                               </sup>
                            </fmt-fn-label>
                         </fn>
                      </em>
                      .
                   </formattedref>
                   <title format="text/plain">Cereals or cereal products</title>
                   <title type="main" format="text/plain">
                      Cereals and cereal products
                      <fn reference="5" original-reference="7" id="_" target="_">
                         <p id="_">ISO is a standards organisation.</p>
                         <fmt-fn-label>
                            <sup>
                               <semx element="autonum" source="_">5</semx>
                            </sup>
                         </fmt-fn-label>
                      </fn>
                   </title>
                   <docidentifier type="ISO">ISO 712</docidentifier>
                   <docidentifier scope="biblio-tag">ISO 712</docidentifier>
                   <contributor>
                      <role type="publisher"/>
                     <organization>
                         <name>International Organization for Standardization</name>
                      </organization>
                   </contributor>
                   <biblio-tag>ISO 712, </biblio-tag>
                </bibitem>
             </references>
          </sections>
          <bibliography>
       </bibliography>
          <fmt-footnote-container>
             <fmt-fn-body id="_" target="_" reference="1">
                <semx element="fn" source="_">
                   <p>
                      <fmt-fn-label>
                         <sup>
                            <semx element="autonum" source="_">1</semx>
                         </sup>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      C
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_" target="_" reference="2">
                <semx element="fn" source="_">
                   <p>
                      <fmt-fn-label>
                         <sup>
                            <semx element="autonum" source="_">2</semx>
                         </sup>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      D
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_" target="_" reference="3">
                <semx element="fn" source="_">
                   <p id="_">
                      <fmt-fn-label>
                         <sup>
                            <semx element="autonum" source="_">3</semx>
                         </sup>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      Formerly denoted as 15 % (m/m).
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_" target="_" reference="4">
                <semx element="fn" source="_">
                   <p id="_">
                      <fmt-fn-label>
                         <sup>
                            <semx element="autonum" source="_">4</semx>
                         </sup>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      Hello! denoted as 15 % (m/m).
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_" target="_" reference="5">
                <semx element="fn" source="_">
                   <p id="_">
                      <fmt-fn-label>
                         <sup>
                            <semx element="autonum" source="_">5</semx>
                         </sup>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      ISO is a standards organisation.
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_" target="_" reference="6">
                <semx element="fn" source="_">
                   <p id="_">
                      <fmt-fn-label>
                        <sup>
                            <semx element="autonum" source="_">6</semx>
                         </sup>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      Third footnote.
                   </p>
                </semx>
             </fmt-fn-body>
          </fmt-footnote-container>
       </iso-standard>
    INPUT
    html = <<~OUTPUT
          <html lang="en">
          <head/>
          <body lang="en">
             <div class="title-section">
                <p> </p>
             </div>
             <br/>
             <div class="prefatory-section">
                <p> </p>
             </div>
             <br/>
             <div class="main-section">
                <div class="authority">
                   <div class="boilerplate-copyright">
                      <div>
                         <h1>
                            <a class="FootnoteRef" href="#fn:2">
                               <sup>2</sup>
                            </a>
                         </h1>
                      </div>
                   </div>
                </div>
                <br/>
                <div id="_" class="TOC">
                   <h1 class="IntroTitle">Table of contents</h1>
                </div>
                <br/>
                <div id="F">
                   <h1 class="ForewordTitle">Foreword</h1>
                   <p>
                      A.
                      <a class="FootnoteRef" href="#fn:3">
                         <sup>3</sup>
                      </a>
                   </p>
                   <p>
                      B.
                      <a class="FootnoteRef" href="#fn:3">
                         <sup>3</sup>
                      </a>
                   </p>
                   <p>
                      C.
                      <a class="FootnoteRef" href="#fn:4">
                         <sup>4</sup>
                      </a>
                   </p>
                </div>
                <p>
                   B.
                   <a class="FootnoteRef" href="#fn:3">
                      <sup>3</sup>
                   </a>
                </p>
                <div>
                   <h1>1.  Normative References</h1>
                   <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
                   <p id="ISO712" class="NormRef">
                      ISO 712, International Organization for Standardization.
                      <i>
                         Cereals and cereal products
                         <a class="FootnoteRef" href="#fn:5">
                            <sup>5</sup>
                         </a>
                      </i>
                      .
                   </p>
                </div>
                <div id="A">
                   <h1>2.</h1>
                   <a class="FootnoteRef" href="#fn:6">
                      <sup>6</sup>
                   </a>
                </div>
                <aside id="fn:1" class="footnote">
                   <p>C</p>
                </aside>
                <aside id="fn:2" class="footnote">
                   <p>D</p>
                </aside>
                <aside id="fn:3" class="footnote">
                   <p id="_">Formerly denoted as 15 % (m/m).</p>
                </aside>
                <aside id="fn:4" class="footnote">
                   <p id="_">Hello! denoted as 15 % (m/m).</p>
                </aside>
                <aside id="fn:5" class="footnote">
                   <p id="_">ISO is a standards organisation.</p>
                </aside>
                <aside id="fn:6" class="footnote">
                   <p id="_">Third footnote.</p>
                </aside>
             </div>
          </body>
       </html>
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

jcgm = <<~JCGM
         <ext>
            <editorialgroup>
              <committee acronym="JCGM">
                Joint Committee for Guides in Metrology
                Comité commun pour les guides en métrologie
              </committee>
            </editorialgroup>
          </ext>
JCGM
presxml = <<~OUTPUT
OUTPUT
output = <<~OUTPUT
OUTPUT
    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input.sub("<sections>", "<bibdata>#{jcgm}</bibdata><sections>"), true)
    expect(Xml::C14n.format(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to(be_equivalent_to(Xml::C14n.format(presxml)))
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to(be_equivalent_to(output))
  end
end
