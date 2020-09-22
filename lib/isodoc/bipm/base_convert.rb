require "isodoc"

module IsoDoc
  module BIPM
    module BaseConvert
      def configuration
        Metanorma::BIPM.configuration
      end
    end
  end
end
