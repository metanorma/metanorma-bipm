require "metanorma/standoc/converter"
require "metanorma/generic/converter"
require_relative "front"

module Metanorma
  module BIPM
    class Converter < Metanorma::Generic::Converter
      register_for "bipm"

      def configuration
        Metanorma::BIPM.configuration
      end

      def org_name_long
        configuration.organization_name_long[@lang]
      end

      def default_publisher
        org_name_long
      end

      def org_abbrev
        { org_name_long => configuration.organization_name_short }
      end

      def sectiontype_streamline(ret)
        case ret
        when "introduction" then @jcgm ? "introduction" : "clause"
        else
          super
        end
      end

      def sectiontype(node, level = true)
        ret = sectiontype1(node)
        return ret if ret == "terms and definitions"

        super
      end

      def inline_anchor_xref_attrs(node)
        flags = %w(pagenumber nosee nopage).each_with_object({}) do |w, m|
          if /#{w}%/.match?(node.text)
            node.text = node.text.sub(/#{w}%/, "")
            m[w] = true
          end
        end
        ret = super
        flags.each_key { |k| ret[k.to_sym] = true }
        ret
      end

      def date_range(date)
        from = date.at("./from")
        to = date.at("./to")
        on = date.at("./on")
        return date.text unless from || on || to
        return on.text.sub(/-.*$/, "") if on

        ret = "#{from.text.sub(/-.*$/, '')}&#x2013;"
        ret += to.text.sub(/-.*$/, "") if to
        ret
      end

      def format_ref(ref, type)
        ref = ref.sub(/^BIPM /, "") if type == "BIPM"
        super
      end

      def clause_parse(attrs, xml, node)
        node.option?("unnumbered") and attrs[:unnumbered] = true
        super
      end

      def annex_parse(attrs, xml, node)
        node.option?("unnumbered") and attrs[:unnumbered] = true
        super
      end

      def ol_attrs(node)
        super.merge(attr_code(start: node.attr("start")))
      end

      def committee_validate(xml)
        committees = Array(configuration&.committees) || return
        committees.empty? and return
        xml.xpath("//bibdata/ext/editorialgroup/committee/variant").each do |c|
          committees.include? c.text or
            @log.add("Document Attributes", nil,
                     "#{c.text} is not a recognised committee")
        end
        xml.xpath("//bibdata/ext/editorialgroup/committee/@acronym").each do |c|
          committees.include? c.text or
            @log.add("Document Attributes", nil,
                     "#{c.text} is not a recognised committee")
        end
      end

      def boilerplate_file(_xmldoc)
        if @jcgm
          File.join(File.dirname(__FILE__), "boilerplate-jcgm-en.adoc")
        else
          File.join(File.dirname(__FILE__), "boilerplate-#{@lang}.adoc")
        end
      end

      def sections_cleanup(xml)
        super
        jcgm_untitled_sections_cleanup(xml) if @jcgm
      end

      def jcgm_untitled_sections_cleanup(xml)
        xml.xpath("//clause//clause | //annex//clause | //introduction/clause")
          .each do |c|
          next if !c&.at("./title")&.text&.empty?

          c["inline-header"] = true
        end
      end

      def section_names_terms_cleanup(xml); end

      def section_names_refs_cleanup(xml); end

      def mathml_mi_italics
        { uppergreek: false, upperroman: false,
          lowergreek: false, lowerroman: true }
      end

      def xref_to_eref(elem, name)
        if elem.at("//bibitem[@id = '#{elem['target']}']/" \
                   "docidentifier[@type = 'BIPM-long']")
          elem["style"] = "BIPM-long"
        end
        super
      end

      def document(node)
        @jcgm = node.attr("committee-acronym") == "JCGM"
        super
      end

      def outputs(node, ret)
        File.open("#{@filename}.xml", "w:UTF-8") { |f| f.write(ret) }
        presentation_xml_converter(node).convert("#{@filename}.xml")
        html_converter(node).convert("#{@filename}.presentation.xml",
                                     nil, false, "#{@filename}.html")
        pdf_converter(node)&.convert("#{@filename}.presentation.xml",
                                     nil, false, "#{@filename}.pdf")
      end

      def html_converter(node)
        IsoDoc::BIPM::HtmlConvert.new(html_extract_attributes(node))
      end

      def presentation_xml_converter(node)
        IsoDoc::BIPM::PresentationXMLConvert
          .new(html_extract_attributes(node)
          .merge(output_formats: ::Metanorma::BIPM::Processor.new.output_formats))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")

        IsoDoc::BIPM::PdfConvert.new(pdf_extract_attributes(node))
      end
    end
  end
end
