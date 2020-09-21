require "spec_helper"

RSpec.describe Asciidoctor::BIPM do
  it "processes a blank document" do
    input = <<~"INPUT"
    #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</vsd-standard>
    OUTPUT

    expect(xmlpp(Asciidoctor.convert(input, backend: :bipm, header_footer: true))).to be_equivalent_to output
  end

  it "converts a blank document" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</vsd-standard>
    OUTPUT

    system "rm -f test.html"
    expect(xmlpp(Asciidoctor.convert(input, backend: :bipm, header_footer: true))).to be_equivalent_to output
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
      :language: en
      :title: Main Title
      :security: Client Confidential
    INPUT

    output = xmlpp(<<~"OUTPUT")
    <?xml version="1.0" encoding="UTF-8"?>
<vsd-standard xmlns="https://www.metanorma.org/ns/vsd">
<bibdata type="standard">
  <title language="en" format="text/plain">Main Title</title>
  <docidentifier type="Vita Green">#{Metanorma::BIPM.configuration.organization_name_long} 1000</docidentifier>
  <docnumber>1000</docnumber>
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
<ext>
  <doctype>standard</doctype>
  <editorialgroup>
    <committee type='A'>TC</committee>
  </editorialgroup>
</ext>
</bibdata>
<sections/>
</vsd-standard>
    OUTPUT

    expect(xmlpp(Asciidoctor.convert(input, backend: :bipm, header_footer: true))).to be_equivalent_to output
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
       </vsd-standard>
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
       </vsd-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :bipm, header_footer: true)))).to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    system "rm -f test.html"
    Asciidoctor.convert(input, backend: :bipm, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "Overpass", sans-serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "Overpass", sans-serif;]m)
  end

  it "uses Chinese fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
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
    INPUT

    system "rm -f test.html"
    Asciidoctor.convert(input, backend: :bipm, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Comic Sans;]m)
  end
end

