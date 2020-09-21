require "asciidoctor/standoc/converter"
require 'asciidoctor/generic/converter'

module Asciidoctor
  module BIPM
    # A {Converter} implementation that generates RSD output, and a document
    # schema encapsulation of the document for validation
    #
    class Converter < Asciidoctor::Generic::Converter
      register_for "bipm"

      def configuration
        Metanorma::BIPM.configuration
      end

      def html_converter(node)
        IsoDoc::BIPM::HtmlConvert.new(html_extract_attributes(node))
      end

      def presentation_xml_converter(node)
        IsoDoc::BIPM::PresentationXMLConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")
        IsoDoc::BIPM::PdfConvert.new(doc_extract_attributes(node))
      end
    end
  end
end
