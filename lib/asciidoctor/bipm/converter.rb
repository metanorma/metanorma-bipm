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

      def metadata_committee(node, xml)
        return unless node.attr("committee")
        xml.editorialgroup do |a|
          a.committee node.attr("committee")
          i = 2
          while node.attr("committee_#{i}") do
            a.committee node.attr("committee_#{i}")
            i += 1
          end
          a.workgroup node.attr("workgroup")
          i = 2
          while node.attr("workgroup_#{i}") do
            a.workgroup node.attr("workgroup_#{i}")
            i += 1
          end
        end
      end

      def title(node, xml)
        ["en", "fr"].each do |lang|
          at = { language: lang, format: "text/plain" }
          xml.title **attr_code(at.merge(type: "main")) do |t1|
            t1 << Asciidoctor::Standoc::Utils::asciidoc_sub(
              node.attr("title-#{lang}"))
          end
        end
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
