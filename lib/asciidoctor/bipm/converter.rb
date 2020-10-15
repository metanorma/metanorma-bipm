require "asciidoctor/standoc/converter"
require 'asciidoctor/generic/converter'

module Asciidoctor
  module BIPM
    class Converter < Asciidoctor::Generic::Converter
      register_for "bipm"

      def configuration
        Metanorma::BIPM.configuration
      end

      def metadata_committee(node, xml)
        return unless node.attr("committee-en") || node.attr("committee-fr")
        xml.editorialgroup do |a|
          metadata_committee1(node, a)
          metadata_committee2(node, a)
          metadata_workgroup(node, a)
        end
      end

      def metadata_committee1(node, a)
        a.committee **attr_code(acronym: node.attr("committee-acronym")) do |c|
          e = node.attr("committee-en") and
            c.variant e, language: "en", script: "Latn"
          e = node.attr("committee-fr") and
            c.variant e, language: "fr", script: "Latn"
        end
      end

      def metadata_committee2(node, a)
        i = 2
        while node.attr("committee-en_#{i}") || node.attr("committee-fr_#{i}")  do
          a.committee **attr_code(acronym: node.attr("committee-acronym_#{i}")) do |c|
            e = node.attr("committee-en_#{i}") and
              c.variant e, language: "en", script: "Latn"
            e = node.attr("committee-fr_#{i}") and
              c.variant e, language: "fr", script: "Latn"
          end
          i += 1
        end
      end

      def metadata_workgroup(node, a)
        a.workgroup node.attr("workgroup"),
          **attr_code(acronym: node.attr("workgroup-acronym"))
        i = 2
        while node.attr("workgroup_#{i}") do
          a.workgroup node.attr("workgroup_#{i}"),
            **attr_code(acronym: node.attr("workgroup-acronym_#{i}"))
          i += 1
        end
      end

      def title(node, xml)
        ["en", "fr"].each do |lang|
          at = { language: lang, format: "text/plain" }
          xml.title **attr_code(at.merge(type: "main")) do |t1|
            t1 << Asciidoctor::Standoc::Utils::asciidoc_sub(
              node.attr("title-#{lang}"))
          end
          typed_title(node, xml, lang, "cover")
          typed_title(node, xml, lang, "appendix")
        end
      end

      def typed_title(node, xml, lang, type)
        at = { language: lang, format: "text/plain" }
        return unless title = node.attr("title-#{type}-#{lang}")
        xml.title **attr_code(at.merge(type: type)) do |t1|
          t1 << Asciidoctor::Standoc::Utils::asciidoc_sub(title)
        end
      end

      def sectiontype_streamline(ret)
        case ret
        when "introduction" then "clause"
        else
          super
        end
      end

      def inline_anchor_xref_attrs(node)
        if /pagenumber%/.match(node.text)
          node.text = node.text.sub(/pagenumber%/, "")
          page = true
        end
        page ? super.merge(pagenumber: true) : super
      end

      def clause_parse(attrs, xml, node)
        node.option?("unnumbered") and attrs[:unnumbered] = true
        super
      end

      def annex_parse(attrs, xml, node)
        node.option?("unnumbered") and attrs[:unnumbered] = true
        super
      end

      def outputs(node, ret)
        File.open(@filename + ".xml", "w:UTF-8") { |f| f.write(ret) }
        presentation_xml_converter(node).convert(@filename + ".xml")
        html_converter(node).convert(@filename + ".presentation.xml",
                                     nil, false, "#{@filename}.html")
        pdf_converter(node)&.convert(@filename + ".presentation.xml",
                                     nil, false, "#{@filename}.pdf")
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
