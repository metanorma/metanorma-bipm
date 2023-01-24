require "isodoc"

module IsoDoc
  module BIPM
    module BaseConvert
      def configuration
        Metanorma::BIPM.configuration
      end

      def convert1(docxml, filename, dir)
        @jcgm = docxml&.at(ns("//bibdata/ext/editorialgroup/committee/" \
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

      def render_identifier(ident)
        ret = super
        ret[:sdo] = ret[:sdo]&.sub(/^(BIPM)([  ])(PV|CR)([  ])(\d.*)$/,
                                   "\\1\\2<strong>\\3</strong>,\\4\\5")
        ret
      end

      def implicit_reference(bib)
        b = bib.at(ns("./docidentifier[@primary = 'true'][@type = 'BIPM']"))
        doctype = bib.at(ns("//bibdata/ext/doctype"))&.text
        return true if doctype == "brochure" && /^(CGPM|CIPM|CCDS|CCTF)[  ]
        (Resolution|Recommendation|Declaration|Decision|Recommendation|Meeting)/x
          .match?(b&.text)

        super
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
