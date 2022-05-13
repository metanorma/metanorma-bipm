require "spec_helper"

RSpec.describe IsoDoc do
  it "processes Relaton bibliographies" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <bibdata>
          <language>en</language>
        </bibdata>
        <preface>
          <foreword>
            <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
              <eref bibitemid="ISO712"/>
              <eref bibitemid="ISBN"/>
              <eref bibitemid="ISSN"/>
              <eref bibitemid="ISO16634"/>
              <eref bibitemid="ref1"/>
              <eref bibitemid="ref10"/>
              <eref bibitemid="ref12"/>
              <eref bibitemid="zip_ffs"/>
            </p>
          </foreword>
        </preface>
        <bibliography>
          <references id="_bibliography" normative="false" obligation="informative">
            <title>Bibliography</title>
            <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
            <bibitem id="ISO712" type="standard">
              <title format="text/plain">Cereals or cereal products</title>
              <title format="text/plain" type="main">Cereals and cereal products</title>
              <docidentifier type="ISO">ISO 712</docidentifier>
              <docidentifier type="metanorma">[110]</docidentifier>
              <contributor>
                <role type="publisher"/>
                <organization>
                  <name>International Organization for Standardization</name>
                </organization>
              </contributor>
            </bibitem>
            <bibitem id="ISO16634" type="standard">
              <title format="text/plain" language="x">Cereals, pulses, milled cereal products, xxxx, oilseeds and animal feeding stuffs</title>
              <title format="text/plain" language="en">Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</title>
              <docidentifier type="ISO">ISO 16634:-- (all parts)</docidentifier>
              <date type="published">
                <on>--</on>
              </date>
              <contributor>
                <role type="publisher"/>
                <organization>
                  <abbreviation>ISO</abbreviation>
                </organization>
              </contributor>
              <note format="text/plain" reference="1" type="Unpublished-Status">Under preparation. (Stage at the time of publication ISO/DIS 16634)</note>
              <extent type="part">
                <referenceFrom>all</referenceFrom>
              </extent>
            </bibitem>
            <bibitem id="ISO20483" type="standard">
              <title format="text/plain">Cereals and pulses</title>
              <docidentifier type="ISO">ISO 20483:2013-2014</docidentifier>
              <date type="published">
                <from>2013</from>
                <to>2014</to>
              </date>
              <contributor>
                <role type="publisher"/>
                <organization>
                  <name>International Organization for Standardization</name>
                </organization>
              </contributor>
            </bibitem>
            <bibitem id="ref1">
              <formattedref format="application/x-isodoc+xml">
                <smallcap>Standard No I.C.C 167</smallcap>.
                <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em>
                (see
                <link target="http://www.icc.or.at"/>
                )</formattedref>
              <docidentifier type="ICC">ICC/167</docidentifier>
            </bibitem>
            <note>
              <p>This is an annotation of ISO 20483:2013-2014</p>
            </note>
            <bibitem id="zip_ffs">
              <formattedref format="application/x-isodoc+xml">Title 5</formattedref>
              <docidentifier type="metanorma">[5]</docidentifier>
            </bibitem>
            <bibitem id="ISBN" type="book">
              <title format="text/plain">Chemicals for analytical laboratory use</title>
              <docidentifier type="ISBN">ISBN</docidentifier>
              <docidentifier type="metanorma">[1]</docidentifier>
              <contributor>
                <role type="publisher"/>
                <organization>
                  <abbreviation>ISBN</abbreviation>
                </organization>
              </contributor>
            </bibitem>
            <bibitem id="ISSN" type="journal">
              <title format="text/plain">Instruments for analytical laboratory use</title>
              <docidentifier type="ISSN">ISSN</docidentifier>
              <docidentifier type="metanorma">[2]</docidentifier>
              <contributor>
                <role type="publisher"/>
                <organization>
                  <abbreviation>ISSN</abbreviation>
                </organization>
              </contributor>
            </bibitem>
            <note>
              <p>This is an annotation of document ISSN.</p>
            </note>
            <note>
              <p>This is another annotation of document ISSN.</p>
            </note>
            <bibitem id="ISO3696" type="standard">
              <title format="text/plain">Water for analytical laboratory use</title>
              <docidentifier type="BIPM">BIPM 3696</docidentifier>
              <contributor>
                <role type="publisher"/>
                <organization>
                  <abbreviation>ISO</abbreviation>
                </organization>
              </contributor>
            </bibitem>
            <bibitem id="ref10">
              <formattedref format="application/x-isodoc+xml">
                <smallcap>Standard No I.C.C 167</smallcap>.
                <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em>
                (see
                <link target="http://www.icc.or.at"/>
                )</formattedref>
              <docidentifier type="metanorma">[10]</docidentifier>
            </bibitem>
            <bibitem id="ref11">
              <title>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</title>
              <docidentifier type="IETF">RFC 10</docidentifier>
            </bibitem>
            <bibitem id="ref12">
              <formattedref format="application/x-isodoc+xml">CitationWorks. 2019.
                <em>How to cite a reference</em>
                .</formattedref>
              <docidentifier type="metanorma">[Citn]</docidentifier>
              <docidentifier type="IETF">RFC 20</docidentifier>
            </bibitem>
          </references>
        </bibliography>
      </iso-standard>
    INPUT

    presxml = <<~PRESXML
      <iso-standard type="presentation" xmlns="http://riboseinc.com/isoxml">
        <bibdata>
          <language current="true">en</language>
        </bibdata>
        <preface>
          <foreword displayorder="1">
            <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
              <eref bibitemid="ISO712">[110]</eref>
              <eref bibitemid="ISBN">[1]</eref>
              <eref bibitemid="ISSN">[2]</eref>
              <eref bibitemid="ISO16634">ISO 16634:-- (all parts)</eref>
              <eref bibitemid="ref1">ICC/167</eref>
              <eref bibitemid="ref10">[10]</eref>
              <eref bibitemid="ref12">Citn</eref>
              <eref bibitemid="zip_ffs">[5]</eref>
            </p>
          </foreword>
        </preface>
        <bibliography>
          <references id="_bibliography" normative="false" obligation="informative" displayorder="2">
            <title depth="1">Bibliography</title>
            <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
            <bibitem id="ISO712" type="standard">
              <formattedref>International Organization for Standardization. <em>Cereals and cereal products</em>.</formattedref>
              <docidentifier type="ISO">ISO 712</docidentifier>
              <docidentifier type="metanorma">[110]</docidentifier>
            </bibitem>
            <bibitem id="ISO16634" type="standard">
              <formattedref><em>Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</em>.</formattedref>
              <docidentifier type="ISO">ISO 16634:-- (all parts)</docidentifier>
              <note format="text/plain" reference="1" type="Unpublished-Status">Under preparation. (Stage at the time of publication ISO/DIS 16634)</note>
            </bibitem>
            <bibitem id="ISO20483" type="standard">
              <formattedref>International Organization for Standardization. <em>Cereals and pulses</em>. 2013&#x2013;2014.</formattedref>
              <docidentifier type="ISO">ISO 20483:2013-2014</docidentifier>
            </bibitem>
            <bibitem id="ref1">
              <formattedref format="application/x-isodoc+xml">
                <smallcap>Standard No I.C.C 167</smallcap>.
                <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em>
                (see
                <link target="http://www.icc.or.at"/>
                ) [ICC/167]</formattedref>
              <docidentifier type="ICC">ICC/167</docidentifier>
            </bibitem>
            <note>
              <name>NOTE</name>
              <p>This is an annotation of ISO 20483:2013-2014</p>
            </note>
            <bibitem id="zip_ffs">
              <formattedref format="application/x-isodoc+xml">Title 5</formattedref>
              <docidentifier type="metanorma">[5]</docidentifier>
            </bibitem>
            <bibitem id="ISBN" type="book">
              <formattedref><em>Chemicals for analytical laboratory use</em>. ISBN.</formattedref>
              <docidentifier type="ISBN">ISBN</docidentifier>
              <docidentifier type="metanorma">[1]</docidentifier>
            </bibitem>
            <bibitem id="ISSN" type="journal">
              <formattedref><em>Instruments for analytical laboratory use</em>. ISSN.</formattedref>
              <docidentifier type="ISSN">ISSN</docidentifier>
              <docidentifier type="metanorma">[2]</docidentifier>
            </bibitem>
            <note>
              <name>NOTE</name>
              <p>This is an annotation of document ISSN.</p>
            </note>
            <note>
              <name>NOTE</name>
              <p>This is another annotation of document ISSN.</p>
            </note>
            <bibitem id="ISO3696" type="standard">
              <formattedref><em>Water for analytical laboratory use</em>.</formattedref>
              <docidentifier type="BIPM">BIPM 3696</docidentifier>
            </bibitem>
            <bibitem id="ref10">
              <formattedref format="application/x-isodoc+xml">
                <smallcap>Standard No I.C.C 167</smallcap>.
                <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em>
                (see
                <link target="http://www.icc.or.at"/>
                )</formattedref>
              <docidentifier type="metanorma">[10]</docidentifier>
            </bibitem>
            <bibitem id="ref11">
              <formattedref><em>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</em>.</formattedref>
              <docidentifier type="IETF">IETF RFC 10</docidentifier>
            </bibitem>
            <bibitem id="ref12">
              <formattedref format="application/x-isodoc+xml">CitationWorks. 2019.
                <em>How to cite a reference</em>
                . [IETF RFC 20]</formattedref>
              <docidentifier type="metanorma">[Citn]</docidentifier>
              <docidentifier type="IETF">IETF RFC 20</docidentifier>
            </bibitem>
          </references>
        </bibliography>
      </iso-standard>
    PRESXML

    html = <<~OUTPUT
      #{HTML_HDR}
          <br/>
                     <div>
             <h1 class='ForewordTitle'>Foreword</h1>
             <p id='_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f'>
               <a href='#ISO712'>[110]</a>
               <a href='#ISBN'>[1]</a>
               <a href='#ISSN'>[2]</a>
               <a href='#ISO16634'>ISO 16634:-- (all parts)</a>
               <a href='#ref1'>ICC/167</a>
               <a href='#ref10'>[10]</a>
               <a href='#ref12'>Citn</a>
               <a href='#zip_ffs'>[5]</a>
             </p>
           </div>
           <p class='zzSTDTitle1'/>
           <br/>
           <div>
             <h1 class='Section3'>Bibliography</h1>
             <p>
               The following documents are referred to in the text in such a way that
               some or all of their content constitutes requirements of this document.
               For dated references, only the edition cited applies. For undated
               references, the latest edition of the referenced document (including any
               amendments) applies.
             </p>
             <p id='ISO712' class='Biblio'>
               [110]&#160; ISO 712
               International Organization for Standardization.
               <i>Cereals and cereal products</i>.
             </p>
             <p id='ISO16634' class='Biblio'>
               [2]&#160; ISO 16634:-- (all parts)
               <a class='FootnoteRef' href='#fn:1'>
                 <sup>1</sup>
               </a>
               <i>Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</i>.
             </p>
             <p id='ISO20483' class='Biblio'>
               [3]&#160; ISO 20483:2013-2014 International Organization for Standardization.
               <i>Cereals and pulses</i>. 2013&#8211;2014.
             </p>
             <p id='ref1' class='Biblio'>
               [4]&#160; ICC/167
               <span style='font-variant:small-caps;'>Standard No I.C.C 167</span>
               .
               <i>
                 Determination of the protein content in cereal and cereal products for
                 food and animal feeding stuffs according to the Dumas combustion
                 method
               </i>
                (see
               <a href='http://www.icc.or.at'>http://www.icc.or.at</a>
                )  [ICC/167]
             </p>
             <div class='Note'>
               <p>
                 <span class='note_label'>NOTE</span>
                 &#160; This is an annotation of ISO 20483:2013-2014
               </p>
             </div>
             <p id='zip_ffs' class='Biblio'>[5]&#160; Title 5</p>
             <p id='ISBN' class='Biblio'>
               [1]&#160;
               <i>Chemicals for analytical laboratory use</i>. ISBN.
             </p>
             <p id='ISSN' class='Biblio'>
               [2]&#160;
               <i>Instruments for analytical laboratory use</i>. ISSN.
             </p>
             <div class='Note'>
               <p>
                 <span class='note_label'>NOTE</span>
                 &#160; This is an annotation of document ISSN.
               </p>
             </div>
             <div class='Note'>
               <p>
                 <span class='note_label'>NOTE</span>
                 &#160; This is another annotation of document ISSN.
               </p>
             </div>
             <p id='ISO3696' class='Biblio'>
               [8]&#160; BIPM 3696
               <i>Water for analytical laboratory use</i>.
             </p>
             <p id='ref10' class='Biblio'>
               [10]&#160;
               <span style='font-variant:small-caps;'>Standard No I.C.C 167</span>
               .
               <i>
                 Determination of the protein content in cereal and cereal products for
                 food and animal feeding stuffs according to the Dumas combustion
                 method
               </i>
                (see
               <a href='http://www.icc.or.at'>http://www.icc.or.at</a>
                )
             </p>
             <p id='ref11' class='Biblio'>
               [10]&#160; IETF RFC 10
               <i>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</i>.
             </p>
             <p id='ref12' class='Biblio'>
               Citn&#160; IETF RFC 20 CitationWorks. 2019.
               <i>How to cite a reference</i>. [IETF RFC 20]
             </p>
           </div>
           <aside id='fn:1' class='footnote'>
             <p>Under preparation. (Stage at the time of publication ISO/DIS 16634)</p>
           </aside>
         </div>
       </body>
    OUTPUT
    expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, "")))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
  end

  it "processes BIPM references" do
    input = <<~INPUT
       <bipm-standard xmlns="http://riboseinc.com/isoxml">
            <sections>
          <clause id='_' obligation='normative'>
            <title>Clause</title>
            <p id='_'>
              <eref type='inline' bibitemid='a1' citeas='CR 03'/>
              <eref type='inline' bibitemid='a2' citeas='PV 105'/>
            </p>
          </clause>
        </sections>
        <bibliography>
          <references id='_' normative='false' obligation='informative'>
            <title>Bibliography</title>
            <bibitem id='a1'>
              <fetched>2022-02-13</fetched>
              <title format='text/plain' language='en' script='Latn'>3rd meeting of the CGPM</title>
              <uri type='src'>https://www.bipm.org/en/committees/cg/cgpm/3-1901</uri>
              <docidentifier type='BIPM' primary='true'>BIPM CR 03</docidentifier>
              <date type='published'>
                <on>1901-10-22</on>
              </date>
              <contributor>
                <role type='publisher'/>
                <organization>
                  <name>Bureau Intrnational des Poids et Mesures</name>
                  <abbreviation>BIPM</abbreviation>
                  <uri>www.bipm.org</uri>
                </organization>
              </contributor>
              <language>en</language>
              <language>fr</language>
              <script>Latn</script>
            </bibitem>
            <bibitem id='a2'>
              <fetched>2022-02-13</fetched>
              <title format='text/plain' language='en' script='Latn'>105th meeting of the CIPM</title>
              <uri type='src'>https://www.bipm.org/en/committees/ci/cipm/105-2016</uri>
              <docidentifier type='BIPM' primary='true'>BIPM PV 105</docidentifier>
              <date type='published'>
                <on>2016-10-28</on>
              </date>
              <contributor>
                <role type='publisher'/>
                <organization>
                  <name>Bureau Intrnational des Poids et Mesures</name>
                  <abbreviation>BIPM</abbreviation>
                  <uri>www.bipm.org</uri>
                </organization>
              </contributor>
              <language>en</language>
              <language>fr</language>
              <script>Latn</script>
            </bibitem>
          </references>
        </bibliography>
      </bipm-standard>
    INPUT
    output = <<~OUTPUT
      <sections>
        <clause id='_' obligation='normative' displayorder='1'>
          <title depth='1'>Clause</title>
          <p id='_'>
            <eref type='inline' bibitemid='a1' citeas='CR 03'>CR 03</eref>
            <eref type='inline' bibitemid='a2' citeas='PV 105'>PV 105</eref>
          </p>
        </clause>
      </sections>
    OUTPUT
    expect(xmlpp(
             Nokogiri::XML(IsoDoc::BIPM::PresentationXMLConvert.new({})
            .convert("test", input, true))
            .at("//xmlns:sections").to_xml,
           ))
      .to be_equivalent_to xmlpp(output)
  end

  it "enforces consistent references numbering with hidden items: metanorma-ordinal identifiers" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          </bibdata>
          <bibliography><references id="_normative_references" obligation="informative" normative="false"><title>Bibliography</title>
      <bibitem id="ref1" type="standard">
        <title format="text/plain">Cereals or cereal products</title>
        <docidentifier>ABC</docidentifier>
      </bibitem>
      <bibitem id="ref2" type="standard" hidden="true">
        <title format="text/plain">Cereals or cereal products</title>
        <docidentifier>ABD</docidentifier>
      </bibitem>
      <bibitem id="ref3" type="standard">
        <title format="text/plain">Cereals or cereal products</title>
        <docidentifier>ABE</docidentifier>
      </bibitem>
      </references></bibliography></iso-standard>
    INPUT
    presxml = <<~PRESXML
      <bibliography>
        <references id='_normative_references' obligation='informative' normative='false' displayorder='1'>
          <title depth='1'>Bibliography</title>
          <bibitem id='ref1' type='standard'>
            <formattedref><em>Cereals or cereal products</em>.</formattedref>
            <docidentifier type='metanorma-ordinal'>[1]</docidentifier>
            <docidentifier>ABC</docidentifier>
          </bibitem>
          <bibitem id='ref2' type='standard' hidden='true'>
            <formattedref><em>Cereals or cereal products</em>.</formattedref>
            <docidentifier>ABD</docidentifier>
          </bibitem>
          <bibitem id='ref3' type='standard'>
            <formattedref><em>Cereals or cereal products</em>.</formattedref>
            <docidentifier type='metanorma-ordinal'>[2]</docidentifier>
            <docidentifier>ABE</docidentifier>
          </bibitem>
        </references>
      </bibliography>
    PRESXML
    expect(xmlpp(Nokogiri::XML(
      IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:bibliography").to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "hides BIPM CGPM Resolution and BIPM CIPM Decision references" do
    input = <<~INPUT
       <bipm-standard xmlns="http://riboseinc.com/isoxml">
       <bibdata>
       <language>en</language>
       </bibdata>
       <bibliography><references id="_normative_references" obligation="informative" normative="false"><title>Bibliography</title>
                         <bibitem id='a1'>
            <title format='text/plain' language='en' script='Latn'>1st meeting of the CGPM</title>
            <uri type='src'>https://www.bipm.org/en/committees/cg/cgpm/1-1889</uri>
            <docidentifier type='BIPM' primary='true'>BIPM CGPM Resolution 1</docidentifier>
            <docnumber>CGPM Resolution 1</docnumber>
            <date type='published'>
              <on>1889-09-28</on>
            </date>
            <contributor>
              <role type='publisher'/>
              <organization>
                <name>Bureau International des Poids et Mesures</name>
                <abbreviation>BIPM</abbreviation>
                <uri>www.bipm.org</uri>
              </organization>
            </contributor>
            <language>en</language>
            <language>fr</language>
            <script>Latn</script>
          </bibitem>
          <bibitem id='a2'>
            <title format='text/plain' language='en' script='Latn'>105th meeting of the CIPM</title>
            <uri type='src'>https://www.bipm.org/en/committees/ci/cipm/105-2016</uri>
            <docidentifier type='BIPM' primary='true'>BIPM CIPM Decision 105</docidentifier>
            <docnumber>CIPM Decision 105</docnumber>
            <date type='published'>
              <on>2016-10-28</on>
            </date>
            <contributor>
              <role type='publisher'/>
              <organization>
                <name>Bureau International des Poids et Mesures</name>
                <abbreviation>BIPM</abbreviation>
                <uri>www.bipm.org</uri>
              </organization>
            </contributor>
            <language>en</language>
            <language>fr</language>
            <script>Latn</script>
          </bibitem>
          </references>
        </bibliography>
      </bipm-standard>
    INPUT
    presxml = <<~PRESXML
           <bibliography>
         <references id='_normative_references' obligation='informative' normative='false' displayorder='1'>
           <title depth='1'>Bibliography</title>
           <bibitem id='a1' hidden='true'>
             <formattedref>
               Bureau International des Poids et Mesures.
               <em>1st meeting of the CGPM</em>
               . September 28, 1889.
             </formattedref>
             <uri type='src'>https://www.bipm.org/en/committees/cg/cgpm/1-1889</uri>
             <docidentifier type='BIPM' primary='true'>BIPM CGPM Resolution 1</docidentifier>
           </bibitem>
           <bibitem id='a2' hidden='true'>
             <formattedref>
               Bureau International des Poids et Mesures.
               <em>105th meeting of the CIPM</em>
               . October 28, 2016.
             </formattedref>
             <uri type='src'>https://www.bipm.org/en/committees/ci/cipm/105-2016</uri>
             <docidentifier type='BIPM' primary='true'>BIPM CIPM Decision 105</docidentifier>
           </bibitem>
         </references>
       </bibliography>
    PRESXML
    expect(xmlpp(Nokogiri::XML(
      IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true),
    ).at("//xmlns:bibliography").to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end
end
