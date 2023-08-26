require "spec_helper"

RSpec.describe IsoDoc::BIPM do
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
      <?xml version='1.0'?>
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
        <preface>
           <clause type="toc" id="_" displayorder="1">
        <title depth="1">Contents</title>
      </clause>
          <foreword displayorder="2">
            <p>
              <xref target='N1'>Equation (1)</xref>
      <xref target='N2'>Equation ((??))</xref>
      <xref target='N'>Equation (2)</xref>
      <xref target='note1'>Equation (3)</xref>
      <xref target='note2'>Equation (4)</xref>
      <xref target='AN'>Equation (1.1)</xref>
      <xref target='Anote1'>Equation ((??))</xref>
      <xref target='Anote2'>Equation (1.2)</xref>
            </p>
          </foreword>
          <introduction id='intro' displayorder='3'>
            <formula id='N1'>
              <name>1</name>
              <stem type='AsciiMath'>r = 1 %</stem>
            </formula>
            <clause id='xyz'>
              <title depth='2'>Preparatory</title>
              <formula id='N2' unnumbered='true'>
                <stem type='AsciiMath'>r = 1 %</stem>
              </formula>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id='scope' type="scope" displayorder='4'>
          <title depth='1'>
        1.
        <tab/>
        Scope
      </title>
            <formula id='N'>
              <name>2</name>
              <stem type='AsciiMath'>r = 1 %</stem>
            </formula>
            <p>
            <xref target='N'>Equation (2)</xref>
            </p>
          </clause>
          <terms id='terms' displayorder='5'>
        <title>2.</title>
      </terms>
          <clause id='widgets' displayorder='6'>
            <title depth='1'>
        3.
        <tab/>
        Widgets
      </title>
            <clause id='widgets1'><title>3.1.</title>
              <formula id='note1'>
                <name>3</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </formula>
              <formula id='note2'>
                <name>4</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </formula>
              <p>
                <xref target='note1'>Equation (3)</xref>
      <xref target='note2'>Equation (4)</xref>
              </p>
            </clause>
          </clause>
        </sections>
        <annex id='annex1' displayorder='7'>
        <title>
        <strong>Appendix 1</strong>
      </title>
          <clause id='annex1a'><title>A1.1.</title>
            <formula id='AN'>
              <name>1.1</name>
              <stem type='AsciiMath'>r = 1 %</stem>
            </formula>
          </clause>
          <clause id='annex1b'><title>A1.2.</title>
            <formula id='Anote1' unnumbered='true'>
              <stem type='AsciiMath'>r = 1 %</stem>
            </formula>
            <formula id='Anote2'>
              <name>1.2</name>
              <stem type='AsciiMath'>r = 1 %</stem>
            </formula>
          </clause>
        </annex>
      </iso-standard>
    OUTPUT
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to xmlpp(output)
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
            <foreword obligation="informative" displayorder="2">
        <title>Foreword</title>
        <p id="A">This is a preamble
          <xref target="C">Introduction Subsection</xref>
          <xref target="C1">Introduction, 2</xref>
          <xref target="D">Chapter 1</xref>
          <xref target="H">Chapter 2</xref>
          <xref target="I">Section 2.1</xref>
          <xref target="J">Section 2.1.1</xref>
          <xref target="K">Section 2.2</xref>
          <xref target="L">Chapter 3</xref>
          <xref target="M">Chapter 4</xref>
          <xref target="N">Section 4.1</xref>
          <xref target="O">Section 4.2</xref>
          <xref target="P">Appendix 1</xref>
          <xref target="Q">Appendix A1.1</xref>
          <xref target="Q1">Appendix A1.1.1</xref>
          <xref target="Q2">[Q2]</xref>
          <xref target="Q3">[Q3]</xref>
          <xref target="R">Chapter 5</xref></p>
      </foreword>
    OUTPUT
    expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
.sub(%r{^.*<foreword}m, "<foreword")
.sub(%r{</foreword>.*$}m, "</foreword>"))).to be_equivalent_to xmlpp(output)
  end

  it "cross-references sections in JCGM" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata>
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
      <foreword obligation='informative' displayorder="2">
        <title>Foreword</title>
        <p id='A'>
          This is a preamble
          <xref target='C'>0.1</xref>
          <xref target='C1'>0.2</xref>
          <xref target='D'>Clause 1</xref>
          <xref target='H'>Clause 3</xref>
          <xref target='I'>3.1</xref>
          <xref target='J'>3.1.1</xref>
          <xref target='K'>3.2</xref>
          <xref target='L'>Clause 4</xref>
          <xref target='M'>Clause 5</xref>
          <xref target='N'>5.1</xref>
          <xref target='O'>5.2</xref>
          <xref target='P'>Annex A</xref>
          <xref target='Q'>A.1</xref>
          <xref target='Q1'>A.1.1</xref>
          <xref target='Q2'>[Q2]</xref>
          <xref target='Q3'>[Q3]</xref>
          <xref target='R'>Clause 2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{^.*<foreword}m, "<foreword")
      .sub(%r{</foreword>.*$}m, "</foreword>")))
      .to be_equivalent_to xmlpp(output)
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
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <bibdata> </bibdata>
         <preface>
             <clause type="toc" id="_" displayorder="1">
            <title depth="1">Contents</title>
          </clause>
           <foreword id='fwd' displayorder="2">
             <p>
               <xref target='N'>Figure 1</xref>
               <xref target='note1'>Figure 1-1</xref>
               <xref target='note2'>Figure 1-2</xref>
               <xref target='AN'>Figure 1.1</xref>
               <xref target='Anote1'>Figure 1.1-1</xref>
               <xref target='Anote2'>Figure 1.1-2</xref>
             </p>
           </foreword>
         </preface>
         <sections>
           <clause id='scope' type='scope' displayorder='3'>
             <title depth='1'>
               1.
               <tab/>
               Scope
             </title>
           </clause>
           <terms id='terms' displayorder='4'>
             <title>2.</title>
           </terms>
           <clause id='widgets' displayorder='5'>
             <title depth='1'>
               3.
               <tab/>
               Widgets
             </title>
             <clause id='widgets1'>
               <title>3.1.</title>
               <figure id='N'>
                 <figure id='note1'>
                   <name>Figure 1-1&#xA0;&#x2014; Split-it-right sample divider</name>
                   <image id='_' mimetype='image/png' src='rice_images/rice_image1.png'/>
                 </figure>
                 <figure id='note2'>
                   <name>Figure 1-2&#xA0;&#x2014; Split-it-right sample divider</name>
                   <image id='_' mimetype='image/png' src='rice_images/rice_image1.png'/>
                 </figure>
               </figure>
               <p>
                 <xref target='note1'>Figure 1-1</xref>
                 <xref target='note2'>Figure 1-2</xref>
               </p>
             </clause>
           </clause>
         </sections>
         <annex id='annex1' displayorder='6'>
           <title>
             <strong>Appendix 1</strong>
           </title>
           <clause id='annex1a'>
             <title>A1.1.</title>
           </clause>
           <clause id='annex1b'>
             <title>A1.2.</title>
             <figure id='AN'>
               <figure id='Anote1'>
                 <name>Figure 1.1-1&#xA0;&#x2014; Split-it-right sample divider</name>
                 <image id='_' mimetype='image/png' src='rice_images/rice_image1.png'/>
               </figure>
               <figure id='Anote2'>
                 <name>Figure 1.1-2&#xA0;&#x2014; Split-it-right sample divider</name>
                 <image id='_' mimetype='image/png' src='rice_images/rice_image1.png'/>
               </figure>
             </figure>
           </clause>
         </annex>
       </iso-standard>
    OUTPUT
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references subfigures in JCGM" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata>
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
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <bibdata>
           <ext>
             <editorialgroup>
               <committee acronym="JCGM">
                 <variant language="en" script="Latn">TC</variant>
                 <variant language="fr" script="Latn">CT</variant>
               </committee>
               <workgroup acronym='B'>WC</workgroup>
             </editorialgroup>
           </ext>
         </bibdata>
         <preface>
             <clause type="toc" id="_" displayorder="1">
            <title depth="1">Contents</title>
          </clause>
           <foreword id='fwd' displayorder="2">
             <p>
               <xref target='N'>Figure 1</xref>
               <xref target='note1'>Figure 1 a)</xref>
               <xref target='note2'>Figure 1 b)</xref>
               <xref target='AN'>Figure A.1</xref>
               <xref target='Anote1'>Figure A.1 a)</xref>
               <xref target='Anote2'>Figure A.1 b)</xref>
             </p>
           </foreword>
         </preface>
         <sections>
           <clause id='scope' type='scope' displayorder="3">
             <title depth='1'>
               1.
               <tab/>
               Scope
             </title>
           </clause>
           <terms id='terms' displayorder="4">
             <title>2.</title>
           </terms>
           <clause id='widgets' displayorder="5">
             <title depth='1'>
               3.
               <tab/>
               Widgets
             </title>
             <clause id='widgets1'>
               <title>3.1.</title>
               <figure id='N'>
                 <name>Figure 1</name>
                 <figure id='note1'>
                   <name>a)&#xA0; Split-it-right sample divider</name>
                   <image id='_' mimetype='image/png' src='rice_images/rice_image1.png'/>
                 </figure>
                 <figure id='note2'>
                   <name>b)&#xA0; Split-it-right sample divider</name>
                   <image id='_' mimetype='image/png' src='rice_images/rice_image1.png'/>
                 </figure>
               </figure>
               <p>
                 <xref target='note1'>Figure 1 a)</xref>
                 <xref target='note2'>Figure 1 b)</xref>
               </p>
             </clause>
           </clause>
         </sections>
         <annex id='annex1' displayorder="6">
           <title>
             <strong>Annex A</strong>
           </title>
           <clause id='annex1a'>
             <title>A.1.</title>
           </clause>
           <clause id='annex1b'>
             <title>A.2.</title>
             <figure id='AN'>
               <name>Figure A.1</name>
               <figure id='Anote1'>
                 <name>a)&#xA0; Split-it-right sample divider</name>
                 <image id='_' mimetype='image/png' src='rice_images/rice_image1.png'/>
               </figure>
               <figure id='Anote2'>
                 <name>b)&#xA0; Split-it-right sample divider</name>
                 <image id='_' mimetype='image/png' src='rice_images/rice_image1.png'/>
               </figure>
             </figure>
           </clause>
         </annex>
       </iso-standard>
    OUTPUT
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(output)
  end
end
