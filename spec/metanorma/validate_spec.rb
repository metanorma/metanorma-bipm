require "spec_helper"

RSpec.describe Metanorma::Bipm do
  context "when xref_error.adoc compilation" do
    it "generates error file" do
      FileUtils.rm_rf("xref_error.err.html")
      File.write("xref_error.adoc", <<~CONTENT)
        = X
        A

        == Clause

        <<a,b>>
      CONTENT
      mock_pdf
      expect do
        Metanorma::Compile
          .new
          .compile("xref_error.adoc", type: "bipm", install_fonts: false)
      end.to(
        change { File.exist?("xref_error.err.html") }
          .from(false)
          .to(true),
      )
    end
  end

  it "validates committees" do
    mock_pdf
    Asciidoctor.convert(<<~INPUT, backend: :bipm, header_footer: true)
      = A
      X
      :docfile: test.adoc
      :committee-acronym: TC
      :committee-en: tech committee
      :committee-fr: committee technologique
      :committee-acronym_2: CCU
      :committee-en_2: Consultative Committee for Units
      :committee-fr_2: Comité consultatif des unités

    INPUT
    expect(File.exist?("test.err.html")).to be true
    expect(File.read("test.err.html"))
      .to include("TC is not a recognised committee")
    expect(File.read("test.err.html"))
      .to include("tech committee is not a recognised committee")
    expect(File.read("test.err.html"))
      .to include("committee technologique is not a recognised committee")
    expect(File.read("test.err.html"))
      .not_to include("CCU is not a recognised committee")
    expect(File.read("test.err.html"))
      .not_to include("Consultative Committee for Units is not a recognised committee")
    expect(File.read("test.err.html"))
      .not_to include("Comité consultatif des unités is not a recognised committee")
  end

  it "validates document against Metanorma XML schema" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      = A
      X
      :docfile: test.adoc
      :no-pdf:

      [align=mid-air]
      Para
    INPUT
    expect(File.read("test.err.html"))
      .to include('value of attribute "align" is invalid; must be equal to')
  end
end
