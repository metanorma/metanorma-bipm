require "isodoc"

module IsoDoc
  module BIPM
    class Metadata < IsoDoc::Generic::Metadata
      def configuration
        Metanorma::BIPM.configuration
      end

      def title(isoxml, _out)
        lang1 = @lang == "fr" ? "fr" : "en"
        lang2 = @lang == "fr" ? "en" : "fr"
        set(:doctitle, @c.encode(isoxml&.at(
          ns("//bibdata/title[@language='#{lang1}']"))&.text || ""))
        set(:docsubtitle, @c.encode(isoxml&.at(
          ns("//bibdata/title[@language='#{lang2}']"))&.text || ""))
      end
    end
  end
end
