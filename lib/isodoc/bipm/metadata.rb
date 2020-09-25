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
          ns("//bibdata/title[@type='main'][@language='#{lang1}']"))&.text || ""))
        set(:docsubtitle, @c.encode(isoxml&.at(
          ns("//bibdata/title[@type='main'][@language='#{lang2}']"))&.text || ""))
        set(:appendixtitle, @c.encode(isoxml&.at(
          ns("//bibdata/title[@type='appendix'][@language='#{lang1}']"))&.text || ""))
        set(:appendixsubtitle, @c.encode(isoxml&.at(
          ns("//bibdata/title[@type='appendix'][@language='#{lang2}']"))&.text || ""))
      end

      def status_print(status)
        return "Procès-Verbal" if status == "procès-verbal"
        return "CIPM-MRA" if status == "cipm-mra"
        status.split(/[- ]/).map.with_index do |s, i|
          (%w(en de).include?(s) && i > 0) ? s : s.capitalize
        end.join(' ')
      end

      def docid(isoxml, _out)
        super
        dn = isoxml.at(ns("//bibdata/ext/structuredidentifier/appendix"))
        dn and set(:appendixid, @i18n.l10n("#{@labels["annex"]} #{dn&.text}"))
      end
    end
  end
end
