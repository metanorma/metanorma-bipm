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

      def omit_docid_prefix(prefix)
        return true if %w(BIPM).include? prefix

        super
      end

      def render_identifier(ident)
        ret = super
        ret[:sdo] = ret[:sdo]&.sub(/^(BIPM) (PV|CR) (\d.*)$/,
                                   "\\1 <strong>\\2</strong>, \\3")
        ret
      end

      def implicit_reference(bib)
        b = bib.at(ns("./docidentifier[@primary = 'true'][@type = 'BIPM']"))
        return true if /^(CGPM|CIPM|CCDS|CCTF)\s
        (Resolution|Recommendation|Declaration|Decision|Recommendation|Meeting)/x
          .match?(b&.text)

        super
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
          ref << " "
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
          ref << " "
          reference_format(bibitem, ref)
        end
      end

      def term_cleanup(docxml)
        @jcgm ? docxml : super
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
