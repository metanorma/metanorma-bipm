require "isodoc"
require "metanorma-generic"
require "metanorma-iso"
require_relative "init"
require_relative "index"
require_relative "doccontrol"
require_relative "../../relaton/render/general"
require_relative "presentation_blocks"
require_relative "presentation_biblio"

module IsoDoc
  module Bipm
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def convert1(docxml, filename, dir)
        @jcgm = docxml&.at(ns("//bibdata/ext/editorialgroup/committee/" \
                              "@acronym"))&.value == "JCGM"
        @xrefs.klass.jcgm = @jcgm
        @jcgm and @iso = iso_processor(docxml)
        super
      end

      def iso_processor(docxml)
        iso = IsoDoc::Iso::PresentationXMLConvert
          .new({ language: @lang, script: @script })
        i18n = iso.i18n_init(@lang, @script, @locale, nil)
        iso.metadata_init(@lang, @script, @locale, i18n)
        iso.info(docxml, nil)
        iso
      end

      def eref_localities1(opt)
        @jcgm and return @iso.eref_localities1(opt)
        super
      end

      def annex1(elem)
        @jcgm and return super
        elem["unnumbered"] == "true" and return
        lbl = @xrefs.anchor(elem["id"], :label)
        t = elem.at(ns("./title")) and
          t.children = "<strong>#{to_xml(t.children)}</strong>"
        prefix_name(elem, ".<tab/>", lbl, "title")
      end

      def clause(docxml)
        quotedtitles(docxml)
        super
        @jcgm and
          docxml.xpath(ns("//preface/introduction[clause]")).each do |f|
            clause1(f)
          end
      end

      def clause1(elem)
        elem.at("./ancestor::*[@unnumbered = 'true']") and
          elem["unnumbered"] = "true"
        super
      end

      def prefix_name(node, delim, number, elem)
        number.nil? || number.empty? and return
        unless name = node.at(ns("./#{elem}[not(@type = 'quoted')]"))
          node.at(ns("./#{elem}[@type = 'quoted']")) and return
          node.add_first_child "<#{elem}></#{elem}>"
          name = node.children.first
        end
        if name.children.empty? then name.add_child(cleanup_entities(number))
        else (name.children.first.previous = "#{number}#{delim}")
        end
      end

      def conversions(docxml)
        doccontrol docxml
        super
      end

      def twitter_cldr_localiser_symbols
        { group: "&#xA0;", fraction_group: "&#xA0;",
          fraction_group_digits: 3 }
      end

      def localize_maths(node, locale)
        super
        node.xpath(".//m:mn", MATHML).each do |x|
          x.children = x.text
            .sub(/^(\d)#{@cldr[:g]}(\d) (?= \d\d$ | \d\d#{@cldr[:d]} )/x,
                 "\\1\\2")
            .sub(/(?<= ^\d\d | #{@cldr[:d]}\d\d ) (\d)#{@cldr[:f]}(\d) $/x,
                 "\\1\\2")
        end
      end

      def mathml1(node, locale)
        unless @cldr
          r = @numfmt.twitter_cldr_reader(locale: locale)
            .transform_values { |v| @c.decode(v) }
          @cldr = {
            g: Regexp.quote(r[:group]),
            f: Regexp.quote(r[:fraction_group]),
            d: Regexp.quote(r[:decimal]),
          }
        end
        super
      end

      def eref(docxml)
        super
        jcgm_eref(docxml, "//eref")
      end

      def origin(docxml)
        super
        jcgm_eref(docxml, "//origin[not(termref)]")
      end

      def quotesource(docxml)
        super
        jcgm_eref(docxml, "//quote//source")
      end

      def jcgm_eref(docxml, xpath)
        @jcgm or return
        docxml.xpath(ns(xpath)).each { |x| extract_brackets(x) }
        # merge adjacent text nodes
        docxml.root.replace(Nokogiri::XML(docxml.root.to_xml).root)
        docxml.xpath(ns(xpath)).each do |x| # rubocop: disable Style/CombinableLoops
          if x.next&.text? && /^\],\s+\[$/.match?(x.next.text) &&
              %w(eref origin source).include?(x.next.next&.name)
            x.next.replace(", ")
          end
        end
      end

      def extract_brackets(node)
        start = node.at("./text()[1]")
        finish = node.at("./text()[last()]")
        (/^\[/.match?(start.text) && /\]$/.match?(finish.text)) or return
        start.replace(start.text[1..-1])
        node.previous = "["
        finish = node.at("./text()[last()]")
        finish.replace(finish.text[0..-2])
        node.next = "]"
      end

      def quotedtitles(docxml)
        docxml.xpath(ns("//variant-title[@type = 'quoted']")).each do |t|
          t.name = "title"
          t.children.first.previous = "<blacksquare/>"
        end
      end

      def termsource1(elem)
        # elem["status"] == "modified" and return super
        while elem&.next_element&.name == "termsource"
          elem << "; #{to_xml(elem.next_element.remove.children)}"
        end
        elem.children = l10n("[#{termsource_adapt(elem['status'])}" \
                             "#{to_xml(elem.children).strip}]")
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
        docxml.xpath("//xmlns:termsource[@status = 'modified']" \
                     "[not(xmlns:modification)]").each do |f|
          f << "<modification/>"
        end
      end

      def termsource_modification(elem)
        # if elem["status"] == "modified"
        # origin = elem.at(ns("./origin"))
        # s = termsource_status(elem["status"]) and origin.next = l10n(", #{s}")
        # end
        termsource_add_modification_text(elem.at(ns("./modification")))
      end

      include Init
    end
  end
end
