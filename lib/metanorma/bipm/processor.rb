require "metanorma/processor"

module Metanorma
  module BIPM
    class Processor < Metanorma::Generic::Processor
      def configuration
        Metanorma::BIPM.configuration
      end

      def output_formats
        super.merge(
          html: "html",
          pdf: "pdf",
        ).tap { |hs| hs.delete(:doc) }
      end

      def fonts_manifest
        {
          "Arial" => nil,
          "Times New Roman" => nil,
          "Work Sans" => nil,
          "Work Sans Black" => nil,
          "Work Sans ExtraBold" => nil,
          "Work Sans ExtraLight" => nil,
          "Work Sans Light" => nil,
          "Work Sans Medium" => nil,
          "Work Sans SemiBold" => nil,
          "Work Sans Thin" => nil,
          "STIX Two Math" => nil,
          "Source Han Sans" => nil,
          "Source Han Sans Normal" => nil,
          "TeXGyreChorus" => nil,
          "Courier New" => nil,
          "Noto Serif" => nil,
          "Noto Serif HK" => nil,
          "Noto Serif JP" => nil,
          "Noto Serif KR" => nil,
          "Noto Serif SC" => nil,
          "Noto Serif TC" => nil,
          "Noto Sans Mono" => nil,
          "Noto Sans Mono CJK HK" => nil,
          "Noto Sans Mono CJK JP" => nil,
          "Noto Sans Mono CJK KR" => nil,
          "Noto Sans Mono CJK SC" => nil,
          "Noto Sans Mono CJK TC" => nil,
        }
      end

      def version
        "Metanorma::BIPM #{Metanorma::BIPM::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options = {})
        case format
        when :html
          IsoDoc::BIPM::HtmlConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::BIPM::PresentationXMLConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::BIPM::PdfConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end
    end
  end
end
