require "spec_helper"

RSpec.describe Metanorma::BIPM::Processor do
  registry = Metanorma::Registry.instance
  registry.register(Metanorma::BIPM::Processor)

  let(:processor) { registry.find_processor(:bipm) }

  it "registers against metanorma" do
    expect(processor).not_to be nil
  end

  it "registers output formats against metanorma" do
    expect(processor.output_formats.sort.to_s).to be_equivalent_to <<~"OUTPUT"
      [[:html, "html"], [:pdf, "pdf"], [:presentation, "presentation.xml"], [:rxl, "rxl"], [:xml, "xml"]]
    OUTPUT
  end

  it "registers version against metanorma" do
    expect(processor.version.to_s).to match(%r{^Metanorma::BIPM })
  end

  it "generates IsoDoc XML from a blank document" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = xmlpp(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections/>
      </bipm-standard>
    OUTPUT

    expect(xmlpp(strip_guid(processor
      .input_to_isodoc(input, nil))))
      .to be_equivalent_to xmlpp(strip_guid(output))
  end

  it "generates HTML from IsoDoc XML" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://metanorma.org/ns/bipm">
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
      <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
        <p class="zzSTDTitle1"></p>
        <div id="H"><h1 id="_">1.&#xA0; Terms, Definitions, Symbols and Abbreviated Terms</h1>
           <p class='Terms' style='text-align:left;' id='J'>
            <strong>1.1.</strong>&#xA0;Term2</p>
        </div>
      </main>
    OUTPUT

    processor.output(input, "test.xml", "test.html", :html)

    expect(
      xmlpp(strip_guid(File.read("test.html", encoding: "utf-8")
        .gsub(%r{^.*<main}m, "<main")
        .gsub(%r{</main>.*}m, "</main>"))),
    ).to be_equivalent_to xmlpp(strip_guid(output))
  end
end
