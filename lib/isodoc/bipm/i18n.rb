module IsoDoc
  module BIPM
    class I18n < IsoDoc::Generic::I18n
      def configuration
        Metanorma::BIPM.configuration
      end
    end
  end
end
