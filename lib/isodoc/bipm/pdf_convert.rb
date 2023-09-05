require "isodoc"

module IsoDoc
  module BIPM
    # A {Converter} implementation that generates PDF HTML output, and a
    # document schema encapsulation of the document for validation
    class PdfConvert < IsoDoc::XslfoPdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def configuration
        Metanorma::BIPM.configuration
      end

      def pdf_stylesheet(docxml)
        docxml&.at(ns("//bibdata/ext/editorialgroup/committee/@acronym"))
        &.value == "JCGM" and
          return "jcgm.standard.xsl"

        doctype = @doctype
        doctype = "brochure" unless %w(guide mise-en-pratique rapport)
          .include? doctype
        "bipm.#{doctype}.xsl"
      end

      def pdf_options(docxml)
        n = configuration.document_namespace
        q = "//m:bipm-standard/m:bibdata/m:language[@current = 'true']"
        if docxml.root.name == "metanorma-collection" &&
            docxml.at("#{q}[. = 'fr']", "m" => n) &&
            docxml.at("#{q}[. = 'en']", "m" => n)
          return super.tap do |h|
            h["--split-by-language"] = nil
          end
        end
        super
      end
    end
  end
end
