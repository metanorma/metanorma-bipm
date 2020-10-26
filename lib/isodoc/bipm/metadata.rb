require "isodoc"

module IsoDoc
  module BIPM
    class Metadata < IsoDoc::Generic::Metadata
      def configuration
        Metanorma::BIPM.configuration
      end

      SI_ASPECT = %w(A_e_deltanu A_e cd_Kcd_h_deltanu cd_Kcd full K_k_deltanu
      K_k kg_h_c_deltanu kg_h m_c_deltanu m_c mol_NA s_deltanu).freeze

      def initialize(lang, script, labels)
        super
        here = File.join(File.dirname(__FILE__), "html", "si-aspect")
        si_paths = []
        SI_ASPECT.each do |s|
          si_paths << File.expand_path(File.join(here, "#{s}.png"))
        end
        set(:si_aspect_index, SI_ASPECT)
        set(:si_aspect_paths, si_paths)
      end

      TITLE = "//bibdata/title".freeze

      def title(isoxml, _out)
        lang1 = @lang == "fr" ? "fr" : "en"
        lang2 = @lang == "fr" ? "en" : "fr"
        set(:doctitle, @c.encode(isoxml&.at(
          ns("#{TITLE}[@type='main'][@language='#{lang1}']"))&.text || ""))
        set(:docsubtitle, @c.encode(isoxml&.at(
          ns("#{TITLE}[@type='main'][@language='#{lang2}']"))&.text || ""))
        set(:appendixtitle, @c.encode(isoxml&.at(
          ns("#{TITLE}[@type='appendix'][@language='#{lang1}']"))&.text || ""))
        set(:appendixsubtitle, @c.encode(isoxml&.at(
          ns("#{TITLE}[@type='appendix'][@language='#{lang2}']"))&.text || ""))
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
        label1 = @lang == "fr" ? "Annexe" : "Appendix"
        label2 = @lang == "fr" ? "Appendix" : "Annexe"
        dn = isoxml.at(ns("//bibdata/ext/structuredidentifier/appendix"))
        dn and set(:appendixid, @i18n.l10n("#{label1} #{dn&.text}"))
        dn and set(:appendixid_alt, @i18n.l10n("#{label2} #{dn&.text}"))
      end

      def extract_person_names_affiliations(authors)
        extract_person_affiliations(authors)
      end
    end
  end
end
