require "isodoc"

module IsoDoc
  module BIPM
    module BaseConvert
      def configuration
        Metanorma::BIPM.configuration
      end

      def convert1(docxml, filename, dir)
        @jcgm = docxml&.at(ns("//bibdata/ext/editorialgroup/committee/"\
                              "@acronym"))&.value == "JCGM"
        super
      end

      def middle(isoxml, out)
        if @jcgm
          super
        else
          middle_title(isoxml, out)
          middle_admonitions(isoxml, out)
          clause isoxml, out
          annex isoxml, out
          bibliography isoxml, out
        end
      end

      def middle_clause(docxml)
        if @jcgm
          super
        else
          "//sections/*"
        end
      end

      def render_identifier(id)
        ret = super
        ret[1] = nil if !id[1].nil? && id[1]["type"] == "BIPM"
        ret[2] = nil if !id[2].nil? && id[2]["type"] == "BIPM"
        ret
      end

      def nonstd_bibitem(list, bibitem, ordinal, biblio)
        list.p **attr_code(iso_bibitem_entry_attrs(bibitem, biblio)) do |ref|
          ids = bibitem_ref_code(bibitem)
          identifiers = render_identifier(ids)
          if biblio then ref_entry_code(ref, ordinal, identifiers, ids)
          else
            ref << (identifiers[0] || identifiers[1])
            ref << " #{identifiers[1]}" if identifiers[0] && identifiers[1]
          end
          ref << " " unless biblio && !identifiers[1]
          reference_format(bibitem, ref)
        end
      end

      def std_bibitem_entry(list, bibitem, ordinal, biblio)
        list.p **attr_code(iso_bibitem_entry_attrs(bibitem, biblio)) do |ref|
          identifiers = render_identifier(bibitem_ref_code(bibitem))
          if biblio then ref_entry_code(ref, ordinal, identifiers, nil)
          else
            ref << (identifiers[0] || identifiers[1])
            ref << " #{identifiers[1]}" if identifiers[0] && identifiers[1]
          end
          date_note_process(bibitem, ref)
          ref << " " unless biblio && !identifiers[1]
          reference_format(bibitem, ref)
        end
      end

      def term_cleanup(docxml)
        @jcgm ? docxml : super
      end

      def termref_cleanup(docxml)
        docxml
          .gsub(/\s*\[MODIFICATION\]\s*\[\/TERMREF\]/,
                l10n(", #{@i18n.modified} [/TERMREF]"))
          .gsub(%r{\s*\[/TERMREF\]\s*</p>\s*<p>\s*\[TERMREF\]}, "; ")
          .gsub(/\[TERMREF\]\s*/, l10n("[#{@i18n.source} "))
          .gsub(%r{\s*\[/TERMREF\]\s*}, l10n("]"))
          .gsub(/\s*\[MODIFICATION\]/, l10n(", #{@i18n.modified} &mdash; "))
      end

      def error_parse(node, out)
        case node.name
        when "blacksquare" then blacksquare_parse(node, out)
        else super
        end
      end

      def blacksquare_parse(_node, out)
        out << "&#x25a0;"
      end
    end
  end
end
