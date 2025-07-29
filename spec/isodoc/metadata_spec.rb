require "spec_helper"

gem_lib = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib"))
logoloc = File.join(gem_lib, "isodoc", "bipm",
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

RSpec.describe IsoDoc::Bipm do
  it "processes default metadata in English" do
    csdc = IsoDoc::Bipm::HtmlConvert.new({})
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <bibdata type="standard">
          <title type="title-main" language="en" format="plain">Main Title</title>
          <title type="title-main" language="fr" format="plain">Chef Title</title>
          <title type="title-cover" language="en" format="plain">Main Title Cover</title>
          <title type="title-cover" language="fr" format="plain">Chef Title Cover</title>
          <title type="title-appendix" language="en" format="plain">Main Title Appendix</title>
          <title type="title-appendix" language="fr" format="plain">Chef Title Appendix</title>
          <title type="title-annex" language="en" format="plain">Main Title Annex</title>
          <title type="title-annex" language="fr" format="plain">Chef Title Annex</title>
          <title type="title-part" language="en" format="plain">Main Title Part</title>
          <title type="title-part" language="fr" format="plain">Chef Title Part</title>
          <title type="title-subpart" language="en" format="plain">Main Title Subpart</title>
          <title type="title-subpart" language="fr" format="plain">Chef Title Subpart</title>
          <title type="title-provenance" language="en" format="plain">Main Title Provenance</title>
          <title type="title-provenance" language="fr" format="plain">Chef Title Provenance</title>
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
              <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
            </organization>
          </contributor>
          <contributor>
            <role type="publisher"/>
            <organization>
              <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
            </organization>
          </contributor>
          <contributor>
            <role type="authorizer"/>
            <organization>
              <name>ORG1</name>
            </organization>
          </contributor>
          <contributor>
            <role type="authorizer"/>
            <organization>
              <name>ORG2</name>
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
                <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <editorialgroup>
                     <committee acronym="JCGM" language="en" script="Latn">TC</committee>
                    <committee acronym="JCGM" language="fr" script="Latn">CT</committee>
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

    output =
      { accesseddate: "XXX",
        adapteddate: "XXX",
        agency: "#{Metanorma::Bipm.configuration.organization_name_long['en']}",
        annexid: "Appendix DEF",
        annexid_alt: "Appendice DEF",
        annexsubtitle: "Chef Title Annex",
        annextitle: "Main Title Annex",
        announceddate: "XXX",
        appendixid: "Annex ABC",
        appendixid_alt: "Annexe ABC",
        appendixsubtitle: "Chef Title Appendix",
        appendixtitle: "Main Title Appendix",
        authorizer: ["ORG1", "ORG2"],
        authors: ["Gustavo Martos", "Xiuqin Li", "Ralf Josephs"],
        authors_affiliations: ["BIPM", "NIM", "BIPM"],
        circulateddate: "XXX",
        confirmeddate: "XXX",
        copieddate: "XXX",
        correcteddate: "XXX",
        createddate: "XXX",
        docnumber: "1000",
        docsubtitle: "Chef Title",
        doctitle: "Main Title",
        docyear: "2001",
        draft: "3.4",
        draftinfo: " (draft 3.4, 2000-01-01)",
        implementeddate: "XXX",
        issueddate: "XXX",
        lang: "en",
        logo: "#{File.join(logoloc, 'logo.png')}",
        metadata_extensions: {
          "editorialgroup" => { "committee_acronym" => ["JCGM", "JCGM"],
                                "committee_language" => ["en", "fr"], "committee_script" => ["Latn", "Latn"], "committee" => ["TC", "CT"], "workgroup_acronym" => "B", "workgroup" => "WC" }, "comment-period" => { "from" => "N1", "to" => "N2" }, "si-aspect" => "A_e_deltanu", "meeting-note" => "ABC", "structuredidentifier" => { "docnumber" => "1000", "part" => "2.1", "appendix" => "ABC", "annexid" => "DEF" }
        },
        obsoleteddate: "XXX",
        org_abbrev: "JCGM",
        partid: "Part 2.1",
        partid_alt: "Partie 2.1",
        partsubtitle: "Chef Title Part",
        parttitle: "Main Title Part",
        provenancesubtitle: "Chef Title Provenance",
        provenancetitle: "Main Title Provenance",
        pubdate_monthyear: "April 2021",
        publisheddate: "XXX",
        publisher: "#{Metanorma::Bipm.configuration.organization_name_long['en']}",
        receiveddate: "XXX",
        revdate: "2000-01-01",
        revdate_monthyear: "January 2000",
        script: "Latn",
        si_aspect_index: si_aspect,
        si_aspect_paths: si_aspect_paths,
        stable_untildate: "XXX",
        stage: "Mise en Pratique",
        stage_display: "En Vigeur",
        tc: "TC",
        transmitteddate: "XXX",
        unchangeddate: "XXX",
        unpublished: true,
        updateddate: "XXX",
        vote_endeddate: "XXX",
        vote_starteddate: "XXX" }

    docxml, = csdc.convert_init(input, "test", true)
    expect(metadata(csdc.info(docxml, nil)))
      .to be_equivalent_to(output)

    input2 = input.sub("</bibdata>", "</bibdata>#{DOC_SCHEME_2019}")
    docxml, = csdc.convert_init(input2, "test", true)
    m = metadata(csdc.info(docxml, nil))
    output2 = output.merge(
      annexid: "Appendix DEF",
      annexid_alt: "Appendice DEF",
      annexsubtitle: "Chef Title Annex",
      annextitle: "Main Title Annex",
      appendixid: "Annex ABC",
      appendixid_alt: "Annexe ABC",
      appendixsubtitle: "Chef Title Appendix",
      appendixtitle: "Main Title Appendix",
      "presentation_metadata_document-scheme": ["2019"],
    )
    expect(m).to match(output2)
  end

  it "processes default metadata in French" do
    csdc = IsoDoc::Bipm::HtmlConvert.new({})
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <bibdata type="standard">
          <title format="plain" language="en" type="title-main">Main Title</title>
          <title format="plain" language="fr" type="title-main">Chef Title</title>
          <title format="plain" language="en" type="title-cover">Main Title Cover</title>
          <title format="plain" language="fr" type="title-cover">Chef Title Cover</title>
          <title format="plain" language="en" type="title-appendix">Main Title Appendix</title>
          <title format="plain" language="fr" type="title-appendix">Chef Title Appendix</title>
          <title format="plain" language="en" type="title-annex">Main Title Annex</title>
          <title format="plain" language="fr" type="title-annex">Chef Title Annex</title>
          <docidentifier>1000</docidentifier>
          <contributor>
            <role type="author"/>
            <organization>
              <name>#{Metanorma::Bipm.configuration.organization_name_long['fr']}</name>
            </organization>
          </contributor>
          <contributor>
            <role type="publisher"/>
            <organization>
              <name>#{Metanorma::Bipm.configuration.organization_name_long['fr']}</name>
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
                <name>#{Metanorma::Bipm.configuration.organization_name_long['fr']}</name>
              </organization>
            </owner>
          </copyright>
          <editorialgroup>
            <committee acronym="TCA" language="en" script="Latn">TC</committee>
            <committee acronym="TCA" language="fr" script="Latn">CT</committee>
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

    output =
      { accesseddate: "XXX",
        adapteddate: "XXX",
        agency: "#{Metanorma::Bipm.configuration.organization_name_long['fr']}",
        annexid: "Appendice DEF",
        annexid_alt: "Appendix DEF",
        annexsubtitle: "Main Title Annex",
        annextitle: "Chef Title Annex",
        announceddate: "XXX",
        appendixid: "Annexe ABC",
        appendixid_alt: "Annex ABC",
        appendixsubtitle: "Main Title Appendix",
        appendixtitle: "Chef Title Appendix",
        circulateddate: "XXX",
        confirmeddate: "XXX",
        copieddate: "XXX",
        correcteddate: "XXX",
        createddate: "XXX",
        docnumber: "1000",
        docsubtitle: "Main Title",
        doctitle: "Chef Title",
        doctype: "CIPM-MRA",
        doctype_display: "CIPM-MRA",
        docyear: "2001",
        draft: "3.4",
        draftinfo: " (brouillon 3.4, 2000-01-01)",
        implementeddate: "XXX",
        issueddate: "XXX",
        lang: "fr",
        logo: "#{File.join(logoloc, 'logo.png')}",
        metadata_extensions: { "doctype" => "cipm-mra",
                               "comment-period" => { "from" => "N1", "to" => "N2" }, "structuredidentifier" => { "docnumber" => "1000", "part" => "2.1", "appendix" => "ABC", "annexid" => "DEF" } },
        obsoleteddate: "XXX",
        org_abbrev: "BIPM",
        partid: "Partie 2.1",
        partid_alt: "Part 2.1",
        publisheddate: "XXX",
        publisher: "#{Metanorma::Bipm.configuration.organization_name_long['fr']}",
        receiveddate: "XXX",
        revdate: "2000-01-01",
        revdate_monthyear: "Janvier 2000",
        script: "Latn",
        si_aspect_index: si_aspect,
        si_aspect_paths: si_aspect_paths,
        stable_untildate: "XXX",
        stage: "Working Draft",
        stage_display: "Working Draft",
        transmitteddate: "XXX",
        unchangeddate: "XXX",
        unpublished: true,
        updateddate: "XXX",
        vote_endeddate: "XXX",
        vote_starteddate: "XXX" }

    docxml, = csdc.convert_init(input, "test", true)
    expect(metadata(csdc.info(docxml, nil)))
      .to be_equivalent_to(output)

    input2 = input.sub("</bibdata>", "</bibdata>#{DOC_SCHEME_2019}")
    docxml, = csdc.convert_init(input2, "test", true)
    m = metadata(csdc.info(docxml, nil))
    output2 = output.merge(
      annexid: "Appendice DEF",
      annexid_alt: "Appendix DEF",
      annexsubtitle: "Main Title Annex",
      annextitle: "Chef Title Annex",
      appendixid: "Annexe ABC",
      appendixid_alt: "Annex ABC",
      appendixsubtitle: "Main Title Appendix",
      appendixtitle: "Chef Title Appendix",
      "presentation_metadata_document-scheme": ["2019"],
    )
    expect(m).to match(output2)
  end

  it "ignores unrecognised status" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <bibdata type="standard">
          <status>
            <stage>standard</stage>
          </status>
        <version>
          <edition>2</edition>
          <revision-date>2000-01-01</revision-date>
          <draft>3.4</draft>
        </version>
        </bibdata>
        <sections/>
      </bipm-standard>
    INPUT

    output =
      { accesseddate: "XXX",
        adapteddate: "XXX",
        announceddate: "XXX",
        circulateddate: "XXX",
        confirmeddate: "XXX",
        copieddate: "XXX",
        correcteddate: "XXX",
        createddate: "XXX",
        draft: "3.4",
        draftinfo: " (draft 3.4, 2000-01-01)",
        implementeddate: "XXX",
        issueddate: "XXX",
        lang: "en",
        logo: "#{File.join(logoloc, 'logo.png')}",
        obsoleteddate: "XXX",
        org_abbrev: "BIPM",
        publisheddate: "XXX",
        receiveddate: "XXX",
        revdate: "2000-01-01",
        revdate_monthyear: "January 2000",
        script: "Latn",
        si_aspect_index: si_aspect,
        si_aspect_paths: si_aspect_paths,
        stable_untildate: "XXX",
        stage: "Standard",
        stage_display: "Standard",
        transmitteddate: "XXX",
        unchangeddate: "XXX",
        unpublished: true,
        updateddate: "XXX",
        vote_endeddate: "XXX",
        vote_starteddate: "XXX" }

    csdc = IsoDoc::Bipm::HtmlConvert.new({})
    docxml, = csdc.convert_init(input, "test", true)
    expect(metadata(csdc.info(docxml, nil)))
      .to be_equivalent_to(output)
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
      Canon.format_xml(strip_guid(IsoDoc::Bipm::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))
    expect(stripped_presxml).to(be_equivalent_to(Canon.format_xml(output)))
  end

  it "inserts part in appendix title" do
    input = <<~INPUT
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
      <bibdata>
      <title type="title-main" language="en">Maintitle</title>
      <title type="title-part" language="en">Parttitle</title>
      <title type="title-main" language="fr">Titrechef</title>
      <title type="title-part" language="fr">Titrepartie</title>
      <ext>
      <structuredidentifier>
      <part>3</part>
      </structuredidentifier>
      </ext>
      </bibdata>
      </bipm-standard>
    INPUT

    output = Canon.format_xml(<<~OUTPUT)
      <bipm-standard xmlns='https://open.ribose.com/standards/bipm' type='presentation'>
        <bibdata>
           <title type='title-main' language='en'>Maintitle</title>
           <title type='title-part' language='en'>Parttitle</title>
           <title type='title-part-with-numbering' language='en'>Part 3: Parttitle</title>
           <title type='title-main' language='fr'>Titrechef</title>
           <title type='title-part' language='fr'>Titrepartie</title>
           <title type='title-part-with-numbering' language='fr'>Partie 3&#xA0;: Titrepartie</title>
          <ext>
            <structuredidentifier>
              <part>3</part>
            </structuredidentifier>
          </ext>
        </bibdata>
      </bipm-standard>
    OUTPUT

    expect(strip_guid(Canon.format_xml(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to output

    input = <<~INPUT
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
      <bibdata>
      <title type="title-main" language="en">Maintitle</title>
      <title type="title-part" language="en">Parttitle</title>
      <title type="title-main" language="fr">Titrechef</title>
      <title type="title-part" language="fr">Titrepartie</title>
      </bibdata>
      </bipm-standard>
    INPUT

    output = Canon.format_xml(<<~OUTPUT)
      <bipm-standard xmlns='https://open.ribose.com/standards/bipm' type='presentation'>
        <bibdata>
          <title type='title-main' language='en'>Maintitle</title>
          <title type='title-part' language='en'>Parttitle</title>
          <title type='title-main' language='fr'>Titrechef</title>
          <title type='title-part' language='fr'>Titrepartie</title>
        </bibdata>
      </bipm-standard>
    OUTPUT

    expect(strip_guid(Canon.format_xml(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to output
  end

  it "internationalises document identifier" do
    input = <<~INPUT
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
      <bibdata>
      <docidentifier type="BIPM">BIPM 2 3 4 5 6</docidentifier>
      <docidentifier type="BIPM-parent-document">BIPM 2</docidentifier>
      <title type="title-main" language="en">Maintitle</title>
      <ext>
      <structuredidentifier>
      <appendix>3</appendix>
      <annexid>4</annexid>
      <part>5</part>
      <subpart>6</subpart>
      </structuredidentifier>
      </ext>
      </bibdata>
      </bipm-standard>
    INPUT

    output = Canon.format_xml(<<~OUTPUT)
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
         <bibdata>
            <docidentifier type="BIPM">BIPM 2 3 4 5 6</docidentifier>
            <docidentifier type="BIPM-parent-document">BIPM 2</docidentifier>
            <docidentifier type="BIPM" language="fr">BIPM 2 Annexe 3 Appendice 4 Partie 5 Partie de sub 6</docidentifier>
            <docidentifier type="BIPM" language="en">BIPM 2 Annex 3 Appendix 4 Part 5 Sub-part 6</docidentifier>
            <title type="title-main" language="en">Maintitle</title>
            <ext>
               <structuredidentifier>
                  <appendix>3</appendix>
                  <annexid>4</annexid>
                  <part>5</part>
                  <subpart>6</subpart>
               </structuredidentifier>
            </ext>
         </bibdata>
      </bipm-standard>
    OUTPUT

    expect(strip_guid(Canon.format_xml(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to output

    input = input.sub("</bibdata>", <<~XML)
      </bibdata><metanorma-extension><presentation-metadata><name>document-scheme</name><value>2019</value></presentation-metadata></metanorma-extension>
    XML

    output = Canon.format_xml(<<~OUTPUT)
          <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
             <bibdata>
                <docidentifier type="BIPM">BIPM 2 3 4 5 6</docidentifier>
                <docidentifier type="BIPM-parent-document">BIPM 2</docidentifier>
                <docidentifier type="BIPM" language="fr">BIPM 2 Annexe 3 Annexe 4 Partie 5 Partie de sub 6</docidentifier>
                 <docidentifier type="BIPM" language="en">BIPM 2 Appendix 3 Annex 4 Part 5 Sub-part 6</docidentifier>
                <title type="title-main" language="en">Maintitle</title>
                <ext>
                   <structuredidentifier>
                      <appendix>3</appendix>
                      <annexid>4</annexid>
                      <part>5</part>
                      <subpart>6</subpart>
                   </structuredidentifier>
                </ext>
             </bibdata>
                <metanorma-extension>
         <presentation-metadata>
            <name>document-scheme</name>
            <value>2019</value>
         </presentation-metadata>
      </metanorma-extension>
          </bipm-standard>
    OUTPUT

    expect(strip_guid(Canon.format_xml(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to output
  end
end
