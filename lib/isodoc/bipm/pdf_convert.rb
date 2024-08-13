require "isodoc"
require "metanorma-generic"
require_relative "base_convert"

module IsoDoc
  module BIPM
    class PdfConvert < IsoDoc::Generic::PdfConvert
      def initialize(options)
        super
        @libdir = File.dirname(__FILE__)
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

      include Init
      include BaseConvert
    end
  end
end
