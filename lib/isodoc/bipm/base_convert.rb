require "isodoc"

module IsoDoc
  module BIPM
    module BaseConvert
      def configuration
        Metanorma::BIPM.configuration
      end

      def ol_attrs(node)
        super.merge(type: ol_style((node["type"] || "arabic").to_sym))
      end
    end
  end
end
