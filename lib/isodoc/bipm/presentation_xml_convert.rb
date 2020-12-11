require "isodoc"
require "metanorma-generic"
require "twitter_cldr"
require "sterile"
require_relative "init"

module IsoDoc
  module BIPM
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def section(docxml)
        super
        index(docxml)
      end

       def add_id
        %(id="_#{UUIDTools::UUID.random_create}")
      end

      def index(docxml)
        return unless docxml.at(ns("//index"))
        i = docxml.root.add_child "<clause type='index' #{add_id}><title>#{@i18n.index}</title></clause>"
        index = sort_indexterms(docxml.xpath(ns("//index")))
        index.keys.sort.each do |k|
          c = i.first.add_child "<clause #{add_id}><title>#{k}</title><ul></ul></clause>"
          words = index[k].keys.each_with_object({}) { |w, v| v[w.downcase] = w }
          words.keys.localize(@lang.to_sym).sort.to_a.each do |w|
            c.first.at(ns("./ul")).add_child index_entries(words, index[k], w)
          end
        end
        @xrefs.bookmark_anchor_names(docxml.xpath(ns(@xrefs.sections_xpath)))
      end

      def index_entries(words, index, primary)
        ret = index_entries_head(words[primary], index.dig(words[primary], nil, nil))
        words2 = index[words[primary]]&.keys&.reject { |k| k.nil?}&.each_with_object({}) { |w, v| v[w.downcase] = w }
        unless words2.empty?
          ret += "<ul>"
          words2.keys.localize(@lang.to_sym).sort.to_a.each do |w|
            ret += index_entries2(words2, index[words[primary]], w)
          end
          ret += "</ul>"
        end
        ret + "</li>"
      end

      def index_entries2(words, index, secondary)
        ret = index_entries_head(words[secondary], index.dig(words[secondary], nil))
        words3 = index[words[secondary]]&.keys&.reject { |k| k.nil?}&.each_with_object({}) { |w, v| v[w.downcase] = w }
        unless words3.empty?
          ret += "<ul>"
          words3.keys.localize(@lang.to_sym).sort.to_a.each do |w|
            ret += (index_entries_head(words3[w], index[words[secondary]][words3[w]]) + "</li>")
          end
          ret += "</ul>"
        end
        ret + "</li>"
      end

      def index_entries_head(head, entries)
        ret = "<li>#{head}"
        e1 = entries&.join(", ")
        (e1.nil? || e1.empty?) ? ret : ret + ", #{e1}"
      end

      def sort_indexterms(terms)
        index = extract_indexterms(terms)
        index.keys.sort.each_with_object({}) do |k, v|
          v[k[0].upcase.transliterate] ||= {}
          v[k[0].upcase.transliterate][k] = index[k]
        end
      end

      def extract_indexterms(terms)
        terms.each_with_object({}) do |t, v|
          term = t["primary"]
          term2 = t["secondary"]
          term3 = t["tertiary"]
          index2bookmark(t)
          v[term] ||= {}
          v[term][term2] ||= {}
          v[term][term2][term3] ||= []
          v[term][term2][term3] << "<xref target='#{t['id']}' pagenumber='true'/>"
        end
      end

      def index2bookmark(t)
        t.name = "bookmark"
        t.delete("primary")
        t.delete("secondary")
        t.delete("tertiary")
        t["id"] = "_#{UUIDTools::UUID.random_create}"
      end

      def table1(f)
        return if labelled_ancestor(f)
        return if f["unnumbered"] && !f.at(ns("./name"))
        n = @xrefs.anchor(f['id'], :label, false)
        prefix_name(f, ".<tab/>", l10n("#{@i18n.table.capitalize} #{n}"), "name")
      end

      def annex1(f)
        return if f["unnumbered"] == "true"
        lbl = @xrefs.anchor(f['id'], :label)
        if t = f.at(ns("./title"))
          t.children = "<strong>#{t.children.to_xml}</strong>"
        end
        prefix_name(f, ".<tab/>", lbl, "title")
      end

      def clause1(f)
        return if f["unnumbered"] == "true"
        return if f.at(("./ancestor::*[@unnumbered = 'true']"))
        super
      end

      def conversions(docxml)
        super
        doccontrol docxml
      end

      def doccontrol docxml
        return unless docxml.at(ns("//bibdata/relation[@type = 'supersedes']"))
        clause = <<~END
        <doccontrol>
        <title>Document Control</title>
        <table unnumbered="true"><tbody>
        <tr><td>Authors:</td><td/><td>#{list_authors(docxml)}</td></tr>
        <tr>#{list_draft(docxml, 1)&.map { |x| "<td>#{x}</td>" }&.join }
        <td>#{list_cochairs(docxml)}</td></tr>
        <tr>#{list_draft(docxml, 2)&.map { |x| "<td>#{x}</td>" }&.join }
        <td>#{list_chairs(docxml)}</td></tr>
        #{list_drafts(docxml)}
        </tbody></table></doccontrol>
        END
        docxml.root << clause
      end

      def list_drafts(xml)
        ret = ""
        i = 3
        while a = list_draft(xml, i)
          ret += "<tr>#{list_draft(xml, i).map { |x| "<td>#{x}</td>" }.join }"\
            "<td/></tr>"
          i += 1
        end
        ret
      end

      def list_draft(xml, i)
        return unless d =
          xml.at(ns("//bibdata/relation[@type = 'supersedes'][#{i}]/bibitem"))
        date = d&.at(ns("./date"))&.text
        draft = d&.at(ns("./version/draft"))&.text and
          draft = "Draft #{draft}"
        edn = d&.at(ns("./edition"))&.text and
          edn = "Edition #{edn}"
        [date, [draft, edn].join(" ")]
      end

      def list_authors(xml)
        ret = list_people(
          xml, "//bibdata/contributor[xmlns:role/@type = 'author']/person")
        @i18n.multiple_and(ret, @i18n.get["and"])
      end

      COCHAIR = "xmlns:role[contains(text(),'co-chair')]".freeze
      CHAIR = "[xmlns:role[contains(text(),'chair')]"\
        "[not(contains(text(),'co-chair'))]]".freeze

      def list_cochairs(xml)
        ret = list_people(xml, "//bibdata/contributor[#{COCHAIR}]/person")
        role = xml&.at(ns("//bibdata/contributor[#{COCHAIR}]/role"))&.text
        label = ret.size > 1 && role ? "#{role}s" : role
        "#{label}: #{@i18n.multiple_and(ret, @i18n.get["and"])}"
      end

      def list_chairs(xml)
        ret = list_people(xml, "//bibdata/contributor#{CHAIR}/person")
        role = xml&.at(ns("//bibdata/contributor#{CHAIR}/role"))&.text
        label = ret.size > 1 && role ? "#{role}s" : role
        "#{label}: #{@i18n.multiple_and(ret, @i18n.get["and"])}"
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
        { group: "&#x202F;", fraction_group: "&#x202F;", fraction_group_digits: 3 }
      end

      def mathml1(f, locale)
        localize_maths(f, locale)
      end

      include Init
    end
  end
end
