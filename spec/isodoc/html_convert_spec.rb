require "spec_helper"

logoloc = File.join(File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "metanorma")), "..", "..", "lib", "isodoc", "bipm", "html")
logoloc1 = File.join(File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "isodoc", "bipm", "html")))

si_aspect = ["A_e_deltanu", "A_e", "cd_Kcd_h_deltanu", "cd_Kcd", "full", "K_k_deltanu", "K_k", "kg_h_c_deltanu", "kg_h", "m_c_deltanu", "m_c", "mol_NA", "s_deltanu"]
si_aspect_paths = si_aspect.map { |x| File.join(logoloc1, "si-aspect", "#{x}.png") }

RSpec.describe IsoDoc::BIPM do

  it "processes default metadata in English" do
    csdc = IsoDoc::BIPM::HtmlConvert.new({})
    input = <<~"INPUT"
<bipm-standard xmlns="https://open.ribose.com/standards/bipm">
<bibdata type="standard">
  <title type="main" language="en" format="plain">Main Title</title>
  <title type="main" language="fr" format="plain">Chef Title</title>
  <title type="cover" language="en" format="plain">Main Title Cover</title>
  <title type="cover" language="fr" format="plain">Chef Title Cover</title>
  <title type="appendix" language="en" format="plain">Main Title Appendix</title>
  <title type="appendix" language="fr" format="plain">Chef Title Appendix</title>
  <title type="part" language="en" format="plain">Main Title Part</title>
  <title type="part" language="fr" format="plain">Chef Title Part</title>
  <title type="subpart" language="en" format="plain">Main Title Subpart</title>
  <title type="subpart" language="fr" format="plain">Chef Title Subpart</title>
  <docidentifier>1000</docidentifier>
  <contributor>
<role type="author"/>
<person>
<name>
<completename>Gustavo Martos</completename>
</name>
<affiliation>
<organization>
<name>BIPM</name>
</organization>
</affiliation>
</person>
</contributor>
<contributor>
<role type="author"/>
<person>
<name>
<completename>Xiuqin Li</completename>
</name>
<affiliation>
<organization>
<name>NIM</name>
</organization>
</affiliation>
</person>
</contributor>
<contributor>
<role type="author"/>
<person>
<name>
<completename>Ralf Josephs</completename>
</name>
<affiliation>
<organization>
<name>BIPM</name>
</organization>
</affiliation>
</person>
</contributor>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long["en"]}</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long["en"]}</name>
    </organization>
  </contributor>
  <version>
  <edition>2</edition>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
  <language>en</language>
  <script>Latn</script>
  <status>
<stage language="">mise-en-pratique</stage>
<stage language="en">en-vigeur</stage>
</status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>#{Metanorma::BIPM.configuration.organization_name_long["en"]}</name>
      </organization>
    </owner>
  </copyright>
  <ext>
  <editorialgroup>
  <committee acronym='TCA'>
  <variant language='en' script='Latn'>TC</variant>
  <variant language='fr' script='Latn'>CT</variant>
</committee>
    <workgroup acronym="B">WC</committee>
  </editorialgroup>
  <comment-period><from>N1</from><to>N2</to></comment-period>
  <si-aspect>A_e_deltanu</si-aspect>
  <meeting-note>ABC</meeting-note>
  <structuredidentifier>
  <docnumber>1000</docnumber>
  <part>2.1</part>
  <appendix>ABC</appendix>
</structuredidentifier>
</ext>
</bibdata>
<sections/>
</bipm-standard>
    INPUT

    output = <<~"OUTPUT"
{:accesseddate=>"XXX",
:agency=>"#{Metanorma::BIPM.configuration.organization_name_long["en"]}",
:appendixid=>"Appendix ABC",
:appendixid_alt=>"Annexe ABC",
:appendixsubtitle=>"Chef Title Appendix",
:appendixtitle=>"Main Title Appendix",
:authors=>["Gustavo Martos", "Xiuqin Li", "Ralf Josephs"],
:authors_affiliations=>["BIPM", "NIM", "BIPM"],
:circulateddate=>"XXX",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"XXX",
:docnumber=>"1000",
:docsubtitle=>"Chef Title",
:doctitle=>"Main Title",
:docyear=>"2001",
:draft=>"3.4",
:draftinfo=>" (draft 3.4, 2000-01-01)",
:implementeddate=>"XXX",
:issueddate=>"XXX",
:lang=>"en",
:logo=>"#{File.join(logoloc, "logo.png")}",
:metadata_extensions=>{"editorialgroup"=>{"committee_acronym"=>"TCA", "committee"=>{"variant_language"=>["en", "fr"], "variant_script"=>["Latn", "Latn"], "variant"=>["TC", "CT"]}, "workgroup_acronym"=>"B", "workgroup"=>"WC"}, "comment-period"=>{"from"=>"N1", "to"=>"N2"}, "si-aspect"=>"A_e_deltanu", "meeting-note"=>"ABC", "structuredidentifier"=>{"docnumber"=>"1000", "part"=>"2.1", "appendix"=>"ABC"}},
:obsoleteddate=>"XXX",
:partid=>"Part 2.1",
:partid_alt=>"Partie 2.1",
:partsubtitle=>"Chef Title Part",
:parttitle=>"Main Title Part",
:publisheddate=>"XXX",
:publisher=>"#{Metanorma::BIPM.configuration.organization_name_long["en"]}",
:receiveddate=>"XXX",
:revdate=>"2000-01-01",
:revdate_monthyear=>"January 2000",
:script=>"Latn",
:si_aspect_index=>#{si_aspect},
:si_aspect_paths=>#{si_aspect_paths},
:stage=>"Mise en Pratique",
:stage_display=>"En Vigeur",
:tc=>"\\n  TC\\n  CT\\n",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>true,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil))).to_s.gsub(/, :/, ",\n:")).to be_equivalent_to output
  end

  it "processes default metadata in French" do
    csdc = IsoDoc::BIPM::HtmlConvert.new({})
    input = <<~"INPUT"
<bipm-standard xmlns="https://open.ribose.com/standards/bipm">
<bibdata type="standard">
  <title type="main" language="en" format="plain">Main Title</title>
  <title type="main" language="fr" format="plain">Chef Title</title>
  <title type="cover" language="en" format="plain">Main Title Cover</title>
  <title type="cover" language="fr" format="plain">Chef Title Cover</title>
  <title type="appendix" language="en" format="plain">Main Title Appendix</title>
  <title type="appendix" language="fr" format="plain">Chef Title Appendix</title>
  <docidentifier>1000</docidentifier>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long["fr"]}</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long["fr"]}</name>
    </organization>
  </contributor>
  <version>
  <edition>2</edition>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
  <language>fr</language>
  <script>Latn</script>
  <status><stage>working-draft</stage></status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>#{Metanorma::BIPM.configuration.organization_name_long["fr"]}</name>
      </organization>
    </owner>
  </copyright>
  <editorialgroup>
  <committee acronym='TCA'>
  <variant language='en' script='Latn'>TC</variant>
  <variant language='fr' script='Latn'>CT</variant>
</committee>
  </editorialgroup>
  <security>Client Confidential</security>
  <ext><doctype>cipm-mra</doctype>
  <comment-period><from>N1</from><to>N2</to></comment-period>
  <structuredidentifier>
  <docnumber>1000</docnumber>
  <part>2.1</part>
  <appendix>ABC</appendix>
</structuredidentifier>
</ext>
</bibdata>
<sections/>
</bipm-standard>
    INPUT

    output = <<~"OUTPUT"
{:accesseddate=>"XXX",
:agency=>"#{Metanorma::BIPM.configuration.organization_name_long["fr"]}",
:appendixid=>"Annexe ABC",
:appendixid_alt=>"Appendix ABC",
:appendixsubtitle=>"Main Title Appendix",
:appendixtitle=>"Chef Title Appendix",
:circulateddate=>"XXX",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"XXX",
:docnumber=>"1000",
:docsubtitle=>"Main Title",
:doctitle=>"Chef Title",
:doctype=>"CIPM-MRA",
:doctype_display=>"CIPM-MRA",
:docyear=>"2001",
:draft=>"3.4",
:draftinfo=>" (brouillon 3.4, 2000-01-01)",
:implementeddate=>"XXX",
:issueddate=>"XXX",
:lang=>"fr",
:logo=>"#{File.join(logoloc, "logo.png")}",
:metadata_extensions=>{"doctype"=>"cipm-mra", "comment-period"=>{"from"=>"N1", "to"=>"N2"}, "structuredidentifier"=>{"docnumber"=>"1000", "part"=>"2.1", "appendix"=>"ABC"}},
:obsoleteddate=>"XXX",
:partid=>"Partie 2.1",
:partid_alt=>"Part 2.1",
:publisheddate=>"XXX",
:publisher=>"#{Metanorma::BIPM.configuration.organization_name_long["fr"]}",
:receiveddate=>"XXX",
:revdate=>"2000-01-01",
:revdate_monthyear=>"Janvier 2000",
:script=>"Latn",
:si_aspect_index=>#{si_aspect},
:si_aspect_paths=>#{si_aspect_paths},
:stage=>"Working Draft",
:stage_display=>"Working Draft",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>true,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil))).to_s.gsub(/, :/, ",\n:")).to be_equivalent_to output
  end

  it "ignores unrecognised status" do
    input = <<~"INPUT"
<bipm-standard xmlns="https://open.ribose.com/standards/bipm">
<bibdata type="standard">
  <status><stage>standard</stage></status>
</bibdata><version>
  <edition>2</edition>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
<sections/>
</bipm-standard>
    INPUT

    output = <<~"OUTPUT"
{:accesseddate=>"XXX",
:circulateddate=>"XXX",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"XXX",
:draft=>"3.4",
:draftinfo=>" (draft 3.4, 2000-01-01)",
:implementeddate=>"XXX",
:issueddate=>"XXX",
:lang=>"en",
:logo=>"#{File.join(logoloc, "logo.png")}",
:obsoleteddate=>"XXX",
:publisheddate=>"XXX",
:receiveddate=>"XXX",
:revdate=>"2000-01-01",
:revdate_monthyear=>"January 2000",
:script=>"Latn",
:si_aspect_index=>#{si_aspect},
:si_aspect_paths=>#{si_aspect_paths},
:stage=>"Standard",
:stage_display=>"Standard",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>true,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX"}
    OUTPUT

    csdc = IsoDoc::BIPM::HtmlConvert.new({})
    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil))).to_s.gsub(/, :/, ",\n:")).to be_equivalent_to output
  end

  it "processes pre" do
    input = <<~"INPUT"
<bipm-standard xmlns="https://open.ribose.com/standards/bipm">
<preface><foreword>
<pre>ABC</pre>
</foreword></preface>
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

    expect(strip_guid(xmlpp(
      IsoDoc::BIPM::HtmlConvert.new({}).
      convert("test", input, true).
      gsub(%r{^.*<body}m, "<body").
      gsub(%r{</body>.*}m, "</body>")
    ))).to be_equivalent_to output
  end

  it "processes table" do
    input = <<~"INPUT"
<bipm-standard xmlns="https://open.ribose.com/standards/bipm">
<sections>
<clause id="A">
<table id="B"><name>First Table</name></table>
</clause>
</sections>
</bipm-standard>
    INPUT

    presxml = <<~"INPUT"
<bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
<sections>
<clause id="A">
<title>1.</title>
<table id="B"><name>Table 1.<tab/>First Table</name></table>
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
</div>
           </div>
         </body>
    OUTPUT
    stripped_presxml = xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert
                          .new({})
                          .convert('test', input, true)))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
                          .convert('test', presxml, true)
                          .gsub(%r{^.*<body}m, '<body')
                          .gsub(%r{</body>.*}m, '</body>')))
    expect(stripped_presxml).to(be_equivalent_to(xmlpp(presxml)))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "processes simple terms & definitions" do
    input = <<~"INPUT"
     <bipm-standard xmlns="http://riboseinc.com/isoxml">
       <sections>
       <terms id="H" obligation="normative"><title>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
         <term id="J">
         <name>1.1.</name>
         <preferred>Term2</preferred>
       </term>
        </terms>
        </sections>
        </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
        #{HTML_HDR}
             <p class="zzSTDTitle1"/>
             <div id="H"><h1>1.&#160; Terms, Definitions, Symbols and Abbreviated Terms</h1>
       <p class="TermNum" id="J">1.1.</p>
         <p class="Terms" style="text-align:left;">Term2</p>
       </div>
           </div>
         </body>
    OUTPUT
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
                          .convert('test', input, true)
                          .gsub(%r{^.*<body}m, '<body')
                          .gsub(%r{</body>.*}m, '</body>')))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "processes section names" do
    input = <<~"INPUT"
    <bipm-standard xmlns="http://riboseinc.com/isoxml">
      <preface>
      <foreword obligation="informative">
         <title>Foreword</title>
         <p id="A">This is a preamble</p>
       </foreword>
        <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
         <title>Introduction Subsection</title>
       </clause>
       </introduction></preface><sections>
       <clause id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
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
       <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="O" inline-header="false" obligation="normative">
         <title>Clause 4.2</title>
       </clause></clause>

       </sections><annex id="P" inline-header="false" obligation="normative">
         <title>Annex</title>
         <clause id="Q" inline-header="false" obligation="normative">
         <title>Annex A.1</title>
         <clause id="Q1" inline-header="false" obligation="normative">
         <title>Annex A.1a</title>
         </clause>
       </clause>
       </annex><bibliography><references id="R" obligation="informative" normative="true">
         <title>Normative References</title>
       </references><clause id="S" obligation="informative">
         <title>Bibliography</title>
         <references id="T" obligation="informative" normative="false">
         <title>Bibliography Subsection</title>
       </references>
       </clause>
       </bibliography>
       </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
    <bipm-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <preface>
           <foreword obligation='informative'>
             <title>Foreword</title>
             <p id='A'>This is a preamble</p>
           </foreword>
           <introduction id='B' obligation='informative'>
             <title>Introduction</title>
             <clause id='C' inline-header='false' obligation='informative'>
               <title depth='2'>Introduction Subsection</title>
             </clause>
           </introduction>
         </preface>
         <sections>
           <clause id='H' obligation='normative'>
             <title depth='1'>
               1.
               <tab/>
               Terms, Definitions, Symbols and Abbreviated Terms
             </title>
             <terms id='I' obligation='normative'>
               <title depth='2'>
                 1.1.
                 <tab/>
                 Normal Terms
               </title>
               <term id='J'>
                 <name>1.1.1.</name>
                 <preferred>Term2</preferred>
               </term>
             </terms>
             <clause id='D' obligation='normative'>
               <title depth='2'>
                 1.2.
                 <tab/>
                 Scope
               </title>
               <p id='E'>Text</p>
             </clause>
             <definitions id='K'>
               <title>1.3.</title>
               <dl>
                 <dt>Symbol</dt>
                 <dd>Definition</dd>
               </dl>
             </definitions>
           </clause>
           <definitions id='L'>
             <title>2.</title>
             <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
             </dl>
           </definitions>
           <clause id='M' inline-header='false' obligation='normative'>
             <title depth='1'>
               3.
               <tab/>
               Clause 4
             </title>
             <clause id='N' inline-header='false' obligation='normative'>
               <title depth='2'>
                 3.1.
                 <tab/>
                 Introduction
               </title>
             </clause>
             <clause id='O' inline-header='false' obligation='normative'>
               <title depth='2'>
                 3.2.
                 <tab/>
                 Clause 4.2
               </title>
             </clause>
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
         <bibliography>
           <references id='R' obligation='informative' normative='true'>
             <title depth='1'>
               1.
               <tab/>
               Normative References
             </title>
           </references>
           <clause id='S' obligation='informative'>
             <title depth='1'>Bibliography</title>
             <references id='T' obligation='informative' normative='false'>
               <title depth='2'>Bibliography Subsection</title>
             </references>
           </clause>
         </bibliography>
       </bipm-standard>
    OUTPUT
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert
                          .new({})
                          .convert('test', input, true)))
    expect(stripped_html).to(be_equivalent_to(output))
  end


  it "processes appendix names in appendix document" do
    input = <<~"INPUT"
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

    output = <<~"OUTPUT"
    <bipm-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
  <bibdata>
    <ext>
      <structuredidentifier>
        <appendix>1</appendix>
      </structuredidentifier>
    </ext>
  </bibdata>
  <sections>
    <clause obligation='informative' id='A0'>
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
  <annex id='P' inline-header='false' obligation='normative'>
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
        1.1.
        <tab/>
         1.1.
        <tab/>
         Annex A.1
      </title>
      <clause id='Q1' inline-header='false' obligation='normative'>
        <title depth='3'>
          1.1.1.
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

    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert
                          .new({})
                          .convert('test', input, true)
                          .gsub(%r{<localized-strings>.*</localized-strings>}m, "")
                                    ))
    expect(stripped_html).to(be_equivalent_to(output))
  end


  it "injects JS into blank html" do
    system "rm -f test.html"
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

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Times New Roman})
  end

    it "processes unnumbered sections" do
      expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({}).convert('test', <<~"INPUT", true)))).to be_equivalent_to <<~"OUTPUT"
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
   <sections>
      <clause id='B' unnumbered='true' obligation='normative'>
     <title>Beta</title>
     <clause id="C">
     <title>Charlie</title>
     </clause>
   </clause>
    <clause id='D' obligation='normative'>
     <title>Delta</title>
     <clause id="E" unnumbered='true'>
     <title>Echo</title>
     </clause>
     <clause id="F">
     <title>Fox</title>
     </clause>
   </clause>
 </sections>
 <annex id='A1' obligation='normative' unnumbered="true">
   <title>Alpha</title>
     <clause id="B1">
     <title>Beta</title>
     </clause>
 </annex>
 <annex id='A2' obligation='normative'>
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
<bipm-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
  <preface>
    <foreword obligation='informative'>
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
        <xref target='C2'>Appendix 1.1</xref>
      </p>
    </foreword>
    <sections>
      <clause id='B' unnumbered='true' obligation='normative'>
        <title>Beta</title>
        <clause id='C'>
          <title>Charlie</title>
        </clause>
      </clause>
      <clause id='D' obligation='normative'>
        <title depth='1'>
          1.
          <tab/>
          Delta
        </title>
        <clause id='E' unnumbered='true'>
          <title>Echo</title>
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
    <annex id='A1' obligation='normative' unnumbered='true'>
      <title>Alpha</title>
      <clause id='B1'>
        <title>Beta</title>
      </clause>
    </annex>
    <annex id='A2' obligation='normative'>
      <title>
        <strong>Appendix 1</strong>
        .
        <tab/>
        <strong>Gamma</strong>
      </title>
      <clause id='B2' unnumbered='true'>
        <title>Delta</title>
      </clause>
      <clause id='C2'>
        <title depth='2'>
          1.1.
          <tab/>
          Epsilon
        </title>
      </clause>
    </annex>
  </preface>
</bipm-standard>
      OUTPUT
    end

  it "processes ordered lists" do
    input = <<~"INPUT"
     <bipm-standard xmlns="http://riboseinc.com/isoxml">
       <sections>
       <clause id="A">
       <title>Clause</title>
       <ol type="arabic" start="4">
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
                          .convert('test', input, true)
                          .gsub(%r{^.*<body}m, '<body')
                          .gsub(%r{</body>.*}m, '</body>')))
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
      <name>#{Metanorma::BIPM.configuration.organization_name_long["en"]}</name>
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
      <name>#{Metanorma::BIPM.configuration.organization_name_long["en"]}</name>
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
         <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" version="#{Metanorma::BIPM::VERSION}"  type="presentation">
       <bibdata type="standard">
       <title language="en" format="text/plain" type="main">Main Title</title>
       <title language="en" format="text/plain" type="cover">Main Title (SI)</title>
       <title language="en" format="text/plain" type="appendix">Main Title (SI)</title>
         <contributor>
           <role type="author"/>
           <organization>
             <name>#{Metanorma::BIPM.configuration.organization_name_long["en"]}</name>
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
             <name>#{Metanorma::BIPM.configuration.organization_name_long["en"]}</name>
             <abbreviation>BIPM</abbreviation>
           </organization>
         </contributor>
         <edition>2</edition>
       <version>
         <revision-date>2000-01-01</revision-date>
         <draft>3.4</draft>
       </version>
         <language current="true">en</language>
         <script current="true">Latn</script>
         <status>
           <stage language="">working-draft</stage>
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
       <table unnumbered="true"><tbody>
       <tr><td>Authors:</td><td/><td>Andrew Yacoot (NPL), Ulrich Kuetgens (PTB) and Enrico Massa (INRIM)</td></tr>
       <tr><td>2018-06-11</td><td>Draft 1.0 Edition 1.0</td>
       <td>WG-N co-chairs: Ronald Dixson (NIST) and Harald Bosse (PTB)</td></tr>
       <tr><td>2019-06-11</td><td>Draft 2.0 Edition 2.0</td>
       <td>WG-N chair: Andrew Yacoot (NPL)</td></tr>
       <tr><td>2019-06-11</td><td>Draft 3.0 </td><td/></tr>
       </tbody></table>
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
         <td style='border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'>Authors:</td>
         <td style='border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'/>
         <td style='border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'>Andrew Yacoot (NPL), Ulrich Kuetgens (PTB) and Enrico Massa (INRIM)</td>
       </tr>
       <tr>
         <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>2018-06-11</td>
         <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>Draft 1.0 Edition 1.0</td>
         <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>WG-N co-chairs: Ronald Dixson (NIST) and Harald Bosse (PTB)</td>
       </tr>
       <tr>
         <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>2019-06-11</td>
         <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>Draft 2.0 Edition 2.0</td>
         <td style='border-top:none;border-bottom:solid windowtext 1.0pt;'>WG-N chair: Andrew Yacoot (NPL)</td>
       </tr>
       <tr>
         <td style='border-top:none;border-bottom:solid windowtext 1.5pt;'>2019-06-11</td>
         <td style='border-top:none;border-bottom:solid windowtext 1.5pt;'>Draft 3.0 </td>
         <td style='border-top:none;border-bottom:solid windowtext 1.5pt;'/>
       </tr>
     </tbody>
   </table>
</div>
          </div>
        </body>
    OUTPUT

    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
                          .convert('test', input, true)
                          .gsub(%r{<localized-strings>.*</localized-strings>}m, "")
                                    ))
    expect(stripped_html).to(be_equivalent_to(presxml))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
                          .convert('test', presxml, true)
                          .gsub(%r{^.*<body}m, '<body')
                          .gsub(%r{</body>.*}m, '</body>')))
    expect(stripped_html).to(be_equivalent_to(output))


end


  it "localises numbers in MathML, English" do
   expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({}).convert("test", <<~INPUT, true)).sub(%r{<localized-strings>.*</localized-strings>}m, "")).to be_equivalent_to xmlpp(<<~OUTPUT)
   <iso-standard xmlns="http://riboseinc.com/isoxml">
   <bibdata>
        <title language="en">test</title>
        <language>en</language>
        </bibdata>
        <preface>
        <p><stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><mn>30000</mn></math></stem>
        <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>P</mi><mfenced open="(" close=")"><mrow><mi>X</mi><mo>≥</mo><msub><mrow><mi>X</mi></mrow><mrow><mo>max</mo></mrow></msub></mrow></mfenced><mo>=</mo><munderover><mrow><mo>∑</mo></mrow><mrow><mrow><mi>j</mi><mo>=</mo><msub><mrow><mi>X</mi></mrow><mrow><mo>max</mo></mrow></msub></mrow></mrow><mrow><mn>1000</mn></mrow></munderover><mfenced open="(" close=")"><mtable><mtr><mtd><mn>0.0001</mn></mtd></mtr><mtr><mtd><mi>j</mi></mtd></mtr></mtable></mfenced><msup><mrow><mi>p</mi></mrow><mrow><mi>j</mi></mrow></msup><msup><mrow><mfenced open="(" close=")"><mrow><mn>1000.00001</mn><mo>−</mo><mi>p</mi></mrow></mfenced></mrow><mrow><mrow><mn>1.003</mn><mo>−</mo><mi>j</mi></mrow></mrow></msup></math></stem></p>
        </preface>
   </iso-standard>
  INPUT
  <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <bibdata>
           <title language='en'>test</title>
           <language current='true'>en</language>
         </bibdata>

         <preface>
           <p>
             <stem type='MathML'><math xmlns='http://www.w3.org/1998/Math/MathML'>
    <mn>30&#x202F;000</mn>
  </math>
</stem>
             <stem type='MathML'>
               <math xmlns='http://www.w3.org/1998/Math/MathML'>
                 <mi>P</mi>
                 <mfenced open='(' close=')'>
                   <mrow>
                     <mi>X</mi>
                     <mo>&#x2265;</mo>
                     <msub>
                       <mrow>
                         <mi>X</mi>
                       </mrow>
                       <mrow>
                         <mo>max</mo>
                       </mrow>
                     </msub>
                   </mrow>
                 </mfenced>
                 <mo>=</mo>
                 <munderover>
                   <mrow>
                     <mo>&#x2211;</mo>
                   </mrow>
                   <mrow>
                     <mrow>
                       <mi>j</mi>
                       <mo>=</mo>
                       <msub>
                         <mrow>
                           <mi>X</mi>
                         </mrow>
                         <mrow>
                           <mo>max</mo>
                         </mrow>
                       </msub>
                     </mrow>
                   </mrow>
                   <mrow>
                     <mn>1&#x202F;000</mn>
                   </mrow>
                 </munderover>
                 <mfenced open='(' close=')'>
                   <mtable>
                     <mtr>
                       <mtd>
                         <mn>0.000&#x202F;1</mn>
                       </mtd>
                     </mtr>
                     <mtr>
                       <mtd>
                         <mi>j</mi>
                       </mtd>
                     </mtr>
                   </mtable>
                 </mfenced>
                 <msup>
                   <mrow>
                     <mi>p</mi>
                   </mrow>
                   <mrow>
                     <mi>j</mi>
                   </mrow>
                 </msup>
                 <msup>
                   <mrow>
                     <mfenced open='(' close=')'>
                       <mrow>
                         <mn>1&#x202F;000.000&#x202F;01</mn>
                         <mo>&#x2212;</mo>
                         <mi>p</mi>
                       </mrow>
                     </mfenced>
                   </mrow>
                   <mrow>
                     <mrow>
                       <mn>1.003</mn>
                       <mo>&#x2212;</mo>
                       <mi>j</mi>
                     </mrow>
                   </mrow>
                 </msup>
               </math>
             </stem>
           </p>
         </preface>
       </iso-standard>
OUTPUT
  end

  it "localises numbers in MathML, French" do
   expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({}).convert("test", <<~INPUT, true)).sub(%r{<localized-strings>.*</localized-strings>}m, "")).to be_equivalent_to xmlpp(<<~OUTPUT)
   <iso-standard xmlns="http://riboseinc.com/isoxml">
   <bibdata>
        <title language="en">test</title>
        <language>fr</language>
        </bibdata>
        <preface>
        <p><stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><mn>30000</mn></math></stem>
        <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>P</mi><mfenced open="(" close=")"><mrow><mi>X</mi><mo>≥</mo><msub><mrow><mi>X</mi></mrow><mrow><mo>max</mo></mrow></msub></mrow></mfenced><mo>=</mo><munderover><mrow><mo>∑</mo></mrow><mrow><mrow><mi>j</mi><mo>=</mo><msub><mrow><mi>X</mi></mrow><mrow><mo>max</mo></mrow></msub></mrow></mrow><mrow><mn>1000</mn></mrow></munderover><mfenced open="(" close=")"><mtable><mtr><mtd><mn>0.0001</mn></mtd></mtr><mtr><mtd><mi>j</mi></mtd></mtr></mtable></mfenced><msup><mrow><mi>p</mi></mrow><mrow><mi>j</mi></mrow></msup><msup><mrow><mfenced open="(" close=")"><mrow><mn>1000.00001</mn><mo>−</mo><mi>p</mi></mrow></mfenced></mrow><mrow><mrow><mn>1.003</mn><mo>−</mo><mi>j</mi></mrow></mrow></msup></math></stem></p>
        </preface>
   </iso-standard>
  INPUT
   <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <bibdata>
           <title language='en'>test</title>
           <language current='true'>fr</language>
         </bibdata>

         <preface>
           <p>
             <stem type='MathML'><math xmlns='http://www.w3.org/1998/Math/MathML'>
    <mn>30&#x202F;000</mn>
  </math>
</stem>
             <stem type='MathML'>
               <math xmlns='http://www.w3.org/1998/Math/MathML'>
                 <mi>P</mi>
                 <mfenced open='(' close=')'>
                   <mrow>
                     <mi>X</mi>
                     <mo>&#x2265;</mo>
                     <msub>
                       <mrow>
                         <mi>X</mi>
                       </mrow>
                       <mrow>
                         <mo>max</mo>
                       </mrow>
                     </msub>
                   </mrow>
                 </mfenced>
                 <mo>=</mo>
                 <munderover>
                   <mrow>
                     <mo>&#x2211;</mo>
                   </mrow>
                   <mrow>
                     <mrow>
                       <mi>j</mi>
                       <mo>=</mo>
                       <msub>
                         <mrow>
                           <mi>X</mi>
                         </mrow>
                         <mrow>
                           <mo>max</mo>
                         </mrow>
                       </msub>
                     </mrow>
                   </mrow>
                   <mrow>
                     <mn>1&#x202F;000</mn>
                   </mrow>
                 </munderover>
                 <mfenced open='(' close=')'>
                   <mtable>
                     <mtr>
                       <mtd>
                         <mn>0,000&#x202F;1</mn>
                       </mtd>
                     </mtr>
                     <mtr>
                       <mtd>
                         <mi>j</mi>
                       </mtd>
                     </mtr>
                   </mtable>
                 </mfenced>
                 <msup>
                   <mrow>
                     <mi>p</mi>
                   </mrow>
                   <mrow>
                     <mi>j</mi>
                   </mrow>
                 </msup>
                 <msup>
                   <mrow>
                     <mfenced open='(' close=')'>
                       <mrow>
                         <mn>1&#x202F;000,000&#x202F;01</mn>
                         <mo>&#x2212;</mo>
                         <mi>p</mi>
                       </mrow>
                     </mfenced>
                   </mrow>
                   <mrow>
                     <mrow>
                       <mn>1,003</mn>
                       <mo>&#x2212;</mo>
                       <mi>j</mi>
                     </mrow>
                   </mrow>
                 </msup>
               </math>
             </stem>
           </p>
         </preface>
       </iso-standard>
OUTPUT
  end

  it "processes nested roman and alphabetic lists" do 
          expect(xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({}).convert('test', <<~"INPUT", true).gsub(%r{^.*<body}m, '<body').gsub(%r{</body>.*}m, '</body>')))).to be_equivalent_to <<~"OUTPUT"
    <bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::BIPM::VERSION}" type="semantic">
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
<ol id="_b9fb9f0c-29a0-498c-ae78-42b5fab5c418" type="alphabet" start="5">
<li>
<p id="_36f055e4-5cfa-430c-80b9-8a53617af152">b</p>
<ol id="_fccf5477-00b4-42dc-8a32-d7838b3a6880" type="alphabet" start="10">
<li>
<p id="_388d07a4-882d-4f1b-8832-aca813714043">c</p>
</li>
</ol>
</li>
<li>
<ol id="_e883e785-1a4f-4af1-be63-28187c9b8c6a" type="roman" start="2">
<li><p>c1</p></li>
</ol>
<p id="_16e6dafe-d3f2-44c5-bb79-303bc9385d92">d</p>
<ol id="_e883e785-1a4f-4af1-be63-28187c9b8c69" type="roman">
<li>
<p id="_c11e737b-0f02-4d80-9733-84561d743cbf">e</p>
<ol id="_46c2218e-d5e4-4aca-940e-37e8c6099a27" type="roman" start="12">
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


end
