require "metanorma/standoc/converter"
require "metanorma/generic/converter"
require_relative "front"
require_relative "cleanup"
require_relative "validate"

module Metanorma
  module Bipm
    class Converter < Metanorma::Generic::Converter
      register_for "bipm"

      def configuration
        Metanorma::Bipm.configuration
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
        ret == "terms and definitions" and return ret
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

      def clause_attrs_preprocess(attrs, node)
        node.option?("unnumbered") and attrs[:unnumbered] = true
        super
      end

      def annex_attrs_preprocess(attrs, node)
        node.option?("unnumbered") and attrs[:unnumbered] = true
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
        IsoDoc::Bipm::HtmlConvert.new(html_extract_attributes(node))
      end

      def presentation_xml_converter(node)
        IsoDoc::Bipm::PresentationXMLConvert
          .new(html_extract_attributes(node)
          .merge(output_formats: ::Metanorma::Bipm::Processor.new
          .output_formats))
      end

      def pdf_converter(node)
        node.attr("no-pdf") and return nil
        IsoDoc::Bipm::PdfConvert.new(pdf_extract_attributes(node))
      end
    end
  end
end

require_relative "log"
