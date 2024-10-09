require "metanorma/processor"

module Metanorma
  module Bipm
    class Processor < Metanorma::Generic::Processor
      def configuration
        Metanorma::Bipm.configuration
      end

      def output_formats
        super.merge(
          html: "html",
          pdf: "pdf",
        ).tap { |hs| hs.delete(:doc) }
      end

      def version
        "Metanorma::Bipm #{Metanorma::Bipm::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options = {})
        options_preprocess(options)
        case format
        when :html
          IsoDoc::Bipm::HtmlConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::Bipm::PresentationXMLConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::Bipm::PdfConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end
    end
  end
end
