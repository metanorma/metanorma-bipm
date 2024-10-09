require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.debug_logger = File.open("vcr.log", "w")
  config.default_cassette_options = {
    clean_outdated_http_interactions: true,
    re_record_interval: 1512000,
    record: :once,
    allow_playback_repeats: true,
    # unicode characters in URL
    # serialize_with: :json,
  }
end

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "metanorma-bipm"
require "metanorma/bipm"
require "rspec/matchers"
require "equivalent-xml"
require "htmlentities"
require "relaton_iso"
require "xml-c14n"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |example|
    Dir.mktmpdir("rspec-") do |dir|
      Dir.chdir(dir) { example.run }
    end
  end
end

OPTIONS = [backend: :bipm, header_footer: true].freeze

def presxml_options
  { semanticxmlinsert: "false" }
end

def metadata(hash)
  hash.sort.to_h.delete_if do |_, v|
    v.nil? || (v.respond_to?(:empty?) && v.empty?)
  end
end

def strip_guid(html)
  html
    .gsub(%r{ id="_[^"]+"}, ' id="_"')
    .gsub(%r{ target="_[^"]+"}, ' target="_"')
    .gsub(%r{<fetched>[^<]+</fetched>}, "<fetched/>")
    .gsub(%r{ schema-version="[^"]+"}, "")
end

def htmlencode(html)
  HTMLEntities.new.encode(html, :hexadecimal)
    .gsub(/&#x3e;/, ">")
    .gsub(/&#xa;/, "\n")
    .gsub(/&#x22;/, '"')
    .gsub(/&#x3c;/, "<")
    .gsub(/&#x26;/, "&")
    .gsub(/&#x27;/, "'")
    .gsub(/\\u(....)/) { "&#x#{$1.downcase};" }
end

ASCIIDOC_BLANK_HDR = <<~HDR.freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:

HDR

VALIDATING_BLANK_HDR = <<~HDR.freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

HDR

def boilerplate_read(file)
  HTMLEntities.new.decode(
    Metanorma::Bipm::Converter.new(:bipm, {}).boilerplate_file_restructure(file)
    .to_xml.gsub(/<(\/)?sections>/, "<\\1boilerplate>")
      .gsub(/ id="_[^"]+"/, " id='_'"),
  )
end

def boilerplate(lang)
  boilerplate_read(
    File.read(boilerplate_filepath(lang), encoding: "utf-8")
    .gsub(/\{\{ agency \}\}/, "BIPM")
    .gsub(/\{\{ docyear \}\}/, Date.today.year.to_s)
    .gsub(/\{% if unpublished %\}.*\{% endif %\}/m, "")
    .gsub(/(?<=\p{Alnum})'(?=\p{Alpha})/, "’")
    .gsub(/<p /, "<p id='_' ")
    .gsub(/<p>/, "<p id='_'>")
    .gsub(/<quote /, "<quote id='_' ")
    .gsub(/<quote>/, "<quote id='_'>"),
  ).gsub(/’/, "&#8217;").gsub(/©/, "&#169;")
end

def boilerplate_filepath(lang)
  file = case lang
         when "jcgm"
           "boilerplate-jcgm-en.adoc"
         when "en", "fr"
           "boilerplate-#{lang}.adoc"
         end

  File.join(File.dirname(__FILE__), "..", "lib", "metanorma", "bipm", file)
end

BLANK_HDR = <<~"HDR".freeze
    <?xml version="1.0" encoding="UTF-8"?>
    <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" version="#{Metanorma::Bipm::VERSION}" type="semantic">
    <bibdata type="standard">
      <docidentifier primary="true" type="BIPM">BIPM </docidentifier>
      <contributor>
        <role type="author"/>
        <organization>
          <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
          <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
        </organization>
      </contributor>
      <contributor>
        <role type="publisher"/>
        <organization>
          <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
          <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
        </organization>
      </contributor>
      <language>en</language>
      <script>Latn</script>
      <status>
        <stage>in-force</stage>
      </status>
      <copyright>
        <from>#{Time.new.year}</from>
        <owner>
          <organization>
            <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
            <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
          </organization>
        </owner>
      </copyright>
      <ext>
        <doctype>brochure</doctype>
        <flavor>bipm</flavor>
      </ext>
    </bibdata>
    <metanorma-extension>
     <presentation-metadata>
              <name>TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
            <presentation-metadata>
              <name>HTML TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
            <presentation-metadata>
              <name>DOC TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
            <presentation-metadata>
              <name>PDF TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
          </metanorma-extension>
  #{boilerplate('en')}
HDR

HTML_HDR = <<~HDR.freeze
  <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
    <div class="title-section">
      <p>&#160;</p>
    </div>
    <br/>
    <div class="prefatory-section">
      <p>&#160;</p>
    </div>
    <br/>
    <div class="main-section">
HDR

def mock_pdf
  allow(Mn2pdf).to receive(:convert) do |url, output,|
    FileUtils.cp(url.delete('"'), output.delete('"'))
  end
end
