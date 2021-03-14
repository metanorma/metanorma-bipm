require "spec_helper"

RSpec.describe Asciidoctor::BIPM do
  context "when xref_error.adoc compilation" do
    it "generates error file" do
      FileUtils.rm_rf("xref_error.err")
      File.write("xref_error.adoc", <<~"CONTENT")
        = X
        A

        == Clause

        <<a,b>>
      CONTENT
      mock_pdf
      expect do
        Metanorma::Compile
          .new
          .compile("xref_error.adoc", type: "bipm", no_install_fonts: true)
      end.to(
        change { File.exist?("xref_error.err") }
          .from(false)
          .to(true)
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
    expect(File.exist?("test.err")).to be true
    expect(File.read("test.err")).to include "TC is not a recognised committee"
    expect(File.read("test.err")).to include "tech committee is not a recognised committee"
    expect(File.read("test.err")).to include "committee technologique is not a recognised committee"
    expect(File.read("test.err")).not_to include "CCU is not a recognised committee"
    expect(File.read("test.err")).not_to include "Consultative Committee for Units is not a recognised committee"
    expect(File.read("test.err")).not_to include "Comité consultatif des unités is not a recognised committee"
  end
end
