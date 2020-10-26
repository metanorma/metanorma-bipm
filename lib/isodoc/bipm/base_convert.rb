require "isodoc"

module IsoDoc
  module BIPM
    module BaseConvert
      def configuration
        Metanorma::BIPM.configuration
      end

      def ol_attrs(node)
        super.merge(attr_code(type: ol_style((node["type"] || "arabic").to_sym),
                              start: node["start"]))
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
