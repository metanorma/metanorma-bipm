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
          <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
        <bibdata>
          <language current="true">en</language>
        </bibdata>
        <preface>
          <clause type="toc" id="_" displayorder="1">
            <title depth="1">Contents</title>
          </clause>
          <foreword displayorder="2">
            <p id="_">
       <xref target="ISO712">ISO 712</xref>
       <xref target="ISBN">[6]</xref>
       <xref target="ISSN">[7]</xref>
       <xref target="ISO16634">ISO 16634:-- (all parts)</xref>
       <xref target="ref1">ICC/167</xref>
       <xref target="ref10">[9]</xref>
       <xref target="ref12">Citn</xref>
       <xref target="zip_ffs">[5]</xref>
            </p>
          </foreword>
        </preface>
        <bibliography>
          <references id="_" normative="false" obligation="informative" displayorder="3">
            <title depth="1">Bibliography</title>
            <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
            <bibitem id="ISO712" type="standard">
              <formattedref>International Organization for Standardization. <em>Cereals and cereal products</em>. ISO 712.</formattedref>
              <docidentifier type="metanorma-ordinal">[1]</docidentifier>
              <docidentifier type="ISO">ISO 712</docidentifier>
              <docidentifier scope="biblio-tag">ISO 712</docidentifier>
              <biblio-tag>[1]<tab/>ISO 712 </biblio-tag>
            </bibitem>
            <bibitem id="ISO16634" type="standard">
              <formattedref><em>Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</em>. ISO 16634:-- (all parts).</formattedref>
              <docidentifier type="metanorma-ordinal">[2]</docidentifier>
              <docidentifier type="ISO">ISO 16634:-- (all parts)</docidentifier>
              <docidentifier scope="biblio-tag">ISO 16634:-- (all parts)</docidentifier>
              <note format="text/plain" reference="1" type="Unpublished-Status">Under preparation. (Stage at the time of publication ISO/DIS 16634)</note>
              <biblio-tag>[2]<tab/>ISO 16634:-- (all parts)<fn reference="1"><p>Under preparation. (Stage at the time of publication ISO/DIS 16634)</p></fn></biblio-tag>
            </bibitem>
            <bibitem id="ISO20483" type="standard">
              <formattedref>International Organization for Standardization. (2013–2014) <em>Cereals and pulses</em>. ISO 20483:2013-2014.</formattedref>
              <docidentifier type="metanorma-ordinal">[3]</docidentifier>
              <docidentifier type="ISO">ISO 20483:2013-2014</docidentifier>
              <docidentifier scope="biblio-tag">ISO 20483:2013-2014</docidentifier>
              <biblio-tag>[3]<tab/>ISO 20483:2013-2014 </biblio-tag>
            </bibitem>
            <bibitem id="ref1">
              <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>.
                <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em>
                (see
                <link target="http://www.icc.or.at"/>
                )</formattedref>
              <docidentifier type="metanorma-ordinal">[4]</docidentifier>
              <docidentifier type="ICC">ICC/167</docidentifier>
              <docidentifier scope="biblio-tag">ICC/167</docidentifier>
              <biblio-tag>[4]<tab/>ICC/167 </biblio-tag>
            </bibitem>
            <note>
              <name>Note:</name>
              <p>This is an annotation of ISO 20483:2013-2014</p>
            </note>
            <bibitem id="zip_ffs">
              <formattedref format="application/x-isodoc+xml">Title 5</formattedref>
              <docidentifier type="metanorma-ordinal">[5]</docidentifier>
              <biblio-tag>[5]<tab/></biblio-tag>
            </bibitem>
            <bibitem id="ISBN" type="book">
              <formattedref>(n.d.) <em>Chemicals for analytical laboratory use</em></formattedref>
              <docidentifier type="metanorma-ordinal">[6]</docidentifier>
              <docidentifier type="ISBN">ISBN</docidentifier>
              <biblio-tag>[6]<tab/></biblio-tag>
            </bibitem>
            <bibitem id="ISSN" type="journal">
              <formattedref><em>Instruments for analytical laboratory use</em>. (n.d.).</formattedref>
              <docidentifier type="metanorma-ordinal">[7]</docidentifier>
              <docidentifier type="ISSN">ISSN</docidentifier>
              <biblio-tag>[7]<tab/></biblio-tag>
            </bibitem>
            <note>
              <name>Note:</name>
              <p>This is an annotation of document ISSN.</p>
            </note>
            <note>
              <name>Note:</name>
              <p>This is another annotation of document ISSN.</p>
            </note>
            <bibitem id="ISO3696" type="standard">
              <formattedref><em>Water for analytical laboratory use</em>. BIPM 3696.</formattedref>
              <docidentifier type="metanorma-ordinal">[8]</docidentifier>
              <docidentifier type="BIPM">BIPM 3696</docidentifier>
              <docidentifier scope="biblio-tag">BIPM 3696</docidentifier>
              <biblio-tag>[8]<tab/>BIPM 3696 </biblio-tag>
            </bibitem>
            <bibitem id="ref10">
              <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>.
                <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em>
                (see
                <link target="http://www.icc.or.at"/>
                )</formattedref>
              <docidentifier type="metanorma-ordinal">[9]</docidentifier>
              <biblio-tag>[9]<tab/></biblio-tag>
            </bibitem>
            <bibitem id="ref11">
              <formattedref><em>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</em>. IETF RFC 10.</formattedref>
              <docidentifier type="metanorma-ordinal">[10]</docidentifier>
              <docidentifier type="IETF">IETF RFC 10</docidentifier>
              <docidentifier scope="biblio-tag">IETF RFC 10</docidentifier>
              <biblio-tag>[10]<tab/>IETF RFC 10 </biblio-tag>
            </bibitem>
            <bibitem id="ref12">
              <formattedref format="application/x-isodoc+xml">CitationWorks. 2019.
                <em>How to cite a reference</em>
                .</formattedref>
              <docidentifier type="metanorma">[Citn]</docidentifier>
              <docidentifier type="IETF">IETF RFC 20</docidentifier>
              <docidentifier scope="biblio-tag">IETF RFC 20</docidentifier>
              <biblio-tag>Citn<tab/>IETF RFC 20 </biblio-tag>
            </bibitem>
          </references>
        </bibliography>
      </iso-standard>
    PRESXML

    html = <<~OUTPUT
      #{HTML_HDR}
           <br/>
           <div id="_" class="TOC">
             <h1 class="IntroTitle">Contents</h1>
           </div>
           <br/>
           <div>
             <h1 class="ForewordTitle">Foreword</h1>
             <p id="_">
               <a href="#ISO712">ISO 712</a>
               <a href="#ISBN">[6]</a>
               <a href="#ISSN">[7]</a>
               <a href="#ISO16634">ISO 16634:-- (all parts)</a>
               <a href="#ref1">ICC/167</a>
               <a href="#ref10">[9]</a>
               <a href="#ref12">Citn</a>
               <a href="#zip_ffs">[5]</a>
             </p>
           </div>
           <br/>
           <div>
             <h1 class="Section3">Bibliography</h1>
             <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
             <p id="ISO712" class="Biblio">[1]  ISO 712 International Organization for Standardization. <i>Cereals and cereal products</i>. ISO 712.</p>
             <p id="ISO16634" class="Biblio">[2]  ISO 16634:-- (all parts)<a class="FootnoteRef" href="#fn:1"><sup>1</sup></a><i>Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</i>. ISO 16634:-- (all parts).</p>
             <p id="ISO20483" class="Biblio">[3]  ISO 20483:2013-2014 International Organization for Standardization. (2013–2014) <i>Cereals and pulses</i>. ISO 20483:2013-2014.</p>
             <p id="ref1" class="Biblio">[4]  ICC/167 <span style="font-variant:small-caps;">Standard No I.C.C 167</span>.
                 <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i>
                 (see
                 <a href="http://www.icc.or.at">http://www.icc.or.at</a>
                 )</p>
             <div class="Note">
               <p><span class="note_label">Note:</span>  This is an annotation of ISO 20483:2013-2014</p>
             </div>
             <p id="zip_ffs" class="Biblio">[5]  Title 5</p>
             <p id="ISBN" class="Biblio">[6]  (n.d.) <i>Chemicals for analytical laboratory use</i></p>
             <p id="ISSN" class="Biblio">[7]  <i>Instruments for analytical laboratory use</i>. (n.d.).</p>
             <div class="Note">
               <p><span class="note_label">Note:</span>  This is an annotation of document ISSN.</p>
             </div>
             <div class="Note">
               <p><span class="note_label">Note:</span>  This is another annotation of document ISSN.</p>
             </div>
             <p id="ISO3696" class="Biblio">[8]  BIPM 3696 <i>Water for analytical laboratory use</i>. BIPM 3696.</p>
             <p id="ref10" class="Biblio">[9]  <span style="font-variant:small-caps;">Standard No I.C.C 167</span>.
                 <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i>
                 (see
                 <a href="http://www.icc.or.at">http://www.icc.or.at</a>
                 )</p>
             <p id="ref11" class="Biblio">[10]  IETF RFC 10 <i>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</i>. IETF RFC 10.</p>
             <p id="ref12" class="Biblio">Citn  IETF RFC 20 CitationWorks. 2019.
                 <i>How to cite a reference</i>
                 .</p>
           </div>
           <aside id="fn:1" class="footnote">
             <p>Under preparation. (Stage at the time of publication ISO/DIS 16634)</p>
           </aside>
         </div>
       </body>
    OUTPUT
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, "")
      .gsub(%r{reference="[^"]+"}, 'reference="1"'))))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
  end

  it "processes BIPM references" do
    VCR.use_cassette "isodoc1" do
      input = <<~INPUT
        <bipm-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata type="standard"><language>en</language><script>Latn</script></bibdata>
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
                  <references id="_bibliography" normative="false" obligation="informative">
        <title>Bibliography</title><bibitem id="a1" type="proceedings" schema-version="v1.2.8">  <fetched>2024-03-19</fetched>
        <title format="text/plain" language="en" script="Latn">1st meeting of the CGPM</title>
          <uri type="citation" language="en" script="Latn">https://www.bipm.org/en/committees/cg/cgpm/1-1889</uri>  <uri type="citation" language="fr" script="Latn">https://www.bipm.org/fr/committees/cg/cgpm/1-1889</uri>  <uri type="pdf">https://www.bipm.org/documents/20126/38097196/CGPM1.pdf/0ff415d6-87a2-5e23-5a1c-cadf8b8047a6</uri>  <uri type="src" language="en" script="Latn">https://raw.githubusercontent.com/metanorma/bipm-data-outcomes/main/cgpm/meetings-en/meeting-01.yml</uri>  <uri type="src" language="fr" script="Latn">https://raw.githubusercontent.com/metanorma/bipm-data-outcomes/main/cgpm/meetings-fr/meeting-01.yml</uri>  <docidentifier type="BIPM" primary="true" language="en" script="Latn">CGPM 1st Meeting (1889)</docidentifier>  <docidentifier type="BIPM" primary="true" language="fr" script="Latn">CGPM 1e Réunion (1889)</docidentifier>  <docidentifier type="BIPM" primary="true">CGPM 1st Meeting (1889) / CGPM 1e Réunion (1889)</docidentifier>  <docnumber>CGPM 1st Meeting (1889)</docnumber>  <date type="published">    <on>1889-09-28</on>  </date>  <contributor>    <role type="publisher"/>    <organization>
        <name language="en" script="Latn">International Bureau of Weights and Measures</name>
              <abbreviation>BIPM</abbreviation>      <uri>www.bipm.org</uri>    </organization>  </contributor>  <contributor>    <role type="author"/>    <organization>
        <name language="en" script="Latn">General Conference on Weights and Measures</name>
              <abbreviation>CGPM</abbreviation>    </organization>  </contributor>  <language>en</language>  <language>fr</language>  <script>Latn</script>  <place>    <city>Paris</city>  </place></bibitem><bibitem id="a2" type="proceedings" schema-version="v1.2.8">  <fetched>2024-03-19</fetched>
        <title format="text/plain" language="en" script="Latn">Decision CIPM/101-1 (2012)</title>
          <uri type="citation" language="en" script="Latn">https://www.bipm.org/en/committees/ci/cipm/101-_1-2012</uri>  <uri type="citation" language="fr" script="Latn">https://www.bipm.org/fr/committees/ci/cipm/101-_1-2012</uri>  <uri type="src" language="en" script="Latn">https://raw.githubusercontent.com/metanorma/bipm-data-outcomes/main/cipm/meetings-en/meeting-101-1.yml</uri>  <uri type="src" language="fr" script="Latn">https://raw.githubusercontent.com/metanorma/bipm-data-outcomes/main/cipm/meetings-fr/meeting-101-1.yml</uri>  <docidentifier type="BIPM" primary="true">CIPM DECN 101-1 (2012)</docidentifier>  <docidentifier type="BIPM" primary="true" language="en" script="Latn">CIPM DECN 101-1 (2012, E)</docidentifier>  <docidentifier type="BIPM" primary="true" language="fr" script="Latn">CIPM DECN 101-1 (2012, F)</docidentifier>  <docidentifier type="BIPM-long" language="en" script="Latn">CIPM Decision 101-1 (2012)</docidentifier>  <docidentifier type="BIPM-long" language="fr" script="Latn">Décision CIPM/101-1 (2012)</docidentifier>  <docidentifier type="BIPM-long">CIPM Decision 101-1 (2012) / Décision CIPM/101-1 (2012)</docidentifier>  <docnumber>CIPM DECN 101-1 (2012)</docnumber>  <date type="published">    <on>2012-06-08</on>  </date>  <contributor>    <role type="publisher"/>    <organization>
        <name language="en" script="Latn">International Bureau of Weights and Measures</name>
              <abbreviation>BIPM</abbreviation>      <uri>www.bipm.org</uri>    </organization>  </contributor>  <contributor>    <role type="author"/>    <organization>
        <name language="en" script="Latn">International Committee for Weights and Measures</name>
              <abbreviation>CIPM</abbreviation>    </organization>  </contributor>  <language>en</language>  <language>fr</language>  <script>Latn</script>  <place>    <city>Paris</city>  </place></bibitem>
                  </references>
                  </bibliography>
                </bipm-standard>
      INPUT
      output = <<~OUTPUT
        <sections>
          <clause id='_' obligation='normative' displayorder='2'>
            <title depth="1">1.<tab/>Clause</title>
            <p id='_'>
            <link target="https://www.bipm.org/en/committees/cg/cgpm/1-1889">CGPM 1st Meeting (1889)</link>
            <link target="https://www.bipm.org/en/committees/ci/cipm/101-_1-2012">CIPM DECN 101-1 (2012, E)</link>
            </p>
          </clause>
        </sections>
      OUTPUT
      expect(xmlpp(Nokogiri::XML(IsoDoc::BIPM::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input, true))
         .at("//xmlns:sections").to_xml))
        .to be_equivalent_to xmlpp(output)
      output = <<~OUTPUT
        <sections>
          <clause id='_' obligation='normative' displayorder='2'>
            <title depth="1">1.<tab/>Clause</title>
            <p id='_'>
            <link target="https://www.bipm.org/fr/committees/cg/cgpm/1-1889">CGPM 1e Réunion (1889)</link>
            <link target="https://www.bipm.org/fr/committees/ci/cipm/101-_1-2012">CIPM DECN 101-1 (2012, F)</link>
            </p>
          </clause>
        </sections>
      OUTPUT
      input = input.sub("<language>en</language>", "<language>fr</language>")
      expect(xmlpp(Nokogiri::XML(IsoDoc::BIPM::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input, true))
         .at("//xmlns:sections").to_xml))
        .to be_equivalent_to xmlpp(output)
    end
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
        <references id='_normative_references' obligation='informative' normative='false' displayorder='2'>
          <title depth='1'>Bibliography</title>
          <bibitem id='ref1' type='standard'>
            <formattedref><em>Cereals or cereal products</em>. ABC.</formattedref>
            <docidentifier type='metanorma-ordinal'>[1]</docidentifier>
            <docidentifier>ABC</docidentifier>
            <docidentifier scope="biblio-tag">ABC</docidentifier>
            <biblio-tag>[1]<tab/>ABC </biblio-tag>
          </bibitem>
          <bibitem id='ref2' type='standard' hidden='true'>
            <formattedref><em>Cereals or cereal products</em>. ABD.</formattedref>
            <docidentifier>ABD</docidentifier>
            <docidentifier scope="biblio-tag">ABD</docidentifier>
          </bibitem>
          <bibitem id='ref3' type='standard'>
            <formattedref><em>Cereals or cereal products</em>. ABE.</formattedref>
            <docidentifier type='metanorma-ordinal'>[2]</docidentifier>
            <docidentifier>ABE</docidentifier>
            <docidentifier scope="biblio-tag">ABE</docidentifier>
            <biblio-tag>[2]<tab/>ABE </biblio-tag>
          </bibitem>
        </references>
      </bibliography>
    PRESXML
    expect(xmlpp(Nokogiri::XML(
      IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true),
    ).at("//xmlns:bibliography").to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "hides BIPM CGPM Resolution and BIPM CIPM Decision references in brochure" do
    VCR.use_cassette "isodoc2" do
      input = <<~INPUT
         <bipm-standard xmlns="http://riboseinc.com/isoxml">
         <bibdata>
         <language>en</language>
         <ext><doctype>brochure</doctype></ext>
         </bibdata>
         <bibliography><references id="_normative_references" obligation="informative" normative="false"><title>Bibliography</title>
                           <bibitem id='a1'>
              <title format='text/plain' language='en' script='Latn'>1st meeting of the CGPM</title>
              <uri type='src'>https://www.bipm.org/en/committees/cg/cgpm/1-1889</uri>
              <docidentifier type='BIPM' primary='true'>CGPM Resolution 1</docidentifier>
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
              <docidentifier type='BIPM' primary='true'>CIPM Decision 105</docidentifier>
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
          <references id="_normative_references" obligation="informative" normative="false" displayorder="2" hidden="true">
            <title depth="1">Bibliography</title>
            <bibitem id="a1" hidden="true">
              <formattedref>Bureau International des Poids et Mesures. (1889) <em>1st meeting of the CGPM</em>. CGPM Resolution 1. <link target="https://www.bipm.org/en/committees/cg/cgpm/1-1889">https://www.bipm.org/en/committees/cg/cgpm/1-1889</link>. [viewed: #{Date.today.strftime('%B %-d, %Y')}].</formattedref>
              <uri type="src">https://www.bipm.org/en/committees/cg/cgpm/1-1889</uri>
              <docidentifier type="BIPM" primary="true">CGPM Resolution 1</docidentifier>
              <docidentifier scope="biblio-tag">CGPM Resolution 1</docidentifier>
            </bibitem>
            <bibitem id="a2" hidden="true">
              <formattedref>Bureau International des Poids et Mesures. (2016) <em>105th meeting of the CIPM</em>. CIPM Decision 105. <link target="https://www.bipm.org/en/committees/ci/cipm/105-2016">https://www.bipm.org/en/committees/ci/cipm/105-2016</link>. [viewed: #{Date.today.strftime('%B %-d, %Y')}].</formattedref>
              <uri type="src">https://www.bipm.org/en/committees/ci/cipm/105-2016</uri>
              <docidentifier type="BIPM" primary="true">CIPM Decision 105</docidentifier>
              <docidentifier scope="biblio-tag">CIPM Decision 105</docidentifier>
            </bibitem>
          </references>
        </bibliography>
      PRESXML
      expect(xmlpp(Nokogiri::XML(
        IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
        .convert("test", input, true),
      ).at("//xmlns:bibliography").to_xml))
        .to be_equivalent_to xmlpp(presxml)
    end
  end

  it "does not hide BIPM CGPM Resolution and BIPM CIPM Decision references outside of brochure" do
    VCR.use_cassette "isodoc3" do
      input = <<~INPUT
         <bipm-standard xmlns="http://riboseinc.com/isoxml">
         <bibdata>
         <language>en</language>
         <ext><doctype>nonbrochure</doctype></ext>
         </bibdata>
         <bibliography><references id="_normative_references" obligation="informative" normative="false"><title>Bibliography</title>
                           <bibitem id='a1'>
              <title format='text/plain' language='en' script='Latn'>1st meeting of the CGPM</title>
              <uri type='src'>https://www.bipm.org/en/committees/cg/cgpm/1-1889</uri>
              <docidentifier type='BIPM' primary='true'>CGPM Resolution 1</docidentifier>
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
              <docidentifier type='BIPM' primary='true'>CIPM Decision 105</docidentifier>
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
           <references id="_normative_references" obligation="informative" normative="false" displayorder="2">
             <title depth="1">Bibliography</title>
             <bibitem id="a1">
               <formattedref>Bureau International des Poids et Mesures. (1889) <em>1st meeting of the CGPM</em>. CGPM Resolution 1. <link target="https://www.bipm.org/en/committees/cg/cgpm/1-1889">https://www.bipm.org/en/committees/cg/cgpm/1-1889</link>. [viewed: #{Date.today.strftime('%B %-d, %Y')}].</formattedref>
               <uri type="src">https://www.bipm.org/en/committees/cg/cgpm/1-1889</uri>
               <docidentifier type="metanorma-ordinal">[1]</docidentifier>
               <docidentifier type="BIPM" primary="true">CGPM Resolution 1</docidentifier>
               <docidentifier scope="biblio-tag">CGPM Resolution 1</docidentifier>
               <biblio-tag>[1]<tab/>CGPM Resolution 1 </biblio-tag>
             </bibitem>
             <bibitem id="a2">
             <formattedref>Bureau International des Poids et Mesures. (2016) <em>105th meeting of the CIPM</em>. CIPM Decision 105. <link target="https://www.bipm.org/en/committees/ci/cipm/105-2016">https://www.bipm.org/en/committees/ci/cipm/105-2016</link>. [viewed: #{Date.today.strftime('%B %-d, %Y')}].</formattedref>
               <uri type="src">https://www.bipm.org/en/committees/ci/cipm/105-2016</uri>
               <docidentifier type="metanorma-ordinal">[2]</docidentifier>
               <docidentifier type="BIPM" primary="true">CIPM Decision 105</docidentifier>
               <docidentifier scope="biblio-tag">CIPM Decision 105</docidentifier>
               <biblio-tag>[2]<tab/>CIPM Decision 105 </biblio-tag>
             </bibitem>
           </references>
         </bibliography>
      PRESXML
      expect(xmlpp(Nokogiri::XML(
        IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
        .convert("test", input, true),
      ).at("//xmlns:bibliography").to_xml))
        .to be_equivalent_to xmlpp(presxml)
    end
  end
end
