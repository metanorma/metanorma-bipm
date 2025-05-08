module Metanorma
  module Bipm
    class Converter < Metanorma::Generic::Converter
      def boilerplate_file(_xmldoc)
        if @jcgm
          File.join(File.dirname(__FILE__), "boilerplate-jcgm-en.adoc")
        else
          File.join(File.dirname(__FILE__), "boilerplate-#{@lang}.adoc")
        end
      end

      def sections_cleanup(xml)
        super
        jcgm_untitled_sections_cleanup(xml) if @jcgm
      end

      def jcgm_untitled_sections_cleanup(xml)
        xml.xpath("//clause//clause | //annex//clause | //introduction/clause")
          .each do |c|
          !c&.at("./title")&.text&.empty? and next
          c["inline-header"] = true
        end
      end

      def section_names_terms_cleanup(xml); end

      def section_names_refs_cleanup(xml); end

      def mathml_mi_italics
        { uppergreek: false, upperroman: false,
          lowergreek: false, lowerroman: true }
      end

      def xref_to_eref(elem, name)
        if elem.at("//bibitem[@anchor = '#{elem['target']}']/" \
                   "docidentifier[@type = 'BIPM-long']")
          elem["style"] = "BIPM-long"
        end
        super
      end

      ID_LABELS = {
        "en" => {
          "appendix" => "Appendix",
          "annexid" => "Annex",
          "part" => "Part",
        },
        "fr" => {
          "appendix" => "Annexe",
          "annexid" => "Appendice",
          "part" => "Partie",
        },
      }.freeze

      def bibdata_docidentifier_cleanup(isoxml)
        bibdata_docidentifier_i18n(isoxml)
        super
      end

      def bibdata_docidentifier_i18n(isoxml)
        id, parts = bibdata_docidentifier_i18n_prep(isoxml)
        parts.empty? and return
        id_alt = id.dup
        id.next = id_alt
        bibdata_docidentifier_enhance(id, @lang, parts)
        bibdata_docidentifier_enhance(id_alt, @lang == "en" ? "fr" : "en",
                                      parts)
      end

      def bibdata_docidentifier_i18n_prep(isoxml)
        id = isoxml.at("//bibdata/docidentifier[@type = 'BIPM']")
        parts = %w(appendix annexid part).each_with_object({}) do |w, m|
          dn = isoxml.at("//bibdata/ext/structuredidentifier/#{w}") and
            m[w] = dn.text
        end
        [id, parts]
      end

      def bibdata_docidentifier_enhance(id, lang, parts)
        id["language"] = lang
        ret = %w(appendix annexid part).each_with_object([]) do |w, m|
          p = parts[w] and m << "#{ID_LABELS[lang][w]} #{p}"
        end
        id.children = "#{id.text} #{ret.join(' ')}"
      end
    end
  end
end
