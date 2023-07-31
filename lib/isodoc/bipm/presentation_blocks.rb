module IsoDoc
  module BIPM
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def middle_title(docxml)
        @jcgm or return nil
        super
      end

      def table1(elem)
        labelled_ancestor(elem) || elem["unnumbered"] and return
        n = @xrefs.anchor(elem["id"], :label, false)
        prefix_name(elem, ".<tab/>",
                    l10n("#{@i18n.table.capitalize} #{n}"), "name")
      end

      def figure1(elem)
        if @jcgm
          @iso.xrefs = @xrefs
          @iso.figure1(elem)
        else super
        end
      end

      # notes and remarques (list notes) are not numbered
      def note1(elem)
        elem.parent.name == "bibitem" || elem["notag"] == "true" and return
        lbl = l10n(note_label(elem))
        prefix_name(elem, "", lbl, "name")
      end

      def note_label(elem)
        if elem.ancestors("preface").empty?
          if elem.ancestors("ul, ol, dl").empty?
            @i18n.note
          else @i18n.listnote end
        else @i18n.prefacenote
        end
      end
    end
  end
end
