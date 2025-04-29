module IsoDoc
  module Bipm
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def middle_title(docxml)
        @jcgm or return nil
        @iso.middle_title(docxml)
      end

      def table_delim
        l10n("x.<tab/>").sub("x", "") # force French " .</tab>"
      end

      def figure1(elem)
        if @jcgm
          @iso.xrefs = @xrefs
          @iso.figure1(elem)
        else super
        end
      end

      def note_delim(_elem)
        l10n("x:<tab/>").sub("x", "") # force French " :</tab>"
      end

      # notes and remarques (list notes) are not numbered
      def note1(elem)
        elem.parent.name == "bibitem" || elem["notag"] == "true" and return
        lbl = l10n(note_label(elem))
        prefix_name(elem, { label: note_delim(elem) }, lbl, "name")
      end

      def note_label(elem)
        if elem.ancestors("preface").empty?
          if elem.ancestors("ul, ol, dl").empty?
            @i18n.note
          else @i18n.listnote end
        else @i18n.prefacenote
        end
      end

      def termsource_label(elem, sources)
        elem.replace(l10n("[#{termsource_adapt(elem['status'])} #{sources}]"))
      end

      def termsource_adapt(status)
        case status
        when "adapted" then @i18n.adapted_from
        when "modified" then @i18n.modified_from
        else ""
        end
      end

      def termsource(docxml)
        termsource_insert_empty_modification(docxml)
        super
      end

      def termsource_insert_empty_modification(docxml)
        docxml.xpath("//xmlns:term//xmlns:source[@status = 'modified']" \
                     "[not(xmlns:modification)]").each do |f|
          f << "<modification/>"
        end
      end

      def termsource_modification(elem)
        termsource_add_modification_text(elem.at(ns("./modification")))
      end

      def ul_label_list(_elem)
        %w(&#x2022; &#x2212; &#x6f;)
      end

      def ol_label_template(_elem)
        super.merge({
                      roman: %{<span class="fmt-label-delim">(</span>% \
                      <span class="fmt-label-delim">)</span>},
                      arabic: %{%<span class="fmt-label-delim">.</span>},
                    })
      end
    end
  end
end
