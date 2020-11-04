require "isodoc"

module IsoDoc
  module BIPM
    module BaseConvert
      def configuration
        Metanorma::BIPM.configuration
      end

      def middle(isoxml, out)
        middle_title(out)
        middle_admonitions(isoxml, out)
        clause isoxml, out
        annex isoxml, out
        bibliography isoxml, out
      end

      def middle_clause
        "//sections/*"
      end
    end
  end
end
