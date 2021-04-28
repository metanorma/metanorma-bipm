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
        if @jcgm
          @iso.eref_localities1(target, type, from, to, delim, n, lang)
        else
          super
        end
      end

      def table1(elem)
        return if labelled_ancestor(elem)
        return if elem["unnumbered"]

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
        if t = elem.at(ns("./title"))
          t.children = "<strong>#{t.children.to_xml}</strong>"
        end
        prefix_name(elem, ".<tab/>", lbl, "title")
      end

      def clause(docxml)
        super
        if @jcgm
          docxml.xpath(ns("//preface/introduction[clause]")).each do |f|
            clause1(f)
          end
        end
      end

      def clause1(elem)
        return if elem["unnumbered"] == "true"
        return if elem.at(("./ancestor::*[@unnumbered = 'true']"))

        super
      end

      def conversions(docxml)
        super
        doccontrol docxml
      end

      def doccontrol(doc)
        return unless doc.at(ns("//bibdata/relation[@type = 'supersedes']"))

        clause = <<~END
          <doccontrol>
          <title>Document Control</title>
          <table unnumbered="true"><tbody>
          <tr><th>Authors:</th><td/><td>#{list_authors(doc)}</td></tr>
        #{doccontrol_row1(doc)} #{doccontrol_row2(doc)} #{list_drafts(doc)}
          </tbody></table></doccontrol>
        END
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

        date = d&.at(ns("./date"))&.text
        draft = d&.at(ns("./version/draft"))&.text and draft = "Draft #{draft}"
        edn = d&.at(ns("./edition"))&.text and edn = "Version #{edn}"
        [[draft, edn].join(" "), date]
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
        { group: "&#x202F;", fraction_group: "&#x202F;",
          fraction_group_digits: 3 }
      end

      def mathml1(elem, locale)
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

      include Init
    end
  end
end
