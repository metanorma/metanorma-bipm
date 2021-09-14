require "isodoc"
require "metanorma-generic"
require "metanorma-iso"
require_relative "init"
require_relative "index"

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

      def eref_localities1(target, type, from, to, delim, n, lang = "en")
        @jcgm and
          return @iso.eref_localities1(target, type, from, to, delim, n, lang)
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
        return if elem["unnumbered"] == "true"
        return if elem.at(("./ancestor::*[@unnumbered = 'true']"))

        super
      end

      def prefix_name(node, delim, number, elem)
        return if number.nil? || number.empty?

        unless name = node.at(ns("./#{elem}[not(@type = 'quoted')]"))
          return if node.at(ns("./#{elem}[@type = 'quoted']"))

          node.children.empty? and node.add_child("<#{elem}></#{elem}>") or
            node.children.first.previous = "<#{elem}></#{elem}>"
          name = node.children.first
        end
        if name.children.empty? then name.add_child(number)
        else (name.children.first.previous = "#{number}#{delim}")
        end
      end

      def conversions(docxml)
        super
        doccontrol docxml
      end

      def doccontrol(doc)
        return unless doc.at(ns("//bibdata/relation[@type = 'supersedes']"))

        clause = <<~DOCCONTROL
          <doccontrol>
          <title>Document Control</title>
          <table unnumbered="true"><tbody>
          <tr><th>Authors:</th><td/><td>#{list_authors(doc)}</td></tr>
          #{doccontrol_row1(doc)} #{doccontrol_row2(doc)} #{list_drafts(doc)}
          </tbody></table></doccontrol>
        DOCCONTROL
        doc.root << clause
      end

      def doccontrol_row1(doc)
        return "" if list_draft(doc, 1) == ["", ""] && list_cochairs(doc).empty?

        <<~ROW
          <tr>#{list_draft(doc, 1)&.map { |x| "<td>#{x}</td>" }&.join}
          <td>#{list_cochairs(doc)}</td></tr>
        ROW
      end

      def doccontrol_row2(docxml)
        list_draft(docxml, 2) == ["", ""] && list_chairs(docxml).empty? and
          return ""

        <<~ROW
          <tr>#{list_draft(docxml, 2)&.map { |x| "<td>#{x}</td>" }&.join}
          <td>#{list_chairs(docxml)}</td></tr>
        ROW
      end

      def list_drafts(xml)
        ret = ""
        i = 3
        while list_draft(xml, i) != ["", ""]
          ret += "<tr>#{list_draft(xml, i).map { |x| "<td>#{x}</td>" }.join} "\
                 "<td/></tr>"
          i += 1
        end
        ret
      end

      def list_draft(xml, idx)
        d = xml.at(ns("//bibdata/relation[@type = 'supersedes'][#{idx}]"\
                      "/bibitem")) or return ["", ""]

        draft = d&.at(ns("./version/draft"))&.text and draft = "Draft #{draft}"
        edn = d&.at(ns("./edition"))&.text and edn = "Version #{edn}"
        [[draft, edn].join(" "), d&.at(ns("./date"))&.text]
      end

      def list_authors(xml)
        ret = list_people(
          xml, "//bibdata/contributor[xmlns:role/@type = 'author']/person"
        )
        @i18n.multiple_and(ret, @i18n.get["and"])
      end

      COCHAIR = "xmlns:role[contains(text(),'co-chair')]".freeze
      CHAIR = "[xmlns:role[contains(text(),'chair')]"\
              "[not(contains(text(),'co-chair'))]]".freeze

      def list_cochairs(xml)
        ret = list_people(xml, "//bibdata/contributor[#{COCHAIR}]/person")
        ret.empty? and return ""
        role = xml&.at(ns("//bibdata/contributor[#{COCHAIR}]/role"))&.text
        label = ret.size > 1 && role ? "#{role}s" : role
        "#{label}: #{@i18n.multiple_and(ret, @i18n.get['and'])}"
      end

      def list_chairs(xml)
        ret = list_people(xml, "//bibdata/contributor#{CHAIR}/person")
        ret.empty? and return ""
        role = xml&.at(ns("//bibdata/contributor#{CHAIR}/role"))&.text
        label = ret.size > 1 && role ? "#{role}s" : role
        "#{label}: #{@i18n.multiple_and(ret, @i18n.get['and'])}"
      end

      def list_people(xml, xpath)
        ret = []
        xml.xpath(ns(xpath)).each do |p|
          name = p&.at(ns("./name/completename"))&.text
          aff = p&.at(ns("./affiliation/organization/abbreviation"))&.text ||
            p&.at(ns("./affiliation/organization/name"))&.text
          c = name || ""
          aff and c += " (#{aff})"
          ret << c
        end
        ret
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

      include Init
    end
  end
end
