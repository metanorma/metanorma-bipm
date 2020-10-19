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
    end
  end
end
