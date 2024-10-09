module IsoDoc
  module Bipm
    class I18n < IsoDoc::Generic::I18n
      def configuration
        Metanorma::Bipm.configuration
      end
    end
  end
end
