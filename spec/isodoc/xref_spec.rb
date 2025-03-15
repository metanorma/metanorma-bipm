require "spec_helper"

RSpec.describe IsoDoc::Bipm do
  it "cross-references formulae" do
    input = <<~INPUT
         <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          </p>
          </foreword>
          <introduction id="intro">
          <formula id="N1">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
        <clause id="xyz"><title>Preparatory</title>
          <formula id="N2" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <formula id="N">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <formula id="note1">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          <formula id="note2">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <formula id="AN">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          </clause>
          <clause id="annex1b">
          <formula id="Anote1" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          <formula id="Anote2">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <preface>
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
              <foreword id="_" displayorder="2">
                 <title id="_">Foreword</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Foreword</semx>
                 </fmt-title>
                 <p>
                    <xref target="N1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="N1">
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="N1">1</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                    <xref target="N2" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="N2">
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="N2">(??)</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                    <xref target="N" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="N">
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="N">2</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                    <xref target="note1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="note1">
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="note1">3</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                    <xref target="note2" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="note2">
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="note2">4</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                    <xref target="AN" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="AN">
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="annex1">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                    <xref target="Anote1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="Anote1">
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="Anote1">(??)</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                    <xref target="Anote2" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="Anote2">
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="annex1">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="Anote2">2</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                 </p>
              </foreword>
              <introduction id="intro" displayorder="3">
                 <formula id="N1" autonum="1">
                    <fmt-name>
                       <span class="fmt-caption-label">
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="N1">1</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </span>
                    </fmt-name>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Equation</span>
                       <span class="fmt-autonum-delim">(</span>
                       <semx element="autonum" source="N1">1</semx>
                       <span class="fmt-autonum-delim">)</span>
                    </fmt-xref-label>
                    <stem type="AsciiMath" id="_">r = 1 %</stem>
                    <fmt-stem type="AsciiMath">
                       <semx element="stem" source="_">r = 1 %</semx>
                    </fmt-stem>
                 </formula>
                 <clause id="xyz">
                    <title id="_">Preparatory</title>
                    <fmt-title depth="2">
                       <semx element="title" source="_">Preparatory</semx>
                    </fmt-title>
                    <formula id="N2" unnumbered="true">
                       <stem type="AsciiMath" id="_">r = 1 %</stem>
                       <fmt-stem type="AsciiMath">
                          <semx element="stem" source="_">r = 1 %</semx>
                       </fmt-stem>
                    </formula>
                 </clause>
              </introduction>
           </preface>
           <sections>
              <clause id="scope" type="scope" displayorder="4">
                 <title id="_">Scope</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="scope">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Scope</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="scope">1</semx>
                 </fmt-xref-label>
                 <formula id="N" autonum="2">
                    <fmt-name>
                       <span class="fmt-caption-label">
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="N">2</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </span>
                    </fmt-name>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Equation</span>
                       <span class="fmt-autonum-delim">(</span>
                       <semx element="autonum" source="N">2</semx>
                       <span class="fmt-autonum-delim">)</span>
                    </fmt-xref-label>
                    <stem type="AsciiMath" id="_">r = 1 %</stem>
                    <fmt-stem type="AsciiMath">
                       <semx element="stem" source="_">r = 1 %</semx>
                    </fmt-stem>
                 </formula>
                 <p>
                    <xref target="N" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="N">
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="N">2</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                 </p>
              </clause>
              <terms id="terms" displayorder="5">
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="terms">2</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="terms">2</semx>
                 </fmt-xref-label>
              </terms>
              <clause id="widgets" displayorder="6">
                 <title id="_">Widgets</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="widgets">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Widgets</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="widgets">3</semx>
                 </fmt-xref-label>
                 <clause id="widgets1">
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="widgets">3</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="widgets1">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Section</span>
                       <semx element="autonum" source="widgets">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="widgets1">1</semx>
                    </fmt-xref-label>
                    <formula id="note1" autonum="3">
                       <fmt-name>
                          <span class="fmt-caption-label">
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="note1">3</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </span>
                       </fmt-name>
                       <fmt-xref-label>
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="note1">3</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref-label>
                       <stem type="AsciiMath" id="_">r = 1 %</stem>
                       <fmt-stem type="AsciiMath">
                          <semx element="stem" source="_">r = 1 %</semx>
                       </fmt-stem>
                    </formula>
                    <formula id="note2" autonum="4">
                       <fmt-name>
                          <span class="fmt-caption-label">
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="note2">4</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </span>
                       </fmt-name>
                       <fmt-xref-label>
                          <span class="fmt-element-name">Equation</span>
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="note2">4</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref-label>
                       <stem type="AsciiMath" id="_">r = 1 %</stem>
                       <fmt-stem type="AsciiMath">
                          <semx element="stem" source="_">r = 1 %</semx>
                       </fmt-stem>
                    </formula>
                    <p>
                       <xref target="note1" id="_"/>
                       <semx element="xref" source="_">
                          <fmt-xref target="note1">
                             <span class="fmt-element-name">Equation</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="note1">3</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref>
                       </semx>
                       <xref target="note2" id="_"/>
                       <semx element="xref" source="_">
                          <fmt-xref target="note2">
                             <span class="fmt-element-name">Equation</span>
                             <span class="fmt-autonum-delim">(</span>
                             <semx element="autonum" source="note2">4</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref>
                       </semx>
                    </p>
                 </clause>
              </clause>
           </sections>
           <annex id="annex1" autonum="1" displayorder="7">
              <fmt-title>
                 <span class="fmt-caption-label">
                    <strong>
                       <span class="fmt-element-name">Appendix</span>
                       <semx element="autonum" source="annex1">1</semx>
                    </strong>
                 </span>
              </fmt-title>
              <fmt-xref-label>
                 <span class="fmt-element-name">Appendix</span>
                 <semx element="autonum" source="annex1">1</semx>
              </fmt-xref-label>
              <clause id="annex1a">
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="annex1">A1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex1a">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="annex1">A1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="annex1a">1</semx>
                 </fmt-xref-label>
                 <formula id="AN" autonum="A1.1">
                    <fmt-name>
                       <span class="fmt-caption-label">
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="annex1">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </span>
                    </fmt-name>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Equation</span>
                       <span class="fmt-autonum-delim">(</span>
                       <semx element="autonum" source="annex1">A1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="AN">1</semx>
                       <span class="fmt-autonum-delim">)</span>
                    </fmt-xref-label>
                    <stem type="AsciiMath" id="_">r = 1 %</stem>
                    <fmt-stem type="AsciiMath">
                       <semx element="stem" source="_">r = 1 %</semx>
                    </fmt-stem>
                 </formula>
              </clause>
              <clause id="annex1b">
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="annex1">A1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex1b">2</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="annex1">A1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="annex1b">2</semx>
                 </fmt-xref-label>
                 <formula id="Anote1" unnumbered="true">
                    <stem type="AsciiMath" id="_">r = 1 %</stem>
                    <fmt-stem type="AsciiMath">
                       <semx element="stem" source="_">r = 1 %</semx>
                    </fmt-stem>
                 </formula>
                 <formula id="Anote2" autonum="A1.2">
                    <fmt-name>
                       <span class="fmt-caption-label">
                          <span class="fmt-autonum-delim">(</span>
                          <semx element="autonum" source="annex1">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="Anote2">2</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </span>
                    </fmt-name>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Equation</span>
                       <span class="fmt-autonum-delim">(</span>
                       <semx element="autonum" source="annex1">A1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Anote2">2</semx>
                       <span class="fmt-autonum-delim">)</span>
                    </fmt-xref-label>
                    <stem type="AsciiMath" id="_">r = 1 %</stem>
                    <fmt-stem type="AsciiMath">
                       <semx element="stem" source="_">r = 1 %</semx>
                    </fmt-stem>
                 </formula>
              </clause>
           </annex>
        </iso-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references sections" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
          <foreword obligation="informative">
            <title>Foreword</title>
            <p id="A">This is a preamble
              <xref target="C"/>
              <xref target="C1"/>
              <xref target="D"/>
              <xref target="H"/>
              <xref target="I"/>
              <xref target="J"/>
              <xref target="K"/>
              <xref target="L"/>
              <xref target="M"/>
              <xref target="N"/>
              <xref target="O"/>
              <xref target="P"/>
              <xref target="Q"/>
              <xref target="Q1"/>
              <xref target="Q2"/>
              <xref target="Q3"/>
              <xref target="R"/></p>
          </foreword>
          <introduction id="B" obligation="informative">
            <title>Introduction</title>
            <clause id="C" inline-header="false" obligation="informative">
              <title>Introduction Subsection</title>
            </clause>
            <clause id="C1" inline-header="false" obligation="informative">Text</clause>
          </introduction>
        </preface>
        <sections>
          <clause id="D" obligation="normative" type="scope">
            <title>Scope</title>
            <p id="E">Text</p>
          </clause>
          <terms id="H" obligation="normative">
            <title>Terms, definitions, symbols and abbreviated terms</title>
            <terms id="I" obligation="normative">
              <title>Normal Terms</title>
              <term id="J">
                <preferred>Term2</preferred>
              </term>
            </terms>
            <definitions id="K">
              <dl>
                <dt>Symbol</dt>
                <dd>Definition</dd>
              </dl>
            </definitions>
          </terms>
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
          <appendix id="Q2" inline-header="false" obligation="normative">
            <title>An Appendix</title>
            <clause id="Q3" inline-header="false" obligation="normative">
              <title>Appendix subclause</title>
            </clause>
          </appendix>
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
      </iso-standard>
    INPUT
    output = <<~OUTPUT
        <foreword obligation="informative" id="_" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p id="A">
              This is a preamble
              <xref target="C" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="C">
                    <semx element="clause" source="C">Introduction Subsection</semx>
                 </fmt-xref>
              </semx>
              <xref target="C1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="C1">
                    <semx element="introduction" source="B">Introduction</semx>
                    <span class="fmt-comma">,</span>
                    <semx element="autonum" source="C1">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="D" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="D">
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="D">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="H" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="H">
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="H">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="I" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="I">
                    <span class="fmt-element-name">Section</span>
                    <semx element="autonum" source="H">2</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="I">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="J" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="J">
                    <span class="fmt-element-name">Section</span>
                    <semx element="autonum" source="H">2</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="I">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="J">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="K" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="K">
                    <span class="fmt-element-name">Section</span>
                    <semx element="autonum" source="H">2</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="K">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="L" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="L">
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="L">3</semx>
                 </fmt-xref>
              </semx>
              <xref target="M" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="M">
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="M">4</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Section</span>
                    <semx element="autonum" source="M">4</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="O" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="O">
                    <span class="fmt-element-name">Section</span>
                    <semx element="autonum" source="M">4</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="O">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="P" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="P">
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="P">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q">
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="P">A1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q1">
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="P">A1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q2">[Q2]</fmt-xref>
              </semx>
              <xref target="Q3" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q3">[Q3]</fmt-xref>
              </semx>
              <xref target="R" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="R">
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="R">5</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .sub(%r{^.*<foreword}m, "<foreword")
      .sub(%r{</foreword>.*$}m, "</foreword>"))))
      .to be_equivalent_to Xml::C14n.format(output)

    output = <<~OUTPUT
        <foreword obligation="informative" id="_" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p id="A">
              This is a preamble
              <xref target="C" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="C">
                    <semx element="autonum" source="B">0</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="C">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="C1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="C1">
                    <semx element="autonum" source="B">0</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="C1">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="D" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="D">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="D">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="H" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="H">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="H">3</semx>
                 </fmt-xref>
              </semx>
              <xref target="I" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="I">
                    <semx element="autonum" source="H">3</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="I">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="J" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="J">
                    <semx element="autonum" source="H">3</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="I">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="J">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="K" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="K">
                    <semx element="autonum" source="H">3</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="K">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="L" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="L">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="L">4</semx>
                 </fmt-xref>
              </semx>
              <xref target="M" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="M">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="M">5</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <semx element="autonum" source="M">5</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="O" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="O">
                    <semx element="autonum" source="M">5</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="O">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="P" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="P">
                    <span class="fmt-element-name">Annex</span>
                    <semx element="autonum" source="P">A</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q">
                    <semx element="autonum" source="P">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q1">
                    <semx element="autonum" source="P">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q2">[Q2]</fmt-xref>
              </semx>
              <xref target="Q3" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q3">[Q3]</fmt-xref>
              </semx>
              <xref target="R" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="R">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="R">2</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input.sub("<sections>", "<bibdata>#{jcgm_ext}</bibdata><sections>"), true)
      .sub(%r{^.*<foreword}m, "<foreword")
      .sub(%r{</foreword>.*$}m, "</foreword>"))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references subfigures" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata>
       </bibdata>
        <preface>
          <foreword id="fwd">
            <p>
              <xref target="N"/>
              <xref target="note1"/>
              <xref target="note2"/>
              <xref target="AN"/>
              <xref target="Anote1"/>
              <xref target="Anote2"/>
            </p>
          </foreword>
        </preface>
        <sections>
          <clause id="scope" type="scope">
            <title>Scope</title>
          </clause>
          <terms id="terms"/>
          <clause id="widgets">
            <title>Widgets</title>
            <clause id="widgets1">
              <figure id="N">
                <figure id="note1">
                  <name>Split-it-right sample divider</name>
                  <image id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png" src="rice_images/rice_image1.png"/>
                </figure>
                <figure id="note2">
                  <name>Split-it-right sample divider</name>
                  <image id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png" src="rice_images/rice_image1.png"/>
                </figure>
              </figure>
              <p>
                <xref target="note1"/>
                <xref target="note2"/>
              </p>
            </clause>
          </clause>
        </sections>
        <annex id="annex1">
          <clause id="annex1a"/>
          <clause id="annex1b">
            <figure id="AN">
              <figure id="Anote1">
                <name>Split-it-right sample divider</name>
                <image id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png" src="rice_images/rice_image1.png"/>
              </figure>
              <figure id="Anote2">
                <name>Split-it-right sample divider</name>
                <image id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png" src="rice_images/rice_image1.png"/>
              </figure>
            </figure>
          </clause>
        </annex>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <bibdata>
         </bibdata>
           <preface>
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
              <foreword id="fwd" displayorder="2">
                 <title id="_">Foreword</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Foreword</semx>
                 </fmt-title>
                 <p>
                    <xref target="N" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="N">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="N">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="note1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="note1">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="N">1</semx>
                          <span class="fmt-autonum-delim">-</span>
                          <semx element="autonum" source="note1">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="note2" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="note2">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="N">1</semx>
                          <span class="fmt-autonum-delim">-</span>
                          <semx element="autonum" source="note2">2</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="AN" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="AN">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="Anote1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="Anote1">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                          <span class="fmt-autonum-delim">-</span>
                          <semx element="autonum" source="Anote1">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="Anote2" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="Anote2">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                          <span class="fmt-autonum-delim">-</span>
                          <semx element="autonum" source="Anote2">2</semx>
                       </fmt-xref>
                    </semx>
                 </p>
              </foreword>
           </preface>
           <sections>
              <clause id="scope" type="scope" displayorder="3">
                 <title id="_">Scope</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="scope">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Scope</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="scope">1</semx>
                 </fmt-xref-label>
              </clause>
              <terms id="terms" displayorder="4">
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="terms">2</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="terms">2</semx>
                 </fmt-xref-label>
              </terms>
              <clause id="widgets" displayorder="5">
                 <title id="_">Widgets</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="widgets">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Widgets</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Chapter</span>
                    <semx element="autonum" source="widgets">3</semx>
                 </fmt-xref-label>
                 <clause id="widgets1">
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="widgets">3</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="widgets1">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Section</span>
                       <semx element="autonum" source="widgets">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="widgets1">1</semx>
                    </fmt-xref-label>
                    <figure id="N" autonum="1">
                       <figure id="note1" autonum="1-1">
                          <name id="_">Split-it-right sample divider</name>
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Figure</span>
                                <semx element="autonum" source="N">1</semx>
                                <span class="fmt-autonum-delim">-</span>
                                <semx element="autonum" source="note1">1</semx>
                             </span>
                             <span class="fmt-caption-delim"> — </span>
                             <semx element="name" source="_">Split-it-right sample divider</semx>
                          </fmt-name>
                          <fmt-xref-label>
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="N">1</semx>
                             <span class="fmt-autonum-delim">-</span>
                             <semx element="autonum" source="note1">1</semx>
                          </fmt-xref-label>
                          <image id="_" mimetype="image/png" src="rice_images/rice_image1.png"/>
                       </figure>
                       <figure id="note2" autonum="1-2">
                          <name id="_">Split-it-right sample divider</name>
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <span class="fmt-element-name">Figure</span>
                                <semx element="autonum" source="N">1</semx>
                                <span class="fmt-autonum-delim">-</span>
                                <semx element="autonum" source="note2">2</semx>
                             </span>
                             <span class="fmt-caption-delim"> — </span>
                             <semx element="name" source="_">Split-it-right sample divider</semx>
                          </fmt-name>
                          <fmt-xref-label>
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="N">1</semx>
                             <span class="fmt-autonum-delim">-</span>
                             <semx element="autonum" source="note2">2</semx>
                          </fmt-xref-label>
                          <image id="_" mimetype="image/png" src="rice_images/rice_image1.png"/>
                       </figure>
                    </figure>
                    <p>
                       <xref target="note1" id="_"/>
                       <semx element="xref" source="_">
                          <fmt-xref target="note1">
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="N">1</semx>
                             <span class="fmt-autonum-delim">-</span>
                             <semx element="autonum" source="note1">1</semx>
                          </fmt-xref>
                       </semx>
                       <xref target="note2" id="_"/>
                       <semx element="xref" source="_">
                          <fmt-xref target="note2">
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="N">1</semx>
                             <span class="fmt-autonum-delim">-</span>
                             <semx element="autonum" source="note2">2</semx>
                          </fmt-xref>
                       </semx>
                    </p>
                 </clause>
              </clause>
           </sections>
           <annex id="annex1" autonum="1" displayorder="6">
              <fmt-title>
                 <span class="fmt-caption-label">
                    <strong>
                       <span class="fmt-element-name">Appendix</span>
                       <semx element="autonum" source="annex1">1</semx>
                    </strong>
                 </span>
              </fmt-title>
              <fmt-xref-label>
                 <span class="fmt-element-name">Appendix</span>
                 <semx element="autonum" source="annex1">1</semx>
              </fmt-xref-label>
              <clause id="annex1a">
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="annex1">A1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex1a">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="annex1">A1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="annex1a">1</semx>
                 </fmt-xref-label>
              </clause>
              <clause id="annex1b">
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="annex1">A1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex1b">2</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Appendix</span>
                    <semx element="autonum" source="annex1">A1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="annex1b">2</semx>
                 </fmt-xref-label>
                 <figure id="AN" autonum="A1.1">
                    <figure id="Anote1" autonum="A1.1-1">
                       <name id="_">Split-it-right sample divider</name>
                       <fmt-name>
                          <span class="fmt-caption-label">
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="annex1">A1</semx>
                             <span class="fmt-autonum-delim">.</span>
                             <semx element="autonum" source="Anote1">1</semx>
                             <span class="fmt-autonum-delim">-</span>
                             <semx element="autonum" source="Anote1">1</semx>
                          </span>
                          <span class="fmt-caption-delim"> — </span>
                          <semx element="name" source="_">Split-it-right sample divider</semx>
                       </fmt-name>
                       <fmt-xref-label>
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                          <span class="fmt-autonum-delim">-</span>
                          <semx element="autonum" source="Anote1">1</semx>
                       </fmt-xref-label>
                       <image id="_" mimetype="image/png" src="rice_images/rice_image1.png"/>
                    </figure>
                    <figure id="Anote2" autonum="A1.1-2">
                       <name id="_">Split-it-right sample divider</name>
                       <fmt-name>
                          <span class="fmt-caption-label">
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="annex1">A1</semx>
                             <span class="fmt-autonum-delim">.</span>
                             <semx element="autonum" source="Anote2">1</semx>
                             <span class="fmt-autonum-delim">-</span>
                             <semx element="autonum" source="Anote2">2</semx>
                          </span>
                          <span class="fmt-caption-delim"> — </span>
                          <semx element="name" source="_">Split-it-right sample divider</semx>
                       </fmt-name>
                       <fmt-xref-label>
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                          <span class="fmt-autonum-delim">-</span>
                          <semx element="autonum" source="Anote2">2</semx>
                       </fmt-xref-label>
                       <image id="_" mimetype="image/png" src="rice_images/rice_image1.png"/>
                    </figure>
                 </figure>
              </clause>
           </annex>
        </iso-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to Xml::C14n.format(output)

    output = <<~OUTPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <bibdata>
              <ext>
                 <editorialgroup>
                    <committee acronym="JCGM" language="en" script="Latn">TC</committee>
                    <committee acronym="JCGM" language="fr" script="Latn">CT</committee>
                    <workgroup acronym="B">WC</workgroup>
                 </editorialgroup>
              </ext>
           </bibdata>
           <preface>
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
              <foreword id="fwd" displayorder="2">
                 <title id="_">Foreword</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Foreword</semx>
                 </fmt-title>
                 <p>
                    <xref target="N" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="N">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="N">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="note1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="note1">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="N">1</semx>
                          <semx element="autonum" source="note1">a</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                    <xref target="note2" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="note2">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="N">1</semx>
                          <semx element="autonum" source="note2">b</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                    <xref target="AN" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="AN">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                       </fmt-xref>
                    </semx>
                    <xref target="Anote1" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="Anote1">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                          <semx element="autonum" source="Anote1">a</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                    <xref target="Anote2" id="_"/>
                    <semx element="xref" source="_">
                       <fmt-xref target="Anote2">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                          <semx element="autonum" source="Anote2">b</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref>
                    </semx>
                 </p>
              </foreword>
           </preface>
           <sections>
              <clause id="scope" type="scope" displayorder="3">
                 <title id="_">Scope</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="scope">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Scope</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="scope">1</semx>
                 </fmt-xref-label>
              </clause>
              <terms id="terms" displayorder="4">
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="terms">2</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="terms">2</semx>
                 </fmt-xref-label>
              </terms>
              <clause id="widgets" displayorder="5">
                 <title id="_">Widgets</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="widgets">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Widgets</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="widgets">3</semx>
                 </fmt-xref-label>
                 <clause id="widgets1">
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="widgets">3</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="widgets1">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                    </fmt-title>
                    <fmt-xref-label>
                       <semx element="autonum" source="widgets">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="widgets1">1</semx>
                    </fmt-xref-label>
                    <figure id="N" autonum="1">
                       <fmt-name>
                          <span class="fmt-caption-label">
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="N">1</semx>
                          </span>
                       </fmt-name>
                       <fmt-xref-label>
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="N">1</semx>
                       </fmt-xref-label>
                       <figure id="note1" autonum="1 a">
                          <name id="_">Split-it-right sample divider</name>
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <semx element="autonum" source="note1">a</semx>
                                <span class="fmt-label-delim">)</span>
                             </span>
                             <span class="fmt-caption-delim">  </span>
                             <semx element="name" source="_">Split-it-right sample divider</semx>
                          </fmt-name>
                          <fmt-xref-label>
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="N">1</semx>
                             <semx element="autonum" source="note1">a</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <image id="_" mimetype="image/png" src="rice_images/rice_image1.png"/>
                       </figure>
                       <figure id="note2" autonum="1 b">
                          <name id="_">Split-it-right sample divider</name>
                          <fmt-name>
                             <span class="fmt-caption-label">
                                <semx element="autonum" source="note2">b</semx>
                                <span class="fmt-label-delim">)</span>
                             </span>
                             <span class="fmt-caption-delim">  </span>
                             <semx element="name" source="_">Split-it-right sample divider</semx>
                          </fmt-name>
                          <fmt-xref-label>
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="N">1</semx>
                             <semx element="autonum" source="note2">b</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref-label>
                          <image id="_" mimetype="image/png" src="rice_images/rice_image1.png"/>
                       </figure>
                    </figure>
                    <p>
                       <xref target="note1" id="_"/>
                       <semx element="xref" source="_">
                          <fmt-xref target="note1">
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="N">1</semx>
                             <semx element="autonum" source="note1">a</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref>
                       </semx>
                       <xref target="note2" id="_"/>
                       <semx element="xref" source="_">
                          <fmt-xref target="note2">
                             <span class="fmt-element-name">Figure</span>
                             <semx element="autonum" source="N">1</semx>
                             <semx element="autonum" source="note2">b</semx>
                             <span class="fmt-autonum-delim">)</span>
                          </fmt-xref>
                       </semx>
                    </p>
                 </clause>
              </clause>
           </sections>
           <annex id="annex1" autonum="A" displayorder="6">
              <fmt-title>
                 <span class="fmt-caption-label">
                    <strong>
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="annex1">A</semx>
                    </strong>
                 </span>
              </fmt-title>
              <fmt-xref-label>
                 <span class="fmt-element-name">Annex</span>
                 <semx element="autonum" source="annex1">A</semx>
              </fmt-xref-label>
              <clause id="annex1a">
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="annex1">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex1a">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                 </fmt-title>
                 <fmt-xref-label>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="annex1a">1</semx>
                 </fmt-xref-label>
              </clause>
              <clause id="annex1b">
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="annex1">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="annex1b">2</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                 </fmt-title>
                 <fmt-xref-label>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="annex1b">2</semx>
                 </fmt-xref-label>
                 <figure id="AN" autonum="A.1">
                    <fmt-name>
                       <span class="fmt-caption-label">
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                       </span>
                    </fmt-name>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Figure</span>
                       <semx element="autonum" source="annex1">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="AN">1</semx>
                    </fmt-xref-label>
                    <figure id="Anote1" autonum="A.1 a">
                       <name id="_">Split-it-right sample divider</name>
                       <fmt-name>
                          <span class="fmt-caption-label">
                             <semx element="autonum" source="Anote1">a</semx>
                             <span class="fmt-label-delim">)</span>
                          </span>
                          <span class="fmt-caption-delim">  </span>
                          <semx element="name" source="_">Split-it-right sample divider</semx>
                       </fmt-name>
                       <fmt-xref-label>
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                          <semx element="autonum" source="Anote1">a</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref-label>
                       <image id="_" mimetype="image/png" src="rice_images/rice_image1.png"/>
                    </figure>
                    <figure id="Anote2" autonum="A.1 b">
                       <name id="_">Split-it-right sample divider</name>
                       <fmt-name>
                          <span class="fmt-caption-label">
                             <semx element="autonum" source="Anote2">b</semx>
                             <span class="fmt-label-delim">)</span>
                          </span>
                          <span class="fmt-caption-delim">  </span>
                          <semx element="name" source="_">Split-it-right sample divider</semx>
                       </fmt-name>
                       <fmt-xref-label>
                          <span class="fmt-element-name">Figure</span>
                          <semx element="autonum" source="annex1">A</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="AN">1</semx>
                          <semx element="autonum" source="Anote2">b</semx>
                          <span class="fmt-autonum-delim">)</span>
                       </fmt-xref-label>
                       <image id="_" mimetype="image/png" src="rice_images/rice_image1.png"/>
                    </figure>
                 </figure>
              </clause>
           </annex>
        </iso-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input.sub("</bibdata>",
                                 "#{jcgm_ext}</bibdata>"), true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
