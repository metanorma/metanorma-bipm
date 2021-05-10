require "spec_helper"

gem_lib = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib"))
logoloc = File.join(gem_lib, "metanorma", "..", "..", "lib", "isodoc", "bipm",
                    "html")
logoloc1 = File.join(gem_lib, "isodoc", "bipm", "html")

si_aspect = [
  "A_e_deltanu",
  "A_e",
  "cd_Kcd_h_deltanu",
  "cd_Kcd",
  "full",
  "K_k_deltanu",
  "K_k",
  "kg_h_c_deltanu",
  "kg_h",
  "m_c_deltanu",
  "m_c",
  "mol_NA",
  "s_deltanu",
].freeze
si_aspect_paths = si_aspect.map do |x|
  File.join(logoloc1, "si-aspect", "#{x}.png")
end

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
          <title type="annex" language="en" format="plain">Main Title Annex</title>
          <title type="annex" language="fr" format="plain">Chef Title Annex</title>
          <title type="part" language="en" format="plain">Main Title Part</title>
          <title type="part" language="fr" format="plain">Chef Title Part</title>
          <title type="subpart" language="en" format="plain">Main Title Subpart</title>
          <title type="subpart" language="fr" format="plain">Chef Title Subpart</title>
          <title type="provenance" language="en" format="plain">Main Title Provenance</title>
          <title type="provenance" language="fr" format="plain">Chef Title Provenance</title>
          <docidentifier>1000</docidentifier>
          <date type="published">2021-04</date>
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
              <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
            </organization>
          </contributor>
          <contributor>
            <role type="publisher"/>
            <organization>
              <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
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
                <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <editorialgroup>
              <committee acronym="JCGM">
                <variant language="en" script="Latn">TC</variant>
                <variant language="fr" script="Latn">CT</variant>
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
              <annexid>DEF</annexid>
            </structuredidentifier>
          </ext>
        </bibdata>
        <sections/>
      </bipm-standard>
    INPUT

    output = <<~"OUTPUT"
      {:accesseddate=>"XXX",
      :agency=>"#{Metanorma::BIPM.configuration.organization_name_long['en']}",
      :annexid=>"Annex DEF",
      :annexid_alt=>"Appendice DEF",
      :annexsubtitle=>"Chef Title Annex",
      :annextitle=>"Main Title Annex",
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
      :logo=>"#{File.join(logoloc, 'logo.png')}",
      :metadata_extensions=>{"editorialgroup"=>{"committee_acronym"=>"JCGM", "committee"=>{"variant_language"=>["en", "fr"], "variant_script"=>["Latn", "Latn"], "variant"=>["TC", "CT"]}, "workgroup_acronym"=>"B", "workgroup"=>"WC"}, "comment-period"=>{"from"=>"N1", "to"=>"N2"}, "si-aspect"=>"A_e_deltanu", "meeting-note"=>"ABC", "structuredidentifier"=>{"docnumber"=>"1000", "part"=>"2.1", "appendix"=>"ABC", "annexid"=>"DEF"}},
      :obsoleteddate=>"XXX",
      :org_abbrev=>"JCGM",
      :partid=>"Part 2.1",
      :partid_alt=>"Partie 2.1",
      :partsubtitle=>"Chef Title Part",
      :parttitle=>"Main Title Part",
      :provenancesubtitle=>"Chef Title Provenance",
      :provenancetitle=>"Main Title Provenance",
      :pubdate_monthyear=>"April 2021",
      :publisheddate=>"XXX",
      :publisher=>"#{Metanorma::BIPM.configuration.organization_name_long['en']}",
      :receiveddate=>"XXX",
      :revdate=>"2000-01-01",
      :revdate_monthyear=>"January 2000",
      :script=>"Latn",
      :si_aspect_index=>#{si_aspect},
      :si_aspect_paths=>#{si_aspect_paths},
      :stage=>"Mise en Pratique",
      :stage_display=>"En Vigeur",
      :tc=>"\\n          TC\\n          CT\\n        ",
      :transmitteddate=>"XXX",
      :unchangeddate=>"XXX",
      :unpublished=>true,
      :updateddate=>"XXX",
      :vote_endeddate=>"XXX",
      :vote_starteddate=>"XXX"}
    OUTPUT

    docxml, = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil))).to_s
      .gsub(/, :/, ",\n:"))
      .to be_equivalent_to output
  end

  it "processes default metadata in French" do
    csdc = IsoDoc::BIPM::HtmlConvert.new({})
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <bibdata type="standard">
          <title format="plain" language="en" type="main">Main Title</title>
          <title format="plain" language="fr" type="main">Chef Title</title>
          <title format="plain" language="en" type="cover">Main Title Cover</title>
          <title format="plain" language="fr" type="cover">Chef Title Cover</title>
          <title format="plain" language="en" type="appendix">Main Title Appendix</title>
          <title format="plain" language="fr" type="appendix">Chef Title Appendix</title>
          <title format="plain" language="en" type="annex">Main Title Annex</title>
          <title format="plain" language="fr" type="annex">Chef Title Annex</title>
          <docidentifier>1000</docidentifier>
          <contributor>
            <role type="author"/>
            <organization>
              <name>#{Metanorma::BIPM.configuration.organization_name_long['fr']}</name>
            </organization>
          </contributor>
          <contributor>
            <role type="publisher"/>
            <organization>
              <name>#{Metanorma::BIPM.configuration.organization_name_long['fr']}</name>
            </organization>
          </contributor>
          <version>
            <edition>2</edition>
            <revision-date>2000-01-01</revision-date>
            <draft>3.4</draft>
          </version>
          <language>fr</language>
          <script>Latn</script>
          <status>
            <stage>working-draft</stage>
          </status>
          <copyright>
            <from>2001</from>
            <owner>
              <organization>
                <name>#{Metanorma::BIPM.configuration.organization_name_long['fr']}</name>
              </organization>
            </owner>
          </copyright>
          <editorialgroup>
            <committee acronym="TCA">
              <variant language="en" script="Latn">TC</variant>
              <variant language="fr" script="Latn">CT</variant>
            </committee>
          </editorialgroup>
          <security>Client Confidential</security>
          <ext>
            <doctype>cipm-mra</doctype>
            <comment-period>
              <from>N1</from>
              <to>N2</to>
            </comment-period>
            <structuredidentifier>
              <docnumber>1000</docnumber>
              <part>2.1</part>
              <appendix>ABC</appendix>
              <annexid>DEF</annexid>
            </structuredidentifier>
          </ext>
        </bibdata>
        <sections/>
      </bipm-standard>
    INPUT

    output = <<~"OUTPUT"
      {:accesseddate=>"XXX",
      :agency=>"#{Metanorma::BIPM.configuration.organization_name_long['fr']}",
      :annexid=>"Appendice DEF",
      :annexid_alt=>"Annex DEF",
      :annexsubtitle=>"Main Title Annex",
      :annextitle=>"Chef Title Annex",
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
      :logo=>"#{File.join(logoloc, 'logo.png')}",
      :metadata_extensions=>{"doctype"=>"cipm-mra", "comment-period"=>{"from"=>"N1", "to"=>"N2"}, "structuredidentifier"=>{"docnumber"=>"1000", "part"=>"2.1", "appendix"=>"ABC", "annexid"=>"DEF"}},
      :obsoleteddate=>"XXX",
      :org_abbrev=>"BIPM",
      :partid=>"Partie 2.1",
      :partid_alt=>"Part 2.1",
      :publisheddate=>"XXX",
      :publisher=>"#{Metanorma::BIPM.configuration.organization_name_long['fr']}",
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

    docxml, = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil))).to_s
      .gsub(/, :/, ",\n:")).to be_equivalent_to output
  end

  it "ignores unrecognised status" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <bibdata type="standard">
          <status>
            <stage>standard</stage>
          </status>
        </bibdata>
        <version>
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
      :logo=>"#{File.join(logoloc, 'logo.png')}",
      :obsoleteddate=>"XXX",
      :org_abbrev=>"BIPM",
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
    docxml, = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil))).to_s
      .gsub(/, :/, ",\n:")).to be_equivalent_to output
  end

  it "processes dates in Presentation XML" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
      <bibdata type="standard">
      <date type="published">2021-04</date>
      </bibdata>
      </bipm-standard>
    INPUT
    output = <<~"OUTPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
      <bibdata type="standard">
      <date type="published">2021-04</date>
      <date type='published' format='ddMMMyyyy'>April 2021</date>
      </bibdata>
      </bipm-standard>
    OUTPUT
    stripped_presxml =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))
    expect(stripped_presxml).to(be_equivalent_to(xmlpp(output)))
  end

  it "processes pre" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <preface>
          <foreword>
            <pre>ABC</pre>
          </foreword>
        </preface>
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

    expect(strip_guid(xmlpp(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to be_equivalent_to output
  end

  it "processes table" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <sections>
          <clause id="A">
            <table id="B">
              <name>First Table</name>
            </table>
            <table id="C" unnumbered="true">
              <name>Second Table</name>
            </table>
          </clause>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
        <sections>
          <clause id="A">
            <title>1.</title>
            <table id="B">
              <name>Table 1.<tab/>First Table</name>
            </table>
             <table id='C' unnumbered='true'>
               <name>Second Table</name>
             </table>
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
            <p class='TableTitle' style='text-align:center;'>Second Table</p>
            <table id='C' class='MsoISOTable' style='border-width:1px;border-spacing:0;'/>
          </div>
        </div>
      </body>
    OUTPUT
    stripped_presxml =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_presxml).to(be_equivalent_to(xmlpp(presxml)))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "processes simple terms & definitions" do
    input = <<~"INPUT"
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
          <terms id="H" obligation="normative">
            <title>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <term id="J">
              <name>1.1.</name>
              <preferred>Term2</preferred>
              <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
            </term>
          </terms>
        </sections>
      </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
          <main class='main-section'>
        <button onclick='topFunction()' id='myBtn' title='Go to top'>Top</button>
        <p class='zzSTDTitle1'/>
        <div id='H'>
          <h1 id='toc0'>1.&#xA0; Terms, Definitions, Symbols and Abbreviated Terms</h1>
          <h2 class='TermNum' id='J'>
            1.1.&#xA0;
            <p class='Terms' style='text-align:left;'>Term2</p>
          </h2>
          <p>
            [Adapted from
            <a href='#ISO7301'/>
            , modified &#x2014; The term "cargo rice" is shown as deprecated, and Note
            1 to entry is not included here]
          </p>
        </div>
      </main>
    OUTPUT

    IsoDoc::BIPM::HtmlConvert.new({}).convert("test", input, false)
    stripped_html = xmlpp(File.read("test.html", encoding: "utf-8")
      .gsub(%r{^.*<main}m, "<main")
      .gsub(%r{</main>.*}m, "</main>"))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "processes simple terms & definitions in JCGM" do
    input = <<~"INPUT"
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
            <title>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <term id="J">
              <name>1.1.</name>
              <preferred>Term2</preferred>
              <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
            </term>
          </terms>
        </sections>
      </bipm-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
      <main class='main-section'>
           <button onclick='topFunction()' id='myBtn' title='Go to top'>Top</button>
           <p class='zzSTDTitle1'/>
           <div id='H'>
             <h1 id='toc0'>1.&#xA0; Terms, Definitions, Symbols and Abbreviated Terms</h1>
             <h2 class='TermNum' id='J'>1.1.</h2>
                  <p class='Terms' style='text-align:left;'>Term2</p>
               <p>
                  [Adapted from
                  <a href='#ISO7301'/>
                  , modified &#x2014; The term "cargo rice" is shown as deprecated, and Note
                  1 to entry is not included here]
                  </p>
           </div>
         </main>
    OUTPUT

    IsoDoc::BIPM::HtmlConvert.new({}).convert("test", input, false)
    stripped_html = xmlpp(File.read("test.html", encoding: "utf-8")
      .gsub(%r{^.*<main}m, "<main")
      .gsub(%r{</main>.*}m, "</main>"))
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

    presxml = xmlpp(<<~"OUTPUT")
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
            <div>
              <h1 class='ForewordTitle'>Foreword</h1>
              <p id='A'>This is a preamble</p>
            </div>
            <br/>
            <div class='Section3' id='B'>
              <h1 class='IntroTitle'>Introduction</h1>
              <div id='C'>
                <h2>Introduction Subsection</h2>
              </div>
            </div>
            <p class='zzSTDTitle1'/>
            <div id='H'>
              <h1> 1. &#160; Terms, Definitions, Symbols and Abbreviated Terms </h1>
              <div id='I'>
                <h2> 1.1. &#160; Normal Terms </h2>
                <p class='TermNum' id='J'>1.1.1.</p>
                <p class='Terms' style='text-align:left;'>Term2</p>
              </div>
              <div id='D'>
                <h2> 1.2. &#160; Scope </h2>
                <p id='E'>Text</p>
              </div>
              <div id='K'>
                <h2>1.3.</h2>
                <dl>
                  <dt>
                    <p>Symbol</p>
                  </dt>
                  <dd>Definition</dd>
                </dl>
              </div>
            </div>
            <div id='L'>
              <h1>2.</h1>
              <dl>
                <dt>
                  <p>Symbol</p>
                </dt>
                <dd>Definition</dd>
              </dl>
            </div>
            <div id='M'>
              <h1> 3. &#160; Clause 4 </h1>
              <div id='N'>
                <h2> 3.1. &#160; Introduction </h2>
              </div>
              <div id='O'>
                <h2> 3.2. &#160; Clause 4.2 </h2>
              </div>
            </div>
            <br/>
            <div id='P' class='Section3'>
              <h1 class='Annex'>
                <b>Appendix 1</b>
                 . &#160;
                <b>Annex</b>
              </h1>
              <div id='Q'>
                <h2> 1.1. &#160; Annex A.1 </h2>
                <div id='Q1'>
                  <h3> 1.1.1. &#160; Annex A.1a </h3>
                </div>
              </div>
            </div>
            <br/>
            <div>
              <h1 class='Section3'>Bibliography</h1>
              <div>
                <h2 class='Section3'>Bibliography Subsection</h2>
              </div>
            </div>
          </div>
        </body>
      </html>
    OUTPUT
    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))
    expect(stripped_html).to(be_equivalent_to(presxml))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)))
    expect(stripped_html).to(be_equivalent_to(html))
  end

  it "processes section names, JCGM" do
    input = <<~"INPUT"
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

    presxml = xmlpp(<<~"OUTPUT")
      <bipm-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
        <bibdata>
          <ext>
            <editorialgroup>
              <committee acronym='JCGM'>
                 Joint Committee for Guides in Metrology Comit&#xE9; commun pour les
                guides en m&#xE9;trologie
              </committee>
            </editorialgroup>
          </ext>
        </bibdata>
        <preface>
          <foreword obligation='informative'>
            <title>Foreword</title>
            <p id='A'>This is a preamble</p>
          </foreword>
          <introduction id='B' obligation='informative'>
            <title depth='1'>0.<tab/>Introduction</title>
            <clause id='C' inline-header='false' obligation='informative'>
              <title depth='2'>0.1.<tab/>Introduction Subsection</title>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id='G' type='scope'>
            <title depth='1'>
              1.
              <tab/>
              Scope
            </title>
          </clause>
          <clause id='H' obligation='normative'>
            <title depth='1'>
              3.
              <tab/>
              Terms, Definitions, Symbols and Abbreviated Terms
            </title>
            <terms id='I' obligation='normative'>
              <title depth='2'>
                3.1.
                <tab/>
                Normal Terms
              </title>
              <term id='J'>
                <name>3.1.1.</name>
                <preferred>Term2</preferred>
              </term>
            </terms>
            <clause id='D' obligation='normative'>
              <title depth='2'>
                3.2.
                <tab/>
                Scope
              </title>
              <p id='E'>Text</p>
            </clause>
            <definitions id='K'>
              <title>3.3.</title>
              <dl>
                <dt>Symbol</dt>
                <dd>Definition</dd>
              </dl>
            </definitions>
          </clause>
          <definitions id='L'>
            <title>4.</title>
            <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
            </dl>
          </definitions>
          <clause id='M' inline-header='false' obligation='normative'>
            <title depth='1'>
              5.
              <tab/>
              Clause 4
            </title>
            <clause id='N' inline-header='false' obligation='normative'>
              <title depth='2'>
                5.1.
                <tab/>
                Introduction
              </title>
            </clause>
            <clause id='O' inline-header='false' obligation='normative'>
              <title depth='2'>
                5.2.
                <tab/>
                Clause 4.2
              </title>
            </clause>
          </clause>
        </sections>
        <annex id='P' inline-header='false' obligation='normative'>
          <title>
            <strong>Annex A</strong>
            <br/>
            <strong>Annex</strong>
          </title>
          <clause id='Q' inline-header='false' obligation='normative'>
            <title depth='2'>
              A.1.
              <tab/>
              Annex A.1
            </title>
            <clause id='Q1' inline-header='false' obligation='normative'>
              <title depth='3'>
                A.1.1.
                <tab/>
                Annex A.1a
              </title>
            </clause>
          </clause>
        </annex>
        <bibliography>
          <references id='R' obligation='informative' normative='true'>
            <title depth='1'>
              2.
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
            <div>
              <h1 class='ForewordTitle'>Foreword</h1>
              <p id='A'>This is a preamble</p>
            </div>
            <br/>
            <div class='Section3' id='B'>
            <h1 class='IntroTitle'> 0. &#160; Introduction </h1>
                <div id='C'>
                   <h2> 0.1. &#160; Introduction Subsection </h2>
                </div>
            </div>
            <p class='zzSTDTitle1'/>
            <div id='G'>
              <h1> 1. &#160; Scope </h1>
            </div>
            <div>
              <h1> 2. &#160; Normative References </h1>
            </div>
            <div id='H'>
              <h1> 3. &#160; Terms, Definitions, Symbols and Abbreviated Terms </h1>
              <div id='I'>
                <h2> 3.1. &#160; Normal Terms </h2>
                <p class='TermNum' id='J'>3.1.1.</p>
                <p class='Terms' style='text-align:left;'>Term2</p>
              </div>
              <div id='D'>
                <h2> 3.2. &#160; Scope </h2>
                <p id='E'>Text</p>
              </div>
              <div id='K'>
                <h2>3.3.</h2>
                <dl>
                  <dt>
                    <p>Symbol</p>
                  </dt>
                  <dd>Definition</dd>
                </dl>
              </div>
            </div>
            <div id='L' class='Symbols'>
              <h1>4.</h1>
              <dl>
                <dt>
                  <p>Symbol</p>
                </dt>
                <dd>Definition</dd>
              </dl>
            </div>
            <div id='M'>
              <h1> 5. &#160; Clause 4 </h1>
              <div id='N'>
                <h2> 5.1. &#160; Introduction </h2>
              </div>
              <div id='O'>
                <h2> 5.2. &#160; Clause 4.2 </h2>
              </div>
            </div>
            <br/>
            <div id='P' class='Section3'>
              <h1 class='Annex'>
                <b>Annex A</b>
                 <br/>
                <b>Annex</b>
              </h1>
              <div id='Q'>
                <h2> A.1. &#160; Annex A.1 </h2>
                <div id='Q1'>
                  <h3> A.1.1. &#160; Annex A.1a </h3>
                </div>
              </div>
            </div>
            <br/>
            <div>
              <h1 class='Section3'>Bibliography</h1>
              <div>
                <h2 class='Section3'>Bibliography Subsection</h2>
              </div>
            </div>
          </div>
        </body>
      </html>
    OUTPUT
    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))
    expect(stripped_html).to(be_equivalent_to(presxml))
    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)))
    expect(stripped_html).to(be_equivalent_to(html))
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

    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "injects JS into blank html" do
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

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true))))
      .to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Times New Roman})
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
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)))).to be_equivalent_to output
  end

  it "processes ordered lists" do
    input = <<~"INPUT"
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
          <clause id="A">
            <title>Clause</title>
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
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
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
                <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
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
                <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
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
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" version="#{Metanorma::BIPM::VERSION}" type="presentation">
        <bibdata type="standard">
        <title language="en" format="text/plain" type="main">Main Title</title>
        <title language="en" format="text/plain" type="cover">Main Title (SI)</title>
        <title language="en" format="text/plain" type="appendix">Main Title (SI)</title>
          <contributor>
            <role type="author"/>
            <organization>
              <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
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
              <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
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
           <table unnumbered='true'>
             <tbody>
               <tr>
                 <th>Authors:</th>
                 <td/>
                 <td>Andrew Yacoot (NPL), Ulrich Kuetgens (PTB) and Enrico Massa (INRIM)</td>
               </tr>
               <tr>
                 <td>Draft 1.0 Version 1.0</td>
                 <td>2018-06-11</td>
                 <td>WG-N co-chairs: Ronald Dixson (NIST) and Harald Bosse (PTB)</td>
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

    output = xmlpp(<<~"OUTPUT")
      #{HTML_HDR}
            <p class='zzSTDTitle1'>Main Title</p>
            <div class='doccontrol'>
              <h1>Document Control</h1>
              <table class='MsoISOTable' style='border-width:1px;border-spacing:0;'>
                 <tbody>
                   <tr>
                     <th style='font-weight:bold;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;' scope='row'>Authors:</th>
                     <td style='border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'/>
                     <td style='border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'>Andrew Yacoot (NPL), Ulrich Kuetgens (PTB) and Enrico Massa (INRIM)</td>
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

    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
    expect(stripped_html).to(be_equivalent_to(presxml))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "generates shorter document control text" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::BIPM::VERSION}" type="semantic">
        <bibdata type="standard">
          <title language='en' format='text/plain' type='main'>Main Title</title>
          <title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
          <title language='en' format='text/plain' type='appendix'>Main Title (SI)</title>
            <contributor>
              <role type="author"/>
              <organization>
                <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
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
              <role type="publisher"/>
              <organization>
                <name>#{Metanorma::BIPM.configuration.organization_name_long['en']}</name>
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
        </bibdata>
        <sections/>
      </bipm-standard>
    INPUT

    presxml = <<~PRESXML
      <bipm-standard xmlns='https://www.metanorma.org/ns/bipm' version="#{Metanorma::BIPM::VERSION}" type='presentation'>
      <bibdata type='standard'>
             <title language='en' format='text/plain' type='main'>Main Title</title>
             <title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
             <title language='en' format='text/plain' type='appendix'>Main Title (SI)</title>
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
             <edition>2</edition>
             <version>
               <revision-date>2000-01-01</revision-date>
               <draft>3.4</draft>
             </version>
             <language current='true'>en</language>
             <script current='true'>Latn</script>
             <status>
               <stage language=''>working-draft</stage>
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
           <sections/>
           <doccontrol>
             <title>Document Control</title>
             <table unnumbered='true'>
               <tbody>
                 <tr>
                   <th>Authors:</th>
                   <td/>
                   <td>Andrew Yacoot (NPL) and Ulrich Kuetgens (PTB)</td>
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
             <p class='zzSTDTitle1'>Main Title</p>
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

    stripped_html =
      xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
    expect(stripped_html).to(be_equivalent_to(presxml))
    stripped_html = xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "localises numbers in MathML, English" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <bibdata>
          <title language="en">test</title>
          <language>en</language>
        </bibdata>
        <preface>
          <p>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mn>30000</mn>
              </math>
            </stem>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mi>P</mi>
                <mfenced close=")" open="(">
                  <mrow>
                    <mi>X</mi>
                    <mo>≥</mo>
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
                    <mo>∑</mo>
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
                    <mn>1000</mn>
                  </mrow>
                </munderover>
                <mfenced close=")" open="(">
                  <mtable>
                    <mtr>
                      <mtd>
                        <mn>0.0001</mn>
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
                    <mfenced close=")" open="(">
                      <mrow>
                        <mn>1000.00001</mn>
                        <mo>−</mo>
                        <mi>p</mi>
                      </mrow>
                    </mfenced>
                  </mrow>
                  <mrow>
                    <mrow>
                      <mn>1.003</mn>
                      <mo>−</mo>
                      <mi>j</mi>
                    </mrow>
                  </mrow>
                </msup>
              </math>
            </stem>
          </p>
        </preface>
      </iso-standard>
    INPUT

    expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))
      .to be_equivalent_to xmlpp(<<~OUTPUT)
        <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
          <bibdata>
            <title language="en">test</title>
            <language current="true">en</language>
          </bibdata>

          <preface>
            <p>
              <stem type='MathML'>
                <math xmlns='http://www.w3.org/1998/Math/MathML'>
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
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <bibdata>
          <title language="en">test</title>
          <language>fr</language>
        </bibdata>
        <preface>
          <p>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mn>30000</mn>
              </math>
            </stem>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mi>P</mi>
                <mfenced close=")" open="(">
                  <mrow>
                    <mi>X</mi>
                    <mo>≥</mo>
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
                    <mo>∑</mo>
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
                    <mn>1000</mn>
                  </mrow>
                </munderover>
                <mfenced close=")" open="(">
                  <mtable>
                    <mtr>
                      <mtd>
                        <mn>0.0001</mn>
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
                    <mfenced close=")" open="(">
                      <mrow>
                        <mn>1000.00001</mn>
                        <mo>−</mo>
                        <mi>p</mi>
                      </mrow>
                    </mfenced>
                  </mrow>
                  <mrow>
                    <mrow>
                      <mn>1.003</mn>
                      <mo>−</mo>
                      <mi>j</mi>
                    </mrow>
                  </mrow>
                </msup>
              </math>
            </stem>
          </p>
        </preface>
      </iso-standard>
    INPUT

    expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))
      .to be_equivalent_to xmlpp(<<~OUTPUT)

        <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
          <bibdata>
            <title language="en">test</title>
            <language current="true">fr</language>
          </bibdata>

          <preface>
            <p>
              <stem type='MathML'>
               <math xmlns='http://www.w3.org/1998/Math/MathML'>
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
    input = <<~"INPUT"
      <bipm-standard type="semantic" version="#{Metanorma::BIPM::VERSION}" xmlns="https://www.metanorma.org/ns/bipm">
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
        </preface>
      </bipm-standard>
    INPUT

    expect(xmlpp(strip_guid(IsoDoc::BIPM::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to be_equivalent_to <<~"OUTPUT"

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
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(<<~"OUTPUT")

        <bipm-standard xmlns='https://open.ribose.com/standards/bipm' type='presentation'>
          <bibdata>
            <language current='true'>en</language>
            <script current='true'>Latn</script>
          </bibdata>
          <sections>
            <clause id='A'>
              <title>1.</title>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <clause id='B'>
                <title>1.1.</title>
                <bookmark id='_'/>
                <bookmark id='_'/>
                <bookmark id='_'/>
                <bookmark id='_'/>
              </clause>
            </clause>
          </sections>
          <indexsect id='_'>
            <title>Index</title>
            <clause id='_'>
              <title>D</title>
              <ul>
                <li>
                  <em>Dasein</em>
                  , see <em>Eman</em>cipation, &#xEA;tre
                </li>
              </ul>
            </clause>
            <clause id='_'>
              <title>E</title>
              <ul>
                <li>
                  &#xE9;long&#xE9;,
                  <xref target='_' pagenumber='true'>Chapter 1</xref>
                </li>
                <li>
                  <em>Eman</em>cipation,
                  <xref target='_' pagenumber='true'>Chapter 1</xref>
                  ,
                  <xref target='_' pagenumber='true'>Section 1.1</xref>
                  <ul>
                    <li>
                      dans la France,
                      <xref target='_' pagenumber='true'>Chapter 1</xref>
                      <ul>
                        <li>
                          &#xE0; Paris,
                          <xref target='_' pagenumber='true'>Section 1.1</xref>
                        </li>
                        <li>
                          en Bretagne,
                          <xref target='_' pagenumber='true'>Chapter 1</xref>
                        </li>
                      </ul>
                    </li>
                    <li>
                      dans les &#xC9;tats-Unis,
                      <xref target='_' pagenumber='true'>Section 1.1</xref>
                    </li>
                  </ul>
                </li>
                <li>
                  &#xEA;tre
                  <ul>
                    <li>
                      Husserl, see zebra, see also <em>Eman</em>cipation, zebra
                      <ul>
                        <li>
                          en allemand,
                          <xref target='_' pagenumber='true'>Chapter 1</xref>
                        </li>
                      </ul>
                    </li>
                  </ul>
                </li>
              </ul>
            </clause>
            <clause id='_'>
              <title>Z</title>
              <ul>
                <li>
                  zebra,
                  <xref target='_' pagenumber='true'>Section 1.1</xref>
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
    expect(xmlpp(strip_guid(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(<<~"OUTPUT")
        <bipm-standard xmlns='https://open.ribose.com/standards/bipm' type='presentation'>
          <bibdata>
            <language current='true'>fr</language>
            <script current='true'>Latn</script>
          </bibdata>
          <sections>
            <clause id='A'>
              <title>1.</title>
              <xref target='I'>Index</xref>
              <bookmark to='End' id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <bookmark id='_'/>
              <clause id='B'>
                <title>1.1.</title>
                <bookmark id='_'/>
                <bookmark id='_'/>
                <bookmark id='_'/>
                <bookmark id='_'/>
                <bookmark id='End'/>
              </clause>
            </clause>
          </sections>
          <indexsect id='I'>
            <title>Index</title>
            <p>Voici un index</p>
            <clause id='_'>
              <title>D</title>
              <ul>
                <li>
                  <em>Dasein</em>
                  ,
                  <em>voir</em>
                   Emancipation, &#xEA;tre
                </li>
              </ul>
            </clause>
            <clause id='_'>
              <title>E</title>
              <ul>
                <li>
                  &#xE9;long&#xE9;,
                  <xref target='_' to='End' pagenumber='true'>chap&#xEE;tre 1</xref>
                </li>
                <li>
                  Emancipation,
                  <xref target='_' pagenumber='true'>chap&#xEE;tre 1</xref>
                  ,
                  <xref target='_' pagenumber='true'>section 1.1</xref>
                  <ul>
                    <li>
                      dans la France,
                      <xref target='_' pagenumber='true'>chap&#xEE;tre 1</xref>
                      <ul>
                        <li>
                          &#xE0; Paris,
                          <xref target='_' pagenumber='true'>section 1.1</xref>
                        </li>
                        <li>
                          en Bretagne,
                          <xref target='_' pagenumber='true'>chap&#xEE;tre 1</xref>
                        </li>
                      </ul>
                    </li>
                    <li>
                      dans les &#xC9;tats-Unis,
                      <xref target='_' pagenumber='true'>section 1.1</xref>
                    </li>
                  </ul>
                </li>
                <li>
                  &#xEA;tre
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
                          <xref target='_' pagenumber='true'>chap&#xEE;tre 1</xref>
                        </li>
                      </ul>
                    </li>
                  </ul>
                </li>
              </ul>
            </clause>
            <clause id='_'>
              <title>Z</title>
              <ul>
                <li>
                  zebra,
                  <xref target='_' pagenumber='true'>section 1.1</xref>
                </li>
              </ul>
            </clause>
          </indexsect>
        </bipm-standard>
    OUTPUT
  end

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
          <foreword>
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
          <introduction id='intro'>
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
          <clause id='scope' type="scope">
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
          <terms id='terms'>
        <title>2.</title>
      </terms>
          <clause id='widgets'>
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
        <annex id='annex1'>
        <title>
        <strong>Appendix 1</strong>
      </title>
          <clause id='annex1a'><title>1.1.</title>
            <formula id='AN'>
              <name>1.1</name>
              <stem type='AsciiMath'>r = 1 %</stem>
            </formula>
          </clause>
          <clause id='annex1b'><title>1.2.</title>
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
    expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true))).to be_equivalent_to xmlpp(output)
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
            <foreword obligation="informative">
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
          <xref target="Q">Appendix 1.1</xref>
          <xref target="Q1">Appendix 1.1.1</xref>
          <xref target="Q2">[Q2]</xref>
          <xref target="Q3">[Q3]</xref>
          <xref target="R">Chapter 2</xref></p>
      </foreword>
    OUTPUT
    expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({})
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
      <foreword obligation='informative'>
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
    expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .sub(%r{^.*<foreword}m, "<foreword")
      .sub(%r{</foreword>.*$}m, "</foreword>")))
      .to be_equivalent_to xmlpp(output)
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
      <foreword>
        <p id='_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f'>
          <eref bibitemid='ISO712'>
            <locality type='clause'>
              <referenceFrom>3</referenceFrom>
            </locality>
            ISO 712, Clause 3
          </eref>
          <eref bibitemid='ISO712'>
            <locality type='clause'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            ISO 712, Clause 3.1
          </eref>
          <eref bibitemid='ISO712'>
            <locality type='table'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            ISO 712, Table 3.1
          </eref>
        </p>
      </foreword>
    PRESXML

    expect(xmlpp(Nokogiri::XML(IsoDoc::BIPM::PresentationXMLConvert.new({})
    .convert("test", input, true))
    .at(".//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "processes bibliographic localities in JCGM" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          <script>Latn</script>
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
      <foreword>
        <p id='_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f'>
          <eref bibitemid='ISO712'>
            <locality type='clause'>
              <referenceFrom>3</referenceFrom>
            </locality>
            [ISO 712], Clause 3
          </eref>
          <eref bibitemid='ISO712'>
            <locality type='clause'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            [ISO 712], 3.1
          </eref>
          <eref bibitemid='ISO712'>
            <locality type='table'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            [ISO 712], Table 3.1
          </eref>
        </p>
      </foreword>
    PRESXML

    expect(xmlpp(Nokogiri::XML(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at(".//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(presxml)
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
           <foreword id='fwd'>
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
           <clause id='scope' type='scope'>
             <title depth='1'>
               1.
               <tab/>
               Scope
             </title>
           </clause>
           <terms id='terms'>
             <title>2.</title>
           </terms>
           <clause id='widgets'>
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
                   <image id='_8357ede4-6d44-4672-bac4-9a85e82ab7f0' mimetype='image/png' src='rice_images/rice_image1.png'/>
                 </figure>
                 <figure id='note2'>
                   <name>Figure 1-2&#xA0;&#x2014; Split-it-right sample divider</name>
                   <image id='_8357ede4-6d44-4672-bac4-9a85e82ab7f0' mimetype='image/png' src='rice_images/rice_image1.png'/>
                 </figure>
               </figure>
               <p>
                 <xref target='note1'>Figure 1-1</xref>
                 <xref target='note2'>Figure 1-2</xref>
               </p>
             </clause>
           </clause>
         </sections>
         <annex id='annex1'>
           <title>
             <strong>Appendix 1</strong>
           </title>
           <clause id='annex1a'>
             <title>1.1.</title>
           </clause>
           <clause id='annex1b'>
             <title>1.2.</title>
             <figure id='AN'>
               <figure id='Anote1'>
                 <name>Figure 1.1-1&#xA0;&#x2014; Split-it-right sample divider</name>
                 <image id='_8357ede4-6d44-4672-bac4-9a85e82ab7f0' mimetype='image/png' src='rice_images/rice_image1.png'/>
               </figure>
               <figure id='Anote2'>
                 <name>Figure 1.1-2&#xA0;&#x2014; Split-it-right sample divider</name>
                 <image id='_8357ede4-6d44-4672-bac4-9a85e82ab7f0' mimetype='image/png' src='rice_images/rice_image1.png'/>
               </figure>
             </figure>
           </clause>
         </annex>
       </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true).sub(%r{<localized-strings>.*</localized-strings>}m, ""))).to be_equivalent_to xmlpp(output)
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
               <committee acronym='JCGM'> TC CT </committee>
               <workgroup acronym='B'>WC</workgroup>
             </editorialgroup>
           </ext>
         </bibdata>
         <preface>
           <foreword id='fwd'>
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
           <clause id='scope' type='scope'>
             <title depth='1'>
               1.
               <tab/>
               Scope
             </title>
           </clause>
           <terms id='terms'>
             <title>2.</title>
           </terms>
           <clause id='widgets'>
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
                   <image id='_8357ede4-6d44-4672-bac4-9a85e82ab7f0' mimetype='image/png' src='rice_images/rice_image1.png'/>
                 </figure>
                 <figure id='note2'>
                   <name>b)&#xA0; Split-it-right sample divider</name>
                   <image id='_8357ede4-6d44-4672-bac4-9a85e82ab7f0' mimetype='image/png' src='rice_images/rice_image1.png'/>
                 </figure>
               </figure>
               <p>
                 <xref target='note1'>Figure 1 a)</xref>
                 <xref target='note2'>Figure 1 b)</xref>
               </p>
             </clause>
           </clause>
         </sections>
         <annex id='annex1'>
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
                 <image id='_8357ede4-6d44-4672-bac4-9a85e82ab7f0' mimetype='image/png' src='rice_images/rice_image1.png'/>
               </figure>
               <figure id='Anote2'>
                 <name>b)&#xA0; Split-it-right sample divider</name>
                 <image id='_8357ede4-6d44-4672-bac4-9a85e82ab7f0' mimetype='image/png' src='rice_images/rice_image1.png'/>
               </figure>
             </figure>
           </clause>
         </annex>
       </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true).sub(%r{<localized-strings>.*</localized-strings>}m, ""))).to be_equivalent_to xmlpp(output)
  end

  it "handles brackets for multiple erefs in JCGM" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          <script>Latn</script>
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
      <foreword>
        <p id='_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f'>
           [
          <eref bibitemid='ISO712'>ISO 712</eref>
          ] [
          <eref bibitemid='ISO712'>ISO 712</eref>
          ] and [
          <eref bibitemid='ISO712'>ISO 712</eref>
          ,
          <eref bibitemid='ISO712'>ISO 712</eref>
          ] and
          <eref bibitemid='ISO712'>
            <locality type='clause'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            [ISO 712], 3.1
          </eref>
          <eref bibitemid='ISO712'>
            <locality type='table'>
              <referenceFrom>3.1</referenceFrom>
            </locality>
            [ISO 712], Table 3.1
          </eref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::BIPM::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at(".//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end
end
