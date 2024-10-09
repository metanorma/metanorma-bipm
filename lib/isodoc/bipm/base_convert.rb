require "isodoc"

module IsoDoc
  module Bipm
    module BaseConvert
      attr_accessor :jcgm

      def configuration
        Metanorma::Bipm.configuration
      end

      TOP_ELEMENTS = IsoDoc::Function::ToWordHtml::TOP_ELEMENTS +
        " | //doccontrol[@displayorder]".freeze

      def convert1(docxml, filename, dir)
        @jcgm = docxml&.at(ns("//bibdata/ext/editorialgroup/committee/" \
                              "@acronym"))&.value == "JCGM"
        super
      end

      def middle_clause(_docxml)
        if @jcgm
          "//clause[parent::sections][not(@type = 'scope')]" \
            "[not(descendant::terms)][not(descendant::references)]"
        else
          "//sections/*[not(local-name() = 'references')][not(.//references)]"
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
        return true if @doctype == "brochure" && /^(CGPM|CIPM|CCDS|CCTF)[  ]
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

      def top_element_render(elem, out)
        case elem.name
        when "doccontrol" then doccontrol elem, out
        else super
        end
      end
    end
  end
end
