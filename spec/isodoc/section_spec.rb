require "spec_helper"

RSpec.describe IsoDoc::BIPM do
  it "processes section names" do
    input = <<~INPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
          <foreword obligation="informative">
            <title>Foreword</title>
            <p id="A">This is a preamble</p>
          </foreword>
          <introduction id="B" obligation="informative">
            <title>Introduction</title>
            <clause id="C" inline-header="false" obligation="informative">
              <title>Introduction Subsection</title>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id="H" obligation="normative">
            <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <terms id="I" obligation="normative">
              <title>Normal Terms</title>
              <term id="J">
                <preferred>Term2</preferred>
              </term>
            </terms>
            <clause id="D" obligation="normative">
              <title>Scope</title>
              <p id="E">Text</p>
            </clause>
            <definitions id="K">
              <dl>
                <dt>Symbol</dt>
                <dd>Definition</dd>
              </dl>
            </definitions>
          </clause>
          <definitions id="L">
            <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
            </dl>
          </definitions>
          <clause id="M" inline-header="false" obligation="normative">
            <title>Clause 4</title>
            <clause id="N" inline-header="false" obligation="normative">
              <title>Introduction</title>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title>Clause 4.2</title>
            </clause>
          </clause>
        </sections>
        <annex id="P" inline-header="false" obligation="normative">
          <title>Annex</title>
          <clause id="Q" inline-header="false" obligation="normative">
            <title>Annex A.1</title>
            <clause id="Q1" inline-header="false" obligation="normative">
              <title>Annex A.1a</title>
            </clause>
          </clause>
        </annex>
        <bibliography>
          <references id="R" normative="true" obligation="informative">
            <title>Normative References</title>
          </references>
          <clause id="S" obligation="informative">
            <title>Bibliography</title>
            <references id="T" normative="false" obligation="informative">
              <title>Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </bipm-standard>
    INPUT

    presxml = xmlpp(<<~OUTPUT)
      <bipm-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
        <preface>
            <clause type="toc" id="_" displayorder="1">
          <title depth="1">Contents</title>
        </clause>
          <foreword obligation="informative" displayorder="2">
            <title>Foreword</title>
            <p id="A">This is a preamble</p>
          </foreword>
          <introduction id="B" obligation="informative" displayorder="3">
            <title>Introduction</title>
            <clause id="C" inline-header="false" obligation="informative">
              <title depth="2">Introduction Subsection</title>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id="H" obligation="normative" displayorder="7">
            <title depth="1">1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <terms id="I" obligation="normative">
              <title depth="2">1.1.<tab/>Normal Terms</title>
              <term id="J"><name>1.1.1.</name>
                <preferred>Term2</preferred>
              </term>
            </terms>
            <clause id="D" obligation="normative">
              <title depth="2">1.2.<tab/>Scope</title>
              <p id="E">Text</p>
            </clause>
            <definitions id="K"><title>1.3.</title>
              <dl>
                <dt>Symbol</dt>
                <dd>Definition</dd>
              </dl>
            </definitions>
          </clause>
          <definitions id="L" displayorder="8"><title>2.</title>
            <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
            </dl>
          </definitions>
          <clause id="M" inline-header="false" obligation="normative" displayorder="9">
            <title depth="1">3.<tab/>Clause 4</title>
            <clause id="N" inline-header="false" obligation="normative">
              <title depth="2">3.1.<tab/>Introduction</title>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title depth="2">3.2.<tab/>Clause 4.2</title>
            </clause>
          </clause>
        </sections>
        <annex id="P" inline-header="false" obligation="normative" displayorder="10">
          <title><strong>Appendix 1</strong>.<tab/><strong>Annex</strong></title>
          <clause id="Q" inline-header="false" obligation="normative">
            <title depth="2">A1.1.<tab/>Annex A.1</title>
            <clause id="Q1" inline-header="false" obligation="normative">
              <title depth="3">A1.1.1.<tab/>Annex A.1a</title>
            </clause>
          </clause>
        </annex>
        <bibliography>
          <references id="R" normative="true" obligation="informative" displayorder="4">
            <title depth="1">1.<tab/>Normative References</title>
          </references>
          <clause id="S" obligation="informative" displayorder="11">
            <title depth="1">Bibliography</title>
            <references id="T" normative="false" obligation="informative">
              <title depth="2">Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </bipm-standard>
    OUTPUT

    html = <<~OUTPUT
      <html lang='en'>
        <head/>
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
            <br/>
            <div>
                           <h1 class="ForewordTitle">Foreword</h1>
               <p id="A">This is a preamble</p>
             </div>
             <br/>
             <div class="Section3" id="B">
               <h1 class="IntroTitle">Introduction</h1>
               <div id="C">
                 <h2>Introduction Subsection</h2>
               </div>
             </div>
             <p class="zzSTDTitle1"/>
             <div id="H">
               <h1>1.  Terms, Definitions, Symbols and Abbreviated Terms</h1>
               <div id="I">
                 <h2>1.1.  Normal Terms</h2>
                 <p class="TermNum" id="J">1.1.1.</p>
                 <p class="Terms" style="text-align:left;">Term2</p>
               </div>
               <div id="D">
                 <h2>1.2.  Scope</h2>
                 <p id="E">Text</p>
               </div>
               <div id="K">
                 <h2>1.3.</h2>
                 <dl>
                   <dt>
                     <p>Symbol</p>
                   </dt>
                   <dd>Definition</dd>
                 </dl>
               </div>
             </div>
             <div id="L">
               <h1>2.</h1>
               <dl>
                 <dt>
                   <p>Symbol</p>
                 </dt>
                 <dd>Definition</dd>
               </dl>
             </div>
             <div id="M">
               <h1>3.  Clause 4</h1>
               <div id="N">
                 <h2>3.1.  Introduction</h2>
               </div>
               <div id="O">
                 <h2>3.2.  Clause 4.2</h2>
               </div>
             </div>
             <br/>
             <div id="P" class="Section3">
               <h1 class="Annex"><b>Appendix 1</b>.  <b>Annex</b></h1>
               <div id="Q">
                 <h2>A1.1.  Annex A.1</h2>
                 <div id="Q1">
                   <h3>A1.1.1.  Annex A.1a</h3>
                 </div>
               </div>
             </div>
             <br/>
             <div>
               <h1 class="Section3">Bibliography</h1>
               <div>
                 <h2 class="Section3">Bibliography Subsection</h2>
               </div>
             </div>
           </div>
         </body>
       </html>
    OUTPUT
    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))
    expect(stripped_html).to(be_equivalent_to(xmlpp(presxml)))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)))
    expect(stripped_html).to(be_equivalent_to(xmlpp(html)))
  end

  it "processes section names, JCGM" do
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
        <preface>
          <foreword obligation="informative">
            <title>Foreword</title>
            <p id="A">This is a preamble</p>
          </foreword>
          <introduction id="B" obligation="informative">
            <title>Introduction</title>
            <clause id="C" inline-header="false" obligation="informative">
              <title>Introduction Subsection</title>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id="G" type="scope">
            <title>Scope</title>
          </clause>
          <clause id="H" obligation="normative">
            <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <terms id="I" obligation="normative">
              <title>Normal Terms</title>
              <term id="J">
                <preferred>Term2</preferred>
              </term>
            </terms>
            <clause id="D" obligation="normative">
              <title>Scope</title>
              <p id="E">Text</p>
            </clause>
            <definitions id="K">
              <dl>
                <dt>Symbol</dt>
                <dd>Definition</dd>
              </dl>
            </definitions>
          </clause>
          <definitions id="L">
            <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
            </dl>
          </definitions>
          <clause id="M" inline-header="false" obligation="normative">
            <title>Clause 4</title>
            <clause id="N" inline-header="false" obligation="normative">
              <title>Introduction</title>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title>Clause 4.2</title>
            </clause>
          </clause>
        </sections>
        <annex id="P" inline-header="false" obligation="normative">
          <title>Annex</title>
          <clause id="Q" inline-header="false" obligation="normative">
            <title>Annex A.1</title>
            <clause id="Q1" inline-header="false" obligation="normative">
              <title>Annex A.1a</title>
            </clause>
          </clause>
        </annex>
        <bibliography>
          <references id="R" normative="true" obligation="informative">
            <title>Normative References</title>
          </references>
          <clause id="S" obligation="informative">
            <title>Bibliography</title>
            <references id="T" normative="false" obligation="informative">
              <title>Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </bipm-standard>
    INPUT

    presxml = xmlpp(<<~OUTPUT)
      <bipm-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
        <bibdata>
          <ext>
            <editorialgroup>
              <committee acronym="JCGM">
                Joint Committee for Guides in Metrology
                Comit&#xE9; commun pour les guides en m&#xE9;trologie
              </committee>
            </editorialgroup>
          </ext>
        </bibdata>
        <preface>
          <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
          <foreword obligation="informative" displayorder="2">
            <title>Foreword</title>
            <p id="A">This is a preamble</p>
          </foreword>
          <introduction id="B" obligation="informative" displayorder="3">
            <title depth="1">Introduction</title>
            <clause id="C" inline-header="false" obligation="informative">
              <title depth="2">0.1.<tab/>Introduction Subsection</title>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id="G" type="scope" displayorder="8">
            <title depth="1">1.<tab/>Scope</title>
          </clause>
          <clause id="H" obligation="normative" displayorder="9">
            <title depth="1">3.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <terms id="I" obligation="normative">
              <title depth="2">3.1.<tab/>Normal Terms</title>
              <term id="J"><name>3.1.1.</name>
                <preferred>Term2</preferred>
              </term>
            </terms>
            <clause id="D" obligation="normative">
              <title depth="2">3.2.<tab/>Scope</title>
              <p id="E">Text</p>
            </clause>
            <definitions id="K"><title>3.3.</title>
              <dl>
                <dt>Symbol</dt>
                <dd>Definition</dd>
              </dl>
            </definitions>
          </clause>
          <definitions id="L" displayorder="10"><title>4.</title>
            <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
            </dl>
          </definitions>
          <clause id="M" inline-header="false" obligation="normative" displayorder="11">
            <title depth="1">5.<tab/>Clause 4</title>
            <clause id="N" inline-header="false" obligation="normative">
              <title depth="2">5.1.<tab/>Introduction</title>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title depth="2">5.2.<tab/>Clause 4.2</title>
            </clause>
          </clause>
        </sections>
        <annex id="P" inline-header="false" obligation="normative" displayorder="12">
          <title><strong>Annex A</strong><br/><strong>Annex</strong></title>
          <clause id="Q" inline-header="false" obligation="normative">
            <title depth="2">A.1.<tab/>Annex A.1</title>
            <clause id="Q1" inline-header="false" obligation="normative">
              <title depth="3">A.1.1.<tab/>Annex A.1a</title>
            </clause>
          </clause>
        </annex>
        <bibliography>
          <references id="R" normative="true" obligation="informative" displayorder="5">
            <title depth="1">2.<tab/>Normative References</title>
          </references>
          <clause id="S" obligation="informative" displayorder="13">
            <title depth="1">Bibliography</title>
            <references id="T" normative="false" obligation="informative">
              <title depth="2">Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </bipm-standard>
    OUTPUT

    html = <<~OUTPUT
      <html lang='en'>
        <head/>
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
            <br/>
            <div>
                           <h1 class="ForewordTitle">Foreword</h1>
               <p id="A">This is a preamble</p>
             </div>
             <br/>
             <div class="Section3" id="B">
               <h1 class="IntroTitle">Introduction</h1>
               <div id="C">
                 <h2>0.1.  Introduction Subsection</h2>
               </div>
             </div>
             <p class="zzSTDTitle1"/>
             <div id="G">
               <h1>1.  Scope</h1>
             </div>
             <div>
               <h1>2.  Normative References</h1>
             </div>
             <div id="H">
               <h1>3.  Terms, Definitions, Symbols and Abbreviated Terms</h1>
               <div id="I">
                 <h2>3.1.  Normal Terms</h2>
                 <p class="TermNum" id="J">3.1.1.</p>
                 <p class="Terms" style="text-align:left;">Term2</p>
               </div>
               <div id="D">
                 <h2>3.2.  Scope</h2>
                 <p id="E">Text</p>
               </div>
               <div id="K">
                 <h2>3.3.</h2>
                 <dl>
                   <dt>
                     <p>Symbol</p>
                   </dt>
                   <dd>Definition</dd>
                 </dl>
               </div>
             </div>
             <div id="L" class="Symbols">
               <h1>4.</h1>
               <dl>
                 <dt>
                   <p>Symbol</p>
                 </dt>
                 <dd>Definition</dd>
               </dl>
             </div>
             <div id="M">
               <h1>5.  Clause 4</h1>
               <div id="N">
                 <h2>5.1.  Introduction</h2>
               </div>
               <div id="O">
                 <h2>5.2.  Clause 4.2</h2>
               </div>
             </div>
             <br/>
             <div id="P" class="Section3">
               <h1 class="Annex">
                 <b>Annex A</b>
                 <br/>
                 <b>Annex</b>
               </h1>
               <div id="Q">
                 <h2>A.1.  Annex A.1</h2>
                 <div id="Q1">
                   <h3>A.1.1.  Annex A.1a</h3>
                 </div>
               </div>
             </div>
             <br/>
             <div>
               <h1 class="Section3">Bibliography</h1>
               <div>
                 <h2 class="Section3">Bibliography Subsection</h2>
               </div>
             </div>
           </div>
         </body>
       </html>
    OUTPUT
    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))
    expect(stripped_html).to(be_equivalent_to(xmlpp(presxml)))
    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)))
    expect(stripped_html).to(be_equivalent_to(xmlpp(html)))
  end

  it "processes appendix names in appendix document" do
    input = <<~INPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <bibdata>
          <ext>
            <structuredidentifier><appendix>1</appendix></structuredidentifier>
          </ext>
        </bibdata>
        <sections>
          <clause obligation='informative' id="A0">
            <title>Foreword</title>
            <p id='A'><xref target="P"/></p>
          </clause>
        </sections>
        <annex id='P' inline-header='false' obligation='normative'>
          <title>
            <strong>Appendix 1</strong>
            .
            <tab/>
            <strong>Annex</strong>
          </title>
          <clause id='Q' inline-header='false' obligation='normative'>
            <title depth='2'>
              1.1.
              <tab/>
              Annex A.1
            </title>
            <clause id='Q1' inline-header='false' obligation='normative'>
              <title depth='3'>
                1.1.1.
                <tab/>
                Annex A.1a
              </title>
            </clause>
          </clause>
        </annex>
      </bipm-standard>
    INPUT

    output = <<~OUTPUT
      <bipm-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
        <bibdata>
          <ext>
            <structuredidentifier>
              <appendix>1</appendix>
            </structuredidentifier>
          </ext>
        </bibdata>
          <preface>
          <clause type="toc" id="_" displayorder="1">
            <title depth="1">Contents</title>
          </clause>
        </preface>
        <sections>
          <clause obligation='informative' id='A0' displayorder="2">
            <title depth='1'>
              1.
              <tab/>
              Foreword
            </title>
            <p id='A'>
              <xref target='P'>Annex 1</xref>
            </p>
          </clause>
        </sections>
        <annex id='P' inline-header='false' obligation='normative' displayorder="3">
          <title>
            <strong>Annex 1</strong>
            .
            <tab/>
            <strong>
              <strong>Appendix 1</strong>
               .
              <tab/>
              <strong>Annex</strong>
            </strong>
          </title>
          <clause id='Q' inline-header='false' obligation='normative'>
            <title depth='2'>
              A1.1.
              <tab/>
               1.1.
              <tab/>
               Annex A.1
            </title>
            <clause id='Q1' inline-header='false' obligation='normative'>
              <title depth='3'>
                A1.1.1.
                <tab/>
                 1.1.1.
                <tab/>
                 Annex A.1a
              </title>
            </clause>
          </clause>
        </annex>
      </bipm-standard>
    OUTPUT

    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
    expect(stripped_html).to(be_equivalent_to(xmlpp(output)))
  end

  it "processes unnumbered sections" do
    input = <<~INPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
          <foreword obligation="informative">
            <title>Foreword</title>
            <p id="A">This is a preamble:
              <xref target="B"/>
              <xref target="C"/>
              <xref target="D"/>
              <xref target="E"/>
              <xref target="F"/>
              <xref target="A1"/>
              <xref target="B1"/>
              <xref target="A2"/>
              <xref target="B2"/>
              <xref target="C2"/>
            </p>
          </foreword>
          </preface>
        <sections>
          <clause id="B" obligation="normative" unnumbered="true">
            <title>Beta</title>
            <clause id="C">
              <title>Charlie</title>
            </clause>
          </clause>
          <clause id="D" obligation="normative">
            <title>Delta</title>
            <clause id="E" unnumbered="true">
              <title>Echo</title>
            </clause>
            <clause id="F">
              <title>Fox</title>
            </clause>
          </clause>
        </sections>
        <annex id="A1" obligation="normative" unnumbered="true">
          <title>Alpha</title>
          <clause id="B1">
            <title>Beta</title>
          </clause>
        </annex>
        <annex id="A2" obligation="normative">
          <title>Gamma</title>
          <clause id="B2" unnumbered="true">
            <title>Delta</title>
          </clause>
          <clause id="C2">
            <title>Epsilon</title>
          </clause>
        </annex>
      </bipm-standard>
    INPUT
    output = <<~OUTPUT
      <bipm-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
        <preface>
          <clause type="toc" id="_" displayorder="1">
            <title depth="1">Contents</title>
          </clause>
          <foreword obligation='informative' displayorder="2">
            <title>Foreword</title>
            <p id='A'>
              This is a preamble:
              <xref target='B'>"Beta"</xref>
              <xref target='C'>"Charlie"</xref>
              <xref target='D'>Chapter 1</xref>
              <xref target='E'>"Echo"</xref>
              <xref target='F'>Section 1.1</xref>
              <xref target='A1'>"Alpha"</xref>
              <xref target='B1'>"Beta"</xref>
              <xref target='A2'>Appendix 1</xref>
              <xref target='B2'>"Delta"</xref>
              <xref target='C2'>Appendix A1.1</xref>
            </p>
          </foreword>
          </preface>
          <sections>
            <clause id='B' unnumbered='true' obligation='normative' displayorder='3'>
              <title depth="1">Beta</title>
              <clause id='C' unnumbered="true">
                <title depth="2">Charlie</title>
              </clause>
            </clause>
            <clause id='D' obligation='normative' displayorder='4'>
              <title depth='1'>
                1.
                <tab/>
                Delta
              </title>
              <clause id='E' unnumbered='true'>
                <title depth="2">Echo</title>
              </clause>
              <clause id='F'>
                <title depth='2'>
                  1.1.
                  <tab/>
                  Fox
                </title>
              </clause>
            </clause>
          </sections>
          <annex id='A1' obligation='normative' unnumbered='true' displayorder='5'>
            <title>Alpha</title>
            <clause id='B1' unnumbered="true">
              <title depth="2">Beta</title>
            </clause>
          </annex>
          <annex id='A2' obligation='normative' displayorder='6'>
            <title>
              <strong>Appendix 1</strong>
              .
              <tab/>
              <strong>Gamma</strong>
            </title>
            <clause id='B2' unnumbered='true'>
              <title depth="2">Delta</title>
            </clause>
            <clause id='C2'>
              <title depth='2'>
                A1.1.
                <tab/>
                Epsilon
              </title>
            </clause>
          </annex>
      </bipm-standard>
    OUTPUT
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to xmlpp(output)
  end

  it "handles quoted variant titles" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata/>
      <sections>
      <clause id='A' obligation='normative'>
        <title>Clause</title>
        <clause id='B' obligation='normative'>
          <variant-title type='quoted'>
            <strong>Definition of the metre</strong>
             (CR, 85)
          </variant-title>
        </clause>
      </clause>
      </sections>
      </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <bibdata/>
           <preface>
          <clause type="toc" id="_" displayorder="1">
            <title depth="1">Contents</title>
          </clause>
        </preface>
          <sections>
             <clause id='A' obligation='normative' displayorder='2'>
               <title depth='1'>1.<tab/>Clause</title>
               <clause id='B' obligation='normative'>
               <title type='quoted' depth='2'><blacksquare/><strong>Definition of the metre</strong> (CR, 85)</title>
               </clause>
             </clause>
           </sections>
         </iso-standard>
    OUTPUT
    html = <<~OUTPUT
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
          <p class='zzSTDTitle1'/>
          <div id='A'>
            <h1>1.&#160; Clause</h1>
            <div id='B'>
              <h2>
                &#9632;
                <b>Definition of the metre</b>
                 (CR, 85)
              </h2>
            </div>
          </div>
        </div>
      </body>
    OUTPUT
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))
      .to be_equivalent_to xmlpp(presxml)
    expect(strip_guid(xmlpp(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to be_equivalent_to xmlpp(html)
  end
end
