require "spec_helper"

logoloc = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "isodoc", "bipm", "html"))

si_aspect = ["A_e_deltanu", "A_e", "cd_Kcd_h_deltanu", "cd_Kcd", "full", "K_k_deltanu", "K_k", "kg_h_c_deltanu", "kg_h", "m_c_deltanu", "m_c", "mol_NA", "s_deltanu"]
si_aspect_paths = si_aspect.map { |x| File.join(logoloc, "si-aspect", "#{x}.png") }

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
  <docidentifier>1000</docidentifier>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
    </organization>
  </contributor>
  <version>
  <edition>2</edition>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
  <language>en</language>
  <script>Latn</script>
  <status><stage>mise-en-pratique</stage></status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      </organization>
    </owner>
  </copyright>
  <ext>
  <editorialgroup>
    <committee acronym="A">TC</committee>
    <workgroup acronym="B">WC</committee>
  </editorialgroup>
  <comment-period><from>N1</from><to>N2</to></comment-period>
  <si-aspect>A_e_deltanu</si-aspect>
  <structuredidentifier>
  <docnumber>1000</docnumber>
  <appendix>ABC</appendix>
</structuredidentifier>
</ext>
</bibdata>
<local_bibdata type="standard">
  <title language="en" format="plain">Main Title</title>
  <title language="fr" format="plain">Chef Title</title>
  <docidentifier>1000</docidentifier>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
    </organization>
  </contributor>
  <version>
  <edition>2</edition>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
  <language>en</language>
  <script>Latn</script>
  <status><stage>en-vigeur</stage></status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      </organization>
    </owner>
  </copyright>
  <ext>
  <editorialgroup>
    <committee type="A">TC</committee>
  </editorialgroup>
  <comment-period><from>N1</from><to>N2</to></comment-period>
  <si-aspect>A_e_deltanu</si-aspect>
  <structuredidentifier>
  <docnumber>1000</docnumber>
  <appendix>ABC</appendix>
</structuredidentifier>
</ext>
</local_bibdata>
<sections/>
</bipm-standard>
    INPUT

    output = <<~"OUTPUT"
{:accesseddate=>"XXX",
:agency=>"#{Metanorma::BIPM.configuration.organization_name_long}",
:appendixid=>"Appendix ABC",
:appendixid_alt=>"Annexe ABC",
:appendixsubtitle=>"Chef Title Appendix",
:appendixtitle=>"Main Title Appendix",
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
:logo=>"#{File.join(logoloc, "logo.png")}",
:metadata_extensions=>{"editorialgroup"=>{"committee_acronym"=>"A", "committee"=>"TC", "workgroup_acronym"=>"B", "workgroup"=>"WC"}, "comment-period"=>{"from"=>"N1", "to"=>"N2"}, "si-aspect"=>"A_e_deltanu", "structuredidentifier"=>{"docnumber"=>"1000", "appendix"=>"ABC"}},
:obsoleteddate=>"XXX",
:publisheddate=>"XXX",
:publisher=>"#{Metanorma::BIPM.configuration.organization_name_long}",
:receiveddate=>"XXX",
:revdate=>"2000-01-01",
:revdate_monthyear=>"January 2000",
:si_aspect_index=>#{si_aspect},
:si_aspect_paths=>#{si_aspect_paths},
:stage=>"Mise en Pratique",
:stage_display=>"En Vigeur",
:tc=>"TC",
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
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
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
        <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      </organization>
    </owner>
  </copyright>
  <editorialgroup>
    <committee type="A">TC</committee>
  </editorialgroup>
  <security>Client Confidential</security>
  <ext><doctype>cipm-mra</doctype>
  <comment-period><from>N1</from><to>N2</to></comment-period>
  <structuredidentifier>
  <docnumber>1000</docnumber>
  <appendix>ABC</appendix>
</structuredidentifier>
</ext>
</bibdata>
<local_bibdata type="standard">
  <title language="en" format="plain">Main Title</title>
  <title language="fr" format="plain">Chef Title</title>
  <docidentifier>1000</docidentifier>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
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
        <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      </organization>
    </owner>
  </copyright>
  <editorialgroup>
    <committee type="A">TC</committee>
  </editorialgroup>
  <security>Client Confidential</security>
  <ext><doctype>procès-verbal</doctype>
  <comment-period><from>N1</from><to>N2</to></comment-period>
  <structuredidentifier>
  <docnumber>1000</docnumber>
  <appendix>ABC</appendix>
</structuredidentifier>
</ext>
</local_bibdata>
<sections/>
</bipm-standard>
    INPUT

    output = <<~"OUTPUT"
{:accesseddate=>"XXX",
:agency=>"#{Metanorma::BIPM.configuration.organization_name_long}",
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
:doctype_display=>"Proc&#xe8;s-Verbal",
:docyear=>"2001",
:draft=>"3.4",
:draftinfo=>" (brouillon 3.4, 2000-01-01)",
:implementeddate=>"XXX",
:issueddate=>"XXX",
:logo=>"#{File.join(logoloc, "logo.png")}",
:metadata_extensions=>{"doctype"=>"cipm-mra", "comment-period"=>{"from"=>"N1", "to"=>"N2"}, "structuredidentifier"=>{"docnumber"=>"1000", "appendix"=>"ABC"}},
:obsoleteddate=>"XXX",
:publisheddate=>"XXX",
:publisher=>"#{Metanorma::BIPM.configuration.organization_name_long}",
:receiveddate=>"XXX",
:revdate=>"2000-01-01",
:revdate_monthyear=>"Janvier 2000",
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
:logo=>"#{File.join(logoloc, "logo.png")}",
:obsoleteddate=>"XXX",
:publisheddate=>"XXX",
:receiveddate=>"XXX",
:revdate=>"2000-01-01",
:revdate_monthyear=>"January 2000",
:si_aspect_index=>#{si_aspect},
:si_aspect_paths=>#{si_aspect_paths},
:stage=>"Standard",
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
       <clause id="D" obligation="normative">
         <title>Scope</title>
         <p id="E">Text</p>
       </clause>

       <clause id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
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
           <clause id='D' obligation='normative'>
             <title depth='1'>
               1.
               <tab/>
               Scope
             </title>
             <p id='E'>Text</p>
           </clause>
           <clause id='H' obligation='normative'>
             <title depth='1'>
               2.
               <tab/>
               Terms, Definitions, Symbols and Abbreviated Terms
             </title>
             <terms id='I' obligation='normative'>
               <title depth='2'>
                 2.1.
                 <tab/>
                 Normal Terms
               </title>
               <term id='J'>
                 <name>2.1.1.</name>
                 <preferred>Term2</preferred>
               </term>
             </terms>
             <definitions id='K'>
               <title>2.2.</title>
               <dl>
                 <dt>Symbol</dt>
                 <dd>Definition</dd>
               </dl>
             </definitions>
           </clause>
           <definitions id='L'>
             <title>3.</title>
             <dl>
               <dt>Symbol</dt>
               <dd>Definition</dd>
             </dl>
           </definitions>
           <clause id='M' inline-header='false' obligation='normative'>
             <title depth='1'>
               4.
               <tab/>
               Clause 4
             </title>
             <clause id='N' inline-header='false' obligation='normative'>
               <title depth='2'>
                 4.1.
                 <tab/>
                 Introduction
               </title>
             </clause>
             <clause id='O' inline-header='false' obligation='normative'>
               <title depth='2'>
                 4.2.
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
        <xref target='D'>Clause 1</xref>
        <xref target='E'>"Echo"</xref>
        <xref target='F'>Clause 1.1</xref>
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
       <ol type="arabic">
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
  <ol type='1'>
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

end

