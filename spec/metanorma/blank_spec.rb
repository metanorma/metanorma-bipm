require "spec_helper"

RSpec.describe Metanorma::BIPM do
  it "processes a blank document" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections/>
      </bipm-standard>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "converts a blank document" do
    FileUtils.rm_rf("test.html")
    FileUtils.rm_rf("test.pdf")
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections/>
      </bipm-standard>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
    expect(File.exist?("test.pdf")).to be true
  end

  it "converts a blank JCGM document" do
    FileUtils.rm_rf("test.html")
    FileUtils.rm_rf("test.pdf")
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :committee-acronym: JCGM
      :committee-en: Joint Committee for Guides in Metrology#{' '}
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
         #{BLANK_HDR.sub(%r{<boilerplate>.*</boilerplate>}m, boilerplate('jcgm'))
         .sub(/<docidentifier primary="true" type="BIPM">BIPM/, %(<docidentifier primary="true" type="BIPM">JCGM))
         .sub(%r{</ext>}, "<editorialgroup>
        <committee acronym='JCGM'>
          <variant language='en' script='Latn'>Joint Committee for Guides in Metrology</variant>
        </committee>
      </editorialgroup></ext>") }
             <sections/>
           </bipm-standard>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
    expect(File.exist?("test.pdf")).to be true
  end
end
