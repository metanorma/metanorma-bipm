require "spec_helper"

RSpec.describe Asciidoctor::BIPM do
  it "processes a blank document" do
    input = <<~"INPUT"
    #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "converts a blank document" do
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

    system "rm -f test.html"
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
  end

  it "processes default metadata" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee: TC
      :committee-acronym: TCA
      :committee-number: 1
      :committee-type: A
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-acronym: WGA
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: en
      :title-en: Main Title
      :title-fr: Chef Title
      :title-cover-en: Main Title (SI)
      :title-cover-fr: Chef Title (SI)
      :title-appendix-en: Main Title (SI)
      :title-appendix-fr: Chef Title (SI)
      :appendix-id: ABC
      :security: Client Confidential
      :comment-period-from: X
      :comment-period-to: Y
      :supersedes: A
      :superseded-by: B
      :obsoleted-date: C
      :implemented-date: D
      :si-aspect: A_e_deltanu
    INPUT

    output = xmlpp(<<~"OUTPUT")
    <?xml version="1.0" encoding="UTF-8"?>
<bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::BIPM::VERSION}" type="semantic">
<bibdata type="standard">
<title language='en' format='text/plain' type='main'>Main Title</title>
<title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
<title language='en' format='text/plain' type='appendix'>Main Title (SI)</title>
<title language='fr' format='text/plain' type='main'>Chef Title</title>
<title language='fr' format='text/plain' type='cover'>Chef Title (SI)</title>
<title language='fr' format='text/plain' type='appendix'>Chef Title (SI)</title>
  <docidentifier type="BIPM">#{Metanorma::BIPM.configuration.organization_name_short} 1000</docidentifier>
  <docnumber>1000</docnumber>
  <date type='implemented'>
  <on>D</on>
</date>
<date type='obsoleted'>
  <on>C</on>
</date>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
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
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
        <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
      </organization>
    </owner>
  </copyright>
  <relation type='supersedes'>
  <bibitem>
    <title>--</title>
    <docidentifier>A</docidentifier>
  </bibitem>
</relation>
<relation type='supersededBy'>
  <bibitem>
    <title>--</title>
    <docidentifier>B</docidentifier>
  </bibitem>
</relation>
<ext>
  <doctype>brochure</doctype>
  <editorialgroup>
    <committee acronym="TCA">TC</committee>
    <workgroup acronym="WGA">WG</workgroup>
  </editorialgroup>
  <comment-period>
  <from>X</from>
  <to>Y</to>
</comment-period>
<si-aspect>A_e_deltanu</si-aspect>
<structuredidentifier>
  <docnumber>1000</docnumber>
  <appendix>ABC</appendix>
</structuredidentifier>
</ext>
</bibdata>
    #{boilerplate("en").gsub(/2020/, "2001")}
<sections/>
</bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "processes default metadata in French" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: standard
      :edition: 2
      :revdate: 2000-01-01
      :draft: 3.4
      :committee: TC
      :committee-number: 1
      :committee-type: A
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: working-draft
      :iteration: 3
      :language: fr
      :title-en: Main Title
      :title-fr: Chef Title
      :title-cover-en: Main Title (SI)
      :title-cover-fr: Chef Title (SI)
      :security: Client Confidential
      :appendix-id: ABC
      :comment-period-from: X
      :comment-period-to: Y
      :supersedes: A
      :superseded-by: B
      :obsoleted-date: C
      :implemented-date: D
    INPUT

    output = xmlpp(<<~"OUTPUT")
    <?xml version="1.0" encoding="UTF-8"?>
<bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::BIPM::VERSION}" type="semantic">
<bibdata type="standard">
<title language='en' format='text/plain' type='main'>Main Title</title>
<title language='en' format='text/plain' type='cover'>Main Title (SI)</title>
<title language='fr' format='text/plain' type='main'>Chef Title</title>
<title language='fr' format='text/plain' type='cover'>Chef Title (SI)</title>
  <docidentifier type="BIPM">#{Metanorma::BIPM.configuration.organization_name_short} 1000</docidentifier>
  <docnumber>1000</docnumber>
  <date type='implemented'>
  <on>D</on>
</date>
<date type='obsoleted'>
  <on>C</on>
</date>
  <contributor>
    <role type="author"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
      <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
    </organization>
  </contributor>
  <edition>2</edition>
<version>
  <revision-date>2000-01-01</revision-date>
  <draft>3.4</draft>
</version>
  <language>fr</language>
  <script>Latn</script>
  <status>
    <stage>working-draft</stage>
    <iteration>3</iteration>
  </status>
  <copyright>
    <from>2001</from>
    <owner>
      <organization>
        <name>#{Metanorma::BIPM.configuration.organization_name_long}</name>
        <abbreviation>#{Metanorma::BIPM.configuration.organization_name_short}</abbreviation>
      </organization>
    </owner>
  </copyright>
  <relation type='supersedes'>
  <bibitem>
    <title>--</title>
    <docidentifier>A</docidentifier>
  </bibitem>
</relation>
<relation type='supersededBy'>
  <bibitem>
    <title>--</title>
    <docidentifier>B</docidentifier>
  </bibitem>
</relation>
<ext>
  <doctype>brochure</doctype>
  <editorialgroup>
    <committee acronym="">TC</committee>
    <workgroup acronym="">WG</workgroup>
  </editorialgroup>
  <comment-period>
  <from>X</from>
  <to>Y</to>
</comment-period>
<structuredidentifier>
  <docnumber>1000</docnumber>
  <appendix>ABC</appendix>
</structuredidentifier>
</ext>
</bibdata>
    #{boilerplate("fr").gsub(/2020/, "2001")}
<sections/>
</bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end


  it "processes figures" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [[id]]
      .Figure 1
      ....
      This is a literal

      Amen
      ....
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
       <sections>
                <figure id="id">
         <name>Figure 1</name>
         <pre id="_">This is a literal

       Amen</pre>
       </figure>
       </sections>
       </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
             <preface><foreword id="_" obligation="informative">
         <title>Foreword</title>
         <p id="_">This is a preamble</p>
       </foreword></preface><sections>
       <clause id='_' obligation='normative'>
         <title>Section 1</title>
       </clause></sections>
       </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "uses pagenumber xrefs" do
        input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [[a]]
      == Section 1
      <<a>>
      <<a,pagenumber%>>
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
         <sections>
           <clause id='a' obligation='normative'>
             <title>Section 1</title>
             <p id='_'>
               <xref target='a'/>
               <xref target='a' pagenumber='true'/>
             </p>
           </clause>
         </sections>
       </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    system "rm -f test.html"
    Asciidoctor.convert(input, backend: :bipm, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Times New Roman;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Times New Roman;]m)
  end

  it "uses Chinese fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :no-pdf:
    INPUT

    system "rm -f test.html"
    Asciidoctor.convert(input, backend: :bipm, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "SimSun", serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "SimHei", sans-serif;]m)
  end

  it "uses specified fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :body-font: Zapf Chancery
      :header-font: Comic Sans
      :monospace-font: Andale Mono
      :no-pdf:
    INPUT

    system "rm -f test.html"
    Asciidoctor.convert(input, backend: :bipm, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Comic Sans;]m)
  end

  it "has unnumbered clauses" do
    expect(xmlpp(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :bipm, header_footer: true)))).to be_equivalent_to <<~"OUTPUT"
    #{ASCIIDOC_BLANK_HDR}

    [%unnumbered]
    == Clause

    [appendix%unnumbered]
    == Appendix
    INPUT
    #{BLANK_HDR}
     <sections>
   <clause id='_' unnumbered='true' obligation='normative'>
     <title>Clause</title>
   </clause>
 </sections>
 <annex id='_' obligation='normative' unnumbered="true">
   <title>Appendix</title>
 </annex>
</bipm-standard>
    OUTPUT
  end
end

