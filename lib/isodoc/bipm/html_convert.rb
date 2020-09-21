require "isodoc"
require "isodoc/generic/html_convert"
require_relative "init"

module IsoDoc
  module BIPM
    # A {Converter} implementation that generates HTML output, and a document
    # schema encapsulation of the document for validation
    #
    class HtmlConvert < IsoDoc::Generic::HtmlConvert
      def configuration
        Metanorma::BIPM.configuration
      end

      include Init
    end
  end
end

