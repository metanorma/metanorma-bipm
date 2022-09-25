require "isodoc"
require "metanorma-generic"
require "metanorma-iso"
require_relative "init"
require_relative "index"
require_relative "doccontrol"

module IsoDoc
  module BIPM
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def convert1(docxml, filename, dir)
        @jcgm = docxml&.at(ns("//bibdata/ext/editorialgroup/committee/"\
                              "@acronym"))&.value == "JCGM"
        @iso = IsoDoc::Iso::PresentationXMLConvert
          .new({ language: @lang, script: @script })
        i18n = @iso.i18n_init(@lang, @script, nil)
        @iso.metadata_init(@lang, @script, i18n)
        super
      end

      def eref_localities1(target, type, from, upto, node, lang = "en")
        @jcgm and return @iso.eref_localities1(target, type, from, upto,
                                               node, lang)
        super
      end

      def table1(elem)
        return if labelled_ancestor(elem) || elem["unnumbered"]

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

      def annex1(elem)
        return super if @jcgm
        return if elem["unnumbered"] == "true"

        lbl = @xrefs.anchor(elem["id"], :label)
        t = elem.at(ns("./title")) and
          t.children = "<strong>#{t.children.to_xml}</strong>"
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
        elem.at(("./ancestor::*[@unnumbered = 'true']")) and
          elem["unnumbered"] = "true"

        super
      end

      def prefix_name(node, delim, number, elem)
        return if number.nil? || number.empty?

        unless name = node.at(ns("./#{elem}[not(@type = 'quoted')]"))
          return if node.at(ns("./#{elem}[@type = 'quoted']"))

          (node.children.empty? and node.add_child("<#{elem}></#{elem}>")) or
            node.children.first.previous = "<#{elem}></#{elem}>"
          name = node.children.first
        end
        if name.children.empty? then name.add_child(cleanup_entities(number))
        else (name.children.first.previous = "#{number}#{delim}")
        end
      end

      def conversions(docxml)
        super
        doccontrol docxml
      end

      def twitter_cldr_localiser_symbols
        { group: "&#xA0;", fraction_group: "&#xA0;", fraction_group_digits: 3 }
      end

      def mathml1(elem, locale)
        asciimath_dup(elem)
        localize_maths(elem, locale)
      end

      def bibdata_i18n(bibdata)
        super
        bibdata_dates(bibdata)
      end

      def bibdata_dates(bibdata)
        pubdate = bibdata.at(ns("./date[not(@format)][@type = 'published']"))
        return unless pubdate

        meta = metadata_init(@lang, @script, @i18n)
        pubdate.next = pubdate.dup
        pubdate.next["format"] = "ddMMMyyyy"
        pubdate.next.children = meta.monthyr(pubdate.text)
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
        jcgm_eref(docxml, "//quote/source")
      end

      def jcgm_eref(docxml, xpath)
        return unless @jcgm

        docxml.xpath(ns(xpath)).each { |x| extract_brackets(x) }
        # merge adjacent text nodes
        docxml.root.replace(Nokogiri::XML(docxml.root.to_xml).root)
        docxml.xpath(ns(xpath)).each do |x| # rubocop: disable Style/CombinableLoops
          if x&.next&.text? && /^\],\s+\[$/.match?(x&.next&.text) &&
              %w(eref origin source).include?(x&.next&.next&.name)
            x.next.replace(", ")
          end
        end
      end

      def extract_brackets(node)
        start = node.at("./text()[1]")
        finish = node.at("./text()[last()]")
        if /^\[/.match?(start.text) && /\]$/.match?(finish.text)
          start.replace(start.text[1..-1])
          node.previous = "["
          finish = node.at("./text()[last()]")
          finish.replace(finish.text[0..-2])
          node.next = "]"
        end
      end

      def quotedtitles(docxml)
        docxml.xpath(ns("//variant-title[@type = 'quoted']")).each do |t|
          t.name = "title"
          t.children.first.previous = "<blacksquare/>"
        end
      end

      # notes and remarques (list notes) are not numbered
      def note1(elem)
        return if elem.parent.name == "bibitem" || elem["notag"] == "true"

        #n = @xrefs.get[elem["id"]]
        lbl = note_label(elem)
        #(n.nil? || n[:label].nil? || n[:label].empty?) or
        #  lbl = l10n("#{lbl} #{n[:label]}")
        prefix_name(elem, "", lbl, "name")
      end

      def note_label(elem)
        label = @i18n.note
        elem.ancestors("preface").empty? &&
          !elem.ancestors("ul, ol, dl").empty? and
          label = @i18n.listnote
        label
      end

      def termsource1(elem)
        while elem&.next_element&.name == "termsource"
          elem << "; #{elem.next_element.remove.children.to_xml}"
        end
        elem.children = l10n("[#{@i18n.source} #{elem.children.to_xml.strip}]")
      end

      include Init
    end
  end
end
