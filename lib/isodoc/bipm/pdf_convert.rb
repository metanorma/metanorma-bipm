require "isodoc"

module IsoDoc
  module BIPM
    # A {Converter} implementation that generates PDF HTML output, and a
    # document schema encapsulation of the document for validation
    class PdfConvert <  IsoDoc::XslfoPdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def configuration
        Metanorma::BIPM.configuration
      end

      def pdf_stylesheet(docxml)
        return "jcgm.standard.xsl" if docxml&.at(ns("//bibdata/ext/editorialgroup/committee/@acronym"))&.value == "JCGM"
        doctype = docxml&.at(ns("//bibdata/ext/doctype"))&.text
        doctype = "brochure" unless %w(guide mise-en-pratique rapport).
          include? doctype
        "bipm.#{doctype}.xsl"
      end

      def pdf_options(docxml)
        if docxml.root.name == "metanorma-collection" &&
            docxml.at("//m:bipm-standard/m:bibdata/m:language[@current = 'true'][. = 'fr']",
                      "m" => configuration.document_namespace) &&
            docxml.at("//m:bipm-standard/m:bibdata/m:language[@current = 'true'][. = 'en']",
                      "m" => configuration.document_namespace)
          "--split-by-language"
        else
          super
        end
      end
    end
  end
end

