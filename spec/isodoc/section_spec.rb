require "spec_helper"

RSpec.describe IsoDoc::Bipm do
  it "processes section names" do
    input = <<~INPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata type="standard">
        <title language="en" format="text/plain" type="title-main">Main Title</title>
        <title language="en" format="text/plain" type="title-cover">Main Title (SI)</title>
        <title language="en" format="text/plain" type="title-appendix">Main Title (SI)</title>
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
          <clause id="H" obligation="normative">
            <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <terms id="I" obligation="normative">
              <title>Normal Terms</title>
              <term id="J">
                <preferred><expression><name>Term2</name></expression></preferred>
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
                  <annex id='QQ' obligation='normative'>
                 <title>Glossary</title>
                   <terms id='QQ1' obligation='normative'>
                     <title>Term Collection</title>
                     <term id='term-term-1'>
                       <preferred><expression><name>Term</name></expression></preferred>
                     </term>
                   </terms>
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

    presxml = Xml::C14n.format(<<~OUTPUT)
        <bipm-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <bibdata type="standard">
              <title language="en" format="text/plain" type="title-main">Main Title</title>
              <title language="en" format="text/plain" type="title-cover">Main Title (SI)</title>
              <title language="en" format="text/plain" type="title-appendix">Main Title (SI)</title>
           </bibdata>
           <preface>
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
              <foreword obligation="informative" displayorder="2" id="_">
                 <title id="_">Foreword</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Foreword</semx>
                 </fmt-title>
                 <p id="A">This is a preamble</p>
              </foreword>
              <introduction id="B" obligation="informative" displayorder="3">
                 <title id="_">Introduction</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Introduction</semx>
                 </fmt-title>
                 <clause id="C" inline-header="false" obligation="informative">
                    <title id="_">Introduction Subsection</title>
                    <fmt-title depth="2">
                       <semx element="title" source="_">Introduction Subsection</semx>
                    </fmt-title>
                 </clause>
              </introduction>
           </preface>
          <sections>
             <clause id="H" obligation="normative" displayorder="4">
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
                <terms id="I" obligation="normative">
                   <title id="_">Normal Terms</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="I">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Normal Terms</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="I">1</semx>
                   </fmt-xref-label>
                   <term id="J">
                      <fmt-name>
                         <span class="fmt-caption-label">
                            <semx element="autonum" source="H">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="I">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="J">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                         </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Section</span>
                         <semx element="autonum" source="H">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="I">1</semx>
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
                   </term>
                </terms>
                <clause id="D" obligation="normative">
                   <title id="_">Scope</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="D">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Scope</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="D">2</semx>
                   </fmt-xref-label>
                   <p id="E">Text</p>
                </clause>
                <definitions id="K">
                   <title id="_">Symbols</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="K">3</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Symbols</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="K">3</semx>
                   </fmt-xref-label>
                   <dl>
                      <dt>Symbol</dt>
                      <dd>Definition</dd>
                   </dl>
                </definitions>
             </clause>
             <definitions id="L" displayorder="5">
                <title id="_">Symbols</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="L">2</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Symbols</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Chapter</span>
                   <semx element="autonum" source="L">2</semx>
                </fmt-xref-label>
                <dl>
                   <dt>Symbol</dt>
                   <dd>Definition</dd>
                </dl>
             </definitions>
             <clause id="M" inline-header="false" obligation="normative" displayorder="6">
                <title id="_">Clause 4</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="M">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Clause 4</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Chapter</span>
                   <semx element="autonum" source="M">3</semx>
                </fmt-xref-label>
                <clause id="N" inline-header="false" obligation="normative">
                   <title id="_">Introduction</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="M">3</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="N">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Introduction</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="M">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="N">1</semx>
                   </fmt-xref-label>
                </clause>
                <clause id="O" inline-header="false" obligation="normative">
                   <title id="_">Clause 4.2</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="M">3</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="O">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Clause 4.2</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="M">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="O">2</semx>
                   </fmt-xref-label>
                </clause>
             </clause>
             <references id="R" normative="true" obligation="informative" displayorder="7">
                <title id="_">Normative References</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="R">4</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Normative References</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Chapter</span>
                   <semx element="autonum" source="R">4</semx>
                </fmt-xref-label>
             </references>
          </sections>
          <annex id="P" inline-header="false" obligation="normative" autonum="1" displayorder="8">
             <title id="_">
                <strong>Annex</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="P">1</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   .
                   <tab/>
                </span>
                <semx element="title" source="_">
                   <strong>Annex</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="P">1</semx>
             </fmt-xref-label>
             <clause id="Q" inline-header="false" obligation="normative">
                <title id="_">Annex A.1</title>
                <fmt-title depth="2">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="P">A1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="Q">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Annex A.1</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Appendix</span>
                   <semx element="autonum" source="P">A1</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="Q">1</semx>
                </fmt-xref-label>
                <clause id="Q1" inline-header="false" obligation="normative">
                   <title id="_">Annex A.1a</title>
                   <fmt-title depth="3">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="P">A1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="Q">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="Q1">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Annex A.1a</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="P">A1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="Q">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="Q1">1</semx>
                   </fmt-xref-label>
                </clause>
             </clause>
          </annex>
          <annex id="QQ" obligation="normative" autonum="2" displayorder="9">
             <title id="_">
                <strong>Glossary</strong>
             </title>
             <fmt-title>
                <span class="fmt-caption-label">
                   <strong>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="QQ">2</semx>
                   </strong>
                </span>
                <span class="fmt-caption-delim">
                   .
                   <tab/>
                </span>
                <semx element="title" source="_">
                   <strong>Glossary</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Appendix</span>
                <semx element="autonum" source="QQ">2</semx>
             </fmt-xref-label>
             <terms id="QQ1" obligation="normative">
                <term id="term-term-1">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="QQ1">A2</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="term-term-1">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Appendix</span>
                      <semx element="autonum" source="QQ1">A2</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="term-term-1">1</semx>
                   </fmt-xref-label>
            <preferred id="_">
               <expression>
                  <name>Term</name>
               </expression>
            </preferred>
            <fmt-preferred>
               <p>
                  <semx element="preferred" source="_">
                     <strong>Term</strong>
                  </semx>
               </p>
            </fmt-preferred>
                </term>
             </terms>
          </annex>
          <bibliography>
             <clause id="S" obligation="informative" displayorder="10">
                <title id="_">Bibliography</title>
                <fmt-title depth="1">
                   <semx element="title" source="_">Bibliography</semx>
                </fmt-title>
                <references id="T" normative="false" obligation="informative">
                   <title id="_">Bibliography Subsection</title>
                   <fmt-title depth="2">
                      <semx element="title" source="_">Bibliography Subsection</semx>
                   </fmt-title>
                </references>
             </clause>
          </bibliography>
       </bipm-standard>
    OUTPUT

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
              <div id="_" class="TOC">
                 <h1 class="IntroTitle">Contents</h1>
              </div>
              <br/>
              <div id="_">
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
              <div id="H">
                 <h1>1.  Terms, Definitions, Symbols and Abbreviated Terms</h1>
                 <div id="I">
                    <h2>1.1.  Normal Terms</h2>
                    <p class="TermNum" id="J">1.1.1.</p>
                    <p class="Terms" style="text-align:left;"><b>Term2</b></p>
                 </div>
                 <div id="D">
                    <h2>1.2.  Scope</h2>
                    <p id="E">Text</p>
                 </div>
                 <div id="K">
                    <h2>1.3.  Symbols</h2>
                    <div class="figdl">
                       <dl>
                          <dt>
                             <p>Symbol</p>
                          </dt>
                          <dd>Definition</dd>
                       </dl>
                    </div>
                 </div>
              </div>
              <div id="L" class="Symbols">
                 <h1>2.  Symbols</h1>
                 <div class="figdl">
                    <dl>
                       <dt>
                          <p>Symbol</p>
                       </dt>
                       <dd>Definition</dd>
                    </dl>
                 </div>
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
              <div>
                 <h1>4.  Normative References</h1>
              </div>
              <br/>
              <div id="P" class="Section3">
                 <h1 class="Annex">
                    <b>Appendix 1</b>
                    . 
                    <b>Annex</b>
                 </h1>
                 <div id="Q">
                    <h2>A1.1.  Annex A.1</h2>
                    <div id="Q1">
                       <h3>A1.1.1.  Annex A.1a</h3>
                    </div>
                 </div>
              </div>
              <br/>
                    <div id="QQ" class="Section3">
         <h1 class="Annex">
            <b>Appendix 2</b>
            . 
            <b>Glossary</b>
         </h1>
         <div id="QQ1">
            <p class="TermNum" id="term-term-1">A2.1.</p>
            <p class="Terms" style="text-align:left;">
               <b>Term</b>
            </p>
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
      .gsub(%r{</body>.*}m, "</body>"))))
      .to(be_equivalent_to(Xml::C14n.format(output)))
  end

  it "processes section names, JCGM" do
    input = <<~INPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata type="standard">
        <title language="en" format="text/plain" type="title-main">Main Title</title>
        <title language="en" format="text/plain" type="title-cover">Main Title (SI)</title>
        <title language="en" format="text/plain" type="title-appendix">Main Title (SI)</title>
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
                <preferred><expression><name>Term2</name></expression></preferred>
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

    presxml = Xml::C14n.format(<<~OUTPUT)
        <bipm-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <bibdata type="standard">
              <title language="en" format="text/plain" type="title-main">Main Title</title>
              <title language="en" format="text/plain" type="title-cover">Main Title (SI)</title>
              <title language="en" format="text/plain" type="title-appendix">Main Title (SI)</title>
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
              <foreword obligation="informative" displayorder="2" id="_">
                 <title id="_">Foreword</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Foreword</semx>
                 </fmt-title>
                 <p id="A">This is a preamble</p>
              </foreword>
              <introduction id="B" obligation="informative" displayorder="3">
                 <title id="_">Introduction</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Introduction</semx>
                 </fmt-title>
                 <clause id="C" inline-header="false" obligation="informative">
                    <title id="_">Introduction Subsection</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="B">0</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="C">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Introduction Subsection</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <semx element="autonum" source="B">0</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="C">1</semx>
                    </fmt-xref-label>
                 </clause>
              </introduction>
           </preface>
           <sections>
              <p class="zzSTDTitle1" displayorder="4">
                 <span class="boldtitle">Main Title</span>
              </p>
              <clause id="G" type="scope" displayorder="5">
                 <title id="_">Scope</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="G">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Scope</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="G">1</semx>
                 </fmt-xref-label>
              </clause>
              <clause id="H" obligation="normative" displayorder="7">
                 <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="H">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="H">3</semx>
                 </fmt-xref-label>
                 <terms id="I" obligation="normative">
                    <title id="_">Normal Terms</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="H">3</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="I">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Normal Terms</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <semx element="autonum" source="H">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="I">1</semx>
                    </fmt-xref-label>
                    <term id="J">
                       <fmt-name>
                          <span class="fmt-caption-label">
                             <semx element="autonum" source="H">3</semx>
                             <span class="fmt-autonum-delim">.</span>
                             <semx element="autonum" source="I">1</semx>
                             <span class="fmt-autonum-delim">.</span>
                             <semx element="autonum" source="J">1</semx>
                             <span class="fmt-autonum-delim">.</span>
                          </span>
                       </fmt-name>
                       <fmt-xref-label>
                          <semx element="autonum" source="H">3</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="I">1</semx>
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
                    </term>
                 </terms>
                 <clause id="D" obligation="normative">
                    <title id="_">Scope</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="H">3</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="D">2</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Scope</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <semx element="autonum" source="H">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="D">2</semx>
                    </fmt-xref-label>
                    <p id="E">Text</p>
                 </clause>
                 <definitions id="K">
                    <title id="_">Symbols</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="H">3</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="K">3</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Symbols</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <semx element="autonum" source="H">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="K">3</semx>
                    </fmt-xref-label>
                    <dl>
                       <dt>Symbol</dt>
                       <dd>Definition</dd>
                    </dl>
                 </definitions>
              </clause>
              <definitions id="L" displayorder="8">
                 <title id="_">Symbols</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="L">4</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Symbols</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="L">4</semx>
                 </fmt-xref-label>
                 <dl>
                    <dt>Symbol</dt>
                    <dd>Definition</dd>
                 </dl>
              </definitions>
              <clause id="M" inline-header="false" obligation="normative" displayorder="9">
                 <title id="_">Clause 4</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="M">5</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Clause 4</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="M">5</semx>
                 </fmt-xref-label>
                 <clause id="N" inline-header="false" obligation="normative">
                    <title id="_">Introduction</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="M">5</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="N">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Introduction</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <semx element="autonum" source="M">5</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="N">1</semx>
                    </fmt-xref-label>
                 </clause>
                 <clause id="O" inline-header="false" obligation="normative">
                    <title id="_">Clause 4.2</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="M">5</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="O">2</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Clause 4.2</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <semx element="autonum" source="M">5</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="O">2</semx>
                    </fmt-xref-label>
                 </clause>
              </clause>
              <references id="R" normative="true" obligation="informative" displayorder="6">
                 <title id="_">Normative References</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="R">2</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Normative References</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="R">2</semx>
                 </fmt-xref-label>
              </references>
           </sections>
           <annex id="P" inline-header="false" obligation="normative" autonum="A" displayorder="10">
              <title id="_">
                 <strong>Annex</strong>
              </title>
              <fmt-title>
                 <span class="fmt-caption-label">
                    <strong>
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="P">A</semx>
                    </strong>
                 </span>
                 <span class="fmt-caption-delim">
                    <br/>
                 </span>
                 <semx element="title" source="_">
                    <strong>Annex</strong>
                 </semx>
              </fmt-title>
              <fmt-xref-label>
                 <span class="fmt-element-name">Annex</span>
                 <semx element="autonum" source="P">A</semx>
              </fmt-xref-label>
              <clause id="Q" inline-header="false" obligation="normative">
                 <title id="_">Annex A.1</title>
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="P">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Q">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Annex A.1</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <semx element="autonum" source="P">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q">1</semx>
                 </fmt-xref-label>
                 <clause id="Q1" inline-header="false" obligation="normative">
                    <title id="_">Annex A.1a</title>
                    <fmt-title depth="3">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="P">A</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="Q">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="Q1">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Annex A.1a</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <semx element="autonum" source="P">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Q">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Q1">1</semx>
                    </fmt-xref-label>
                 </clause>
              </clause>
           </annex>
           <bibliography>
              <clause id="S" obligation="informative" displayorder="11">
                 <title id="_">Bibliography</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Bibliography</semx>
                 </fmt-title>
                 <references id="T" normative="false" obligation="informative">
                    <title id="_">Bibliography Subsection</title>
                    <fmt-title depth="2">
                       <semx element="title" source="_">Bibliography Subsection</semx>
                    </fmt-title>
                 </references>
              </clause>
           </bibliography>
        </bipm-standard>
    OUTPUT

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
              <div id="_" class="TOC">
                 <h1 class="IntroTitle">Contents</h1>
              </div>
              <br/>
              <div id="_">
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
              <p class="zzSTDTitle1">
                 <span class="boldtitle">Main Title</span>
              </p>
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
                    <p class="Terms" style="text-align:left;"><b>Term2</b></p>
                 </div>
                 <div id="D">
                    <h2>3.2.  Scope</h2>
                    <p id="E">Text</p>
                 </div>
                 <div id="K">
                    <h2>3.3.  Symbols</h2>
                    <div class="figdl">
                       <dl>
                          <dt>
                             <p>Symbol</p>
                          </dt>
                          <dd>Definition</dd>
                       </dl>
                    </div>
                 </div>
              </div>
              <div id="L" class="Symbols">
                 <h1>4.  Symbols</h1>
                 <div class="figdl">
                    <dl>
                       <dt>
                          <p>Symbol</p>
                       </dt>
                       <dd>Definition</dd>
                    </dl>
                 </div>
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
      .gsub(%r{</body>.*}m, "</body>"))))
      .to(be_equivalent_to(Xml::C14n.format(output)))
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
            <strong>Annex</strong>
          </title>
          <clause id='Q' inline-header='false' obligation='normative'>
            <title depth='2'>
              Annex A.1
            </title>
            <clause id='Q1' inline-header='false' obligation='normative'>
              <title depth='3'>
                Annex A.1a
              </title>
            </clause>
          </clause>
        </annex>
      </bipm-standard>
    INPUT

    output = <<~OUTPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <bibdata>
              <ext>
                 <structuredidentifier>
                    <appendix>1</appendix>
                 </structuredidentifier>
              </ext>
           </bibdata>
           <preface>
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
           </preface>
           <sections>
              <clause obligation="informative" id="A0" displayorder="2">
                 <title id="_">Foreword</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="A0">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Foreword</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="A0">1</semx>
                 </fmt-xref-label>
                 <p id="A">
            <xref target="P" id="_"/>
            <semx element="xref" source="_">
               <fmt-xref target="P">
                  <span class="fmt-element-name">Annex</span>
                  <semx element="autonum" source="P">1</semx>
               </fmt-xref>
            </semx>
                 </p>
              </clause>
           </sections>
           <annex id="P" inline-header="false" obligation="normative" autonum="1" displayorder="3">
              <title id="_">
                 <strong>
                    <strong>Annex</strong>
                 </strong>
              </title>
              <fmt-title>
                 <span class="fmt-caption-label">
                    <strong>
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="P">1</semx>
                    </strong>
                 </span>
                 <span class="fmt-caption-delim">
                    .
                    <tab/>
                 </span>
                 <semx element="title" source="_">
                    <strong>
                       <strong>Annex</strong>
                    </strong>
                 </semx>
              </fmt-title>
              <fmt-xref-label>
                 <span class="fmt-element-name">Annex</span>
                 <semx element="autonum" source="P">1</semx>
              </fmt-xref-label>
              <clause id="Q" inline-header="false" obligation="normative">
                 <title depth="2" id="_">
                Annex A.1
              </title>
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="P">A1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Q">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">
                Annex A.1
              </semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Annex</span>
                    <semx element="autonum" source="P">A1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q">1</semx>
                 </fmt-xref-label>
                 <clause id="Q1" inline-header="false" obligation="normative">
                    <title depth="3" id="_">
                  Annex A.1a
                </title>
                    <fmt-title depth="3">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="P">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="Q">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="Q1">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">
                  Annex A.1a
                </semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="P">A1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Q">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Q1">1</semx>
                    </fmt-xref-label>
                 </clause>
              </clause>
           </annex>
        </bipm-standard>
    OUTPUT

    stripped_html =
      Xml::C14n.format(strip_guid(IsoDoc::Bipm::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
    expect(stripped_html).to(be_equivalent_to(Xml::C14n.format(output)))
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
              <xref target="C1"/>
              <xref target="D"/>
              <xref target="E"/>
              <xref target="F"/>
              <xref target="G"/>
              <xref target="A1"/>
              <xref target="B1"/>
              <xref target="A2"/>
              <xref target="B2"/>
              <xref target="C2"/>
              <xref target="C3"/>
              <xref target="C4"/>
              <xref target="QQ"/>
              <xref target="QQ1"/>
            </p>
          </foreword>
          </preface>
        <sections>
          <clause id="B" obligation="normative" unnumbered="true">
            <title>Beta</title>
            <clause id="C">
              <title>Charlie</title>
            <clause id="C1">
              <title>Charlie1</title>
            </clause>
            </clause>
          </clause>
          <clause id="D" obligation="normative">
            <title>Delta</title>
            <clause id="E" unnumbered="true">
              <title>Echo</title>
            </clause>
            <clause id="F">
              <title>Fox</title>
            <clause id="G" unnumbered="true">
              <title>Golf</title>
            </clause>
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
          <clause id="C3">
            <title>Epsilon</title>
          </clause>
          <clause id="C4" unnumbered="true">
            <title>Epsilon</title>
          </clause>
          </clause>
        </annex>
          <annex id='QQ' obligation='normative' unnumbered="true">
                 <title>Glossary</title>
                   <terms id='QQ1' obligation='normative'>
                     <title>Term Collection</title>
                     <term id='term-term-1'>
                       <preferred><expression><name>Term</name></expression></preferred>
                     </term>
                   </terms>
               </annex>
      </bipm-standard>
    INPUT
    output = <<~OUTPUT
        <bipm-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <preface>
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
              <foreword obligation="informative" id="_" displayorder="2">
                 <title id="_">Foreword</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Foreword</semx>
                 </fmt-title>
                 <p id="A">
                    This is a preamble:
                    <xref target="B" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="B">
                          "
                          <semx element="title" source="B">Beta</semx>
                          "
                       </fmt-xref>
                    </semx>
                    <xref target="C" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="C">
                          "
                          <semx element="title" source="C">Charlie</semx>
                          "
                       </fmt-xref>
                    </semx>
                    <xref target="C1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="C1">
                          "
                          <semx element="title" source="C1">Charlie1</semx>
                          "
                       </fmt-xref>
                    </semx>
                    <xref target="D" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="D">
                          <span class="fmt-element-name">Chapter</span>
                          <semx element="autonum" source="D">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="E" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="E">
                          "
                          <semx element="title" source="E">Echo</semx>
                          "
                       </fmt-xref>
                    </semx>
                    <xref target="F" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="F">
                          <span class="fmt-element-name">Section</span>
                          <semx element="autonum" source="D">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="F">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="G" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="G">
                          "
                          <semx element="title" source="G">Golf</semx>
                          "
                       </fmt-xref>
                    </semx>
                    <xref target="A1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="A1">
                          "
                          <semx element="title" source="A1">Alpha</semx>
                          "
                       </fmt-xref>
                    </semx>
                    <xref target="B1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="B1">
                          "
                          <semx element="title" source="B1">Beta</semx>
                          "
                       </fmt-xref>
                    </semx>
                    <xref target="A2" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="A2">
                          <span class="fmt-element-name">Appendix</span>
                          <semx element="autonum" source="A2">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="B2" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="B2">
                          "
                          <semx element="title" source="B2">Delta</semx>
                          "
                       </fmt-xref>
                    </semx>
                    <xref target="C2" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="C2">
                          <span class="fmt-element-name">Appendix</span>
                          <semx element="autonum" source="A2">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="C2">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="C3" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="C3">
                          <span class="fmt-element-name">Appendix</span>
                          <semx element="autonum" source="A2">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="C2">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="C3">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="C4" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="C4">
                          "
                          <semx element="title" source="C4">Epsilon</semx>
                          "
                       </fmt-xref>
                    </semx>
                    <xref target="QQ" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="QQ">
                          "
                          <semx element="title" source="QQ">Glossary</semx>
                          "
                       </fmt-xref>
                    </semx>
                    <xref target="QQ1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="QQ1">
                          "
                          <semx element="title" source="QQ1">[QQ1]</semx>
                          "
                       </fmt-xref>
                    </semx>
                 </p>
              </foreword>
           </preface>
           <sections>
              <clause id="B" obligation="normative" unnumbered="true" displayorder="4">
                 <title id="_">Beta</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Beta</semx>
                 </fmt-title>
                 <clause id="C" unnumbered="true">
                    <title id="_">Charlie</title>
                    <fmt-title depth="2">
                       <semx element="title" source="_">Charlie</semx>
                    </fmt-title>
                    <clause id="C1" unnumbered="true">
                       <title id="_">Charlie1</title>
                       <fmt-title depth="3">
                          <semx element="title" source="_">Charlie1</semx>
                       </fmt-title>
                    </clause>
                 </clause>
              </clause>
              <clause id="D" obligation="normative" displayorder="3">
                 <title id="_">Delta</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="D">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Delta</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="D">1</semx>
                 </fmt-xref-label>
                 <clause id="E" unnumbered="true">
                    <title id="_">Echo</title>
                    <fmt-title depth="2">
                       <semx element="title" source="_">Echo</semx>
                    </fmt-title>
                 </clause>
                 <clause id="F">
                    <title id="_">Fox</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="D">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="F">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Fox</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Section</span>
                       <semx element="autonum" source="D">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="F">1</semx>
                    </fmt-xref-label>
                    <clause id="G" unnumbered="true">
                       <title id="_">Golf</title>
                       <fmt-title depth="3">
                          <semx element="title" source="_">Golf</semx>
                       </fmt-title>
                    </clause>
                 </clause>
              </clause>
           </sections>
           <annex id="A1" obligation="normative" unnumbered="true" displayorder="6">
              <title id="_">
                 <strong>Alpha</strong>
              </title>
              <fmt-title>
                 <semx element="title" source="_">
                    <strong>Alpha</strong>
                 </semx>
              </fmt-title>
              <clause id="B1" unnumbered="true">
                 <title id="_">Beta</title>
                 <fmt-title depth="2">
                    <semx element="title" source="_">Beta</semx>
                 </fmt-title>
              </clause>
           </annex>
           <annex id="A2" obligation="normative" autonum="1" displayorder="5">
              <title id="_">
                 <strong>Gamma</strong>
              </title>
              <fmt-title>
                 <span class="fmt-caption-label">
                    <strong>
                       <span class="fmt-element-name">Appendix</span>
                       <semx element="autonum" source="A2">1</semx>
                    </strong>
                 </span>
                 <span class="fmt-caption-delim">
                    .
                    <tab/>
                 </span>
                 <semx element="title" source="_">
                    <strong>Gamma</strong>
                 </semx>
              </fmt-title>
              <fmt-xref-label>
                 <span class="fmt-element-name">Appendix</span>
                 <semx element="autonum" source="A2">1</semx>
              </fmt-xref-label>
              <clause id="B2" unnumbered="true">
                 <title id="_">Delta</title>
                 <fmt-title depth="2">
                    <semx element="title" source="_">Delta</semx>
                 </fmt-title>
              </clause>
              <clause id="C2">
                 <title id="_">Epsilon</title>
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="A2">A1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="C2">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Epsilon</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="A2">A1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="C2">1</semx>
                 </fmt-xref-label>
                 <clause id="C3">
                    <title id="_">Epsilon</title>
                    <fmt-title depth="3">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="A2">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="C2">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="C3">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Epsilon</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Appendix</span>
                       <semx element="autonum" source="A2">A1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="C2">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="C3">1</semx>
                    </fmt-xref-label>
                 </clause>
                 <clause id="C4" unnumbered="true">
                    <title id="_">Epsilon</title>
                    <fmt-title depth="3">
                       <semx element="title" source="_">Epsilon</semx>
                    </fmt-title>
                 </clause>
              </clause>
           </annex>
           <annex id="QQ" obligation="normative" unnumbered="true" displayorder="7">
              <title id="_">
                 <strong>Glossary</strong>
              </title>
              <fmt-title>
                 <semx element="title" source="_">
                    <strong>Glossary</strong>
                 </semx>
              </fmt-title>
              <terms id="QQ1" obligation="normative">
                 <term id="term-term-1">
                    <fmt-name>
                       <span class="fmt-caption-label">
                          <semx element="title" source="term-term-1">[term-term-1]</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                    </fmt-name>
                    <fmt-xref-label>
                       "
                       <semx element="title" source="term-term-1">[term-term-1]</semx>
                       "
                    </fmt-xref-label>
                    <preferred id="_">
                       <expression>
                          <name>Term</name>
                       </expression>
                    </preferred>
                    <fmt-preferred>
                       <p>
                          <semx element="preferred" source="_">
                             <strong>Term</strong>
                          </semx>
                       </p>
                    </fmt-preferred>
                 </term>
              </terms>
           </annex>
        </bipm-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
          .new(presxml_options)
      .convert("test", input, true))))
          .to be_equivalent_to Xml::C14n.format(output)
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
        <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <bibdata/>
           <preface>
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
           </preface>
           <sections>
              <clause id="A" obligation="normative" displayorder="2">
                 <title id="_">Clause</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="A">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Clause</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="A">1</semx>
                 </fmt-xref-label>
                 <clause id="B" obligation="normative">
                    <title type="quoted">
                       <blacksquare/>
                       <strong>Definition of the metre</strong>
                       (CR, 85)
                    </title>
                    <fmt-title type="quoted" depth="2">
                       <blacksquare/>
                       <strong>Definition of the metre</strong>
                       (CR, 85)
                    </fmt-title>
                 </clause>
              </clause>
           </sections>
        </iso-standard>
    OUTPUT
    output = <<~OUTPUT
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
end
