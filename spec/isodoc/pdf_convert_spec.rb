require "spec_helper"

RSpec.describe IsoDoc::BIPM do
  it "splits bilingual collection PDF" do
    FileUtils.rm_rf("test.pdf")
    FileUtils.rm_rf("test_en.pdf")
    FileUtils.rm_rf("test_fr.pdf")
    IsoDoc::BIPM::PdfConvert.new({}).convert("test", <<~"INPUT", false)
      <metanorma-collection xmlns="http://metanorma.org">
        <bibdata type="collection">
          <title format="text/plain" language="en">The International Temperature Scale of 1990 (ITS-90)</title>
        </bibdata>
        <manifest>
          <level>brochure</level>
          <title>Brochure/Brochure</title>
          <docref fileref="brochure-its90-fr.xml" id="doc000000000">
            <identifier>brochure-its90-fr</identifier>
          </docref>
          <docref fileref="brochure-its90-en.xml" id="doc000000001">
            <identifier>brochure-its90-en</identifier>
          </docref>
        </manifest>
        <doc-container id="doc000000000">
          <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" type="presentation" version="0.0.5">
            <bibdata type="standard">
              <title language="en" format="text/plain" type="main">The International Temperature Scale of 1990 (ITS-90)</title>
              <title language="en" format="text/plain" type="cover">The International System of Units (SI)</title>
              <title language="fr" format="text/plain" type="main">&#xC9;chelle Internationale de Temp&#xE9;rature De 1990 (EIT-90)</title>
              <title language="fr" format="text/plain" type="cover">Le Syst&#xE8;me international d&#x2019;unit&#xE9;s (SI)</title>
              <docidentifier type="BIPM">BIPM PLTS-2000</docidentifier>
              <language current="true">fr</language>
              <script current="true">Latn</script>
            </bibdata>
            <preface>
              <clause id="_abstract" obligation="informative">
                <title depth="1">Abstract</title>
              </clause>
            </preface>
          </bipm-standard>
        </doc-container>
        <doc-container id="doc000000001">
          <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" type="presentation" version="0.0.5">
            <bibdata type="standard">
              <title language="en" format="text/plain" type="main">The International Temperature Scale of 1990 (ITS-90)</title>
              <title language="en" format="text/plain" type="cover">The International System of Units (SI)</title>
              <title language="fr" format="text/plain" type="main">&#xC9;chelle Internationale de Temp&#xE9;rature De 1990 (EIT-90)</title>
              <title language="fr" format="text/plain" type="cover">Le Syst&#xE8;me international d&#x2019;unit&#xE9;s (SI)</title>
              <docidentifier type="BIPM">BIPM PLTS-2000</docidentifier>
              <language current="true">en</language>
              <script current="true">Latn</script>
            </bibdata>
            <preface>
              <clause id="_abstract1" obligation="informative">
                <title depth="1">Abstract</title>
              </clause>
            </preface>
          </bipm-standard>
        </doc-container>
      </metanorma-collection>
    INPUT
    expect(File.exist?("test.pdf")).to be true
    expect(File.exist?("test_en.pdf")).to be true
    expect(File.exist?("test_fr.pdf")).to be true
  end

  it "does not split monolingual collection PDF" do
    FileUtils.rm_rf("test.pdf")
    FileUtils.rm_rf("test_en.pdf")
    FileUtils.rm_rf("test_fr.pdf")
    IsoDoc::BIPM::PdfConvert.new({}).convert("test", <<~"INPUT", false)
      <metanorma-collection xmlns="http://metanorma.org">
        <bibdata type="collection">
          <title format="text/plain" language="en">The International Temperature Scale of 1990 (ITS-90)</title>
        </bibdata>
        <manifest>
          <level>brochure</level>
          <title>Brochure/Brochure</title>
          <docref fileref="brochure-its90-fr.xml" id="doc000000000">
            <identifier>brochure-its90-fr</identifier>
          </docref>
          <docref fileref="brochure-its90-en.xml" id="doc000000001">
            <identifier>brochure-its90-en</identifier>
          </docref>
        </manifest>
        <doc-container id="doc000000000">
          <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" type="presentation" version="0.0.5">
            <bibdata type="standard">
              <title language="en" format="text/plain" type="main">The International Temperature Scale of 1990 (ITS-90)</title>
              <title language="en" format="text/plain" type="cover">The International System of Units (SI)</title>
              <title language="fr" format="text/plain" type="main">&#xC9;chelle Internationale de Temp&#xE9;rature De 1990 (EIT-90)</title>
              <title language="fr" format="text/plain" type="cover">Le Syst&#xE8;me international d&#x2019;unit&#xE9;s (SI)</title>
              <docidentifier type="BIPM">BIPM PLTS-2000</docidentifier>
              <language current="true">fr</language>
              <script current="true">Latn</script>
            </bibdata>
            <preface>
              <clause id="_abstract" obligation="informative">
                <title depth="1">Abstract</title>
              </clause>
            </preface>
          </bipm-standard>
        </doc-container>
        <doc-container id="doc000000001">
          <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" type="presentation" version="0.0.5">
            <bibdata type="standard">
              <title language="en" format="text/plain" type="main">The International Temperature Scale of 1990 (ITS-90)</title>
              <title language="en" format="text/plain" type="cover">The International System of Units (SI)</title>
              <title language="fr" format="text/plain" type="main">&#xC9;chelle Internationale de Temp&#xE9;rature De 1990 (EIT-90)</title>
              <title language="fr" format="text/plain" type="cover">Le Syst&#xE8;me international d&#x2019;unit&#xE9;s (SI)</title>
              <docidentifier type="BIPM">BIPM PLTS-2000</docidentifier>
              <language current="true">fr</language>
              <script current="true">Latn</script>
            </bibdata>
            <preface>
              <clause id="_abstract1" obligation="informative">
                <title depth="1">Abstract</title>
              </clause>
            </preface>
          </bipm-standard>
        </doc-container>
      </metanorma-collection>
    INPUT
    expect(File.exist?("test.pdf")).to be true
    expect(File.exist?("test_en.pdf")).to be false
    expect(File.exist?("test_fr.pdf")).to be false
  end

  it "pdf_options returns Hash" do
    docxml = double
    root = double
    allow(docxml).to receive(:root).and_return(root)
    allow(docxml).to receive(:at).and_return(true)
    allow(root).to receive(:name).and_return("metanorma-collection")

    opts = IsoDoc::BIPM::PdfConvert.new({}).pdf_options(docxml)

    expect(opts).to be_a Hash
    expect(opts).to have_key("--split-by-language")
  end
end
