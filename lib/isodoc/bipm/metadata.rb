require "isodoc"

module IsoDoc
  module BIPM
    class Metadata < IsoDoc::Generic::Metadata
      def configuration
        Metanorma::BIPM.configuration
      end

      SI_ASPECT = %w(A_e_deltanu A_e cd_Kcd_h_deltanu cd_Kcd full K_k_deltanu
                     K_k kg_h_c_deltanu kg_h m_c_deltanu m_c mol_NA
                     s_deltanu).freeze

      def initialize(lang, script, locale, labels)
        super
        here = File.join(File.dirname(__FILE__), "html", "si-aspect")
        si_paths = []
        SI_ASPECT.each do |s|
          si_paths << File.expand_path(File.join(here, "#{s}.png"))
        end
        set(:si_aspect_index, SI_ASPECT)
        set(:si_aspect_paths, si_paths)
      end

      def title1(xml, type, lang)
        xml.at(ns("//bibdata/title[@type='title-#{type}']" \
          "[@language='#{lang}']"))
          &.children&.to_xml || ""
      end

      def title(isoxml, _out)
        lang1, lang2 = @lang == "fr" ? %w(fr en) : %w(en fr)
        set(:doctitle, title1(isoxml, "main", lang1))
        set(:docsubtitle, title1(isoxml, "main", lang2))
        %w(appendix annex part subtitle provenance).each do |e|
          set("#{e}title".to_sym, title1(isoxml, e, lang1))
          set("#{e}subtitle".to_sym, title1(isoxml, e, lang2))
        end
      end

      def status_print(status)
        return "Procès-Verbal" if status == "procès-verbal"
        return "CIPM-MRA" if status == "cipm-mra"

        status.split(/[- ]/).map.with_index do |s, i|
          %w(en de).include?(s) && i.positive? ? s : s.capitalize
        end.join(" ")
      end

      def docid(isoxml, _out)
        super
        label1, label2 = @lang == "fr" ? %w(Annexe Appendix) : %w(Appendix Annexe)
        dn = isoxml.at(ns("//bibdata/ext/structuredidentifier/appendix"))
        dn and set(:appendixid, @i18n.l10n("#{label1} #{dn.text}"))
        dn and set(:appendixid_alt, @i18n.l10n("#{label2} #{dn.text}"))
        label1, label2 = @lang == "fr" ? %w(Appendice Annex) : %w(Annex Appendice)
        dn = isoxml.at(ns("//bibdata/ext/structuredidentifier/annexid"))
        dn and set(:annexid, @i18n.l10n("#{label1} #{dn.text}"))
        dn and set(:annexid_alt, @i18n.l10n("#{label2} #{dn.text}"))
        label1, label2 = @lang == "fr" ? %w(Partie Part) : %w(Part Partie)
        dn = isoxml.at(ns("//bibdata/ext/structuredidentifier/part"))
        dn and set(:partid, @i18n.l10n("#{label1} #{dn.text}"))
        dn and set(:partid_alt, @i18n.l10n("#{label2} #{dn.text}"))
        set(:org_abbrev,
            isoxml.at(ns("//bibdata/ext/editorialgroup/committee"\
                         "[@acronym = 'JCGM']")) ? "JCGM" : "BIPM")
      end

      def extract_person_names_affiliations(authors)
        extract_person_affiliations(authors)
      end

      def bibdate(isoxml, _out)
        pubdate = isoxml
          .at(ns("//bibdata/date[not(@format)][@type = 'published']"))
        pubdate and set(:pubdate_monthyear, monthyr(pubdate.text))
      end
    end
  end
end
