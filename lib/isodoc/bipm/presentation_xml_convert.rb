require "isodoc"
require "metanorma-generic"
require "metanorma-iso"
require_relative "init"
require_relative "index"
require_relative "doccontrol"
require_relative "../../relaton/render/general"

module IsoDoc
  module BIPM
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def convert1(docxml, filename, dir)
        @jcgm = docxml&.at(ns("//bibdata/ext/editorialgroup/committee/" \
                              "@acronym"))&.value == "JCGM"
        @iso = IsoDoc::Iso::PresentationXMLConvert
          .new({ language: @lang, script: @script })
        i18n = @iso.i18n_init(@lang, @script, @locale, nil)
        @iso.metadata_init(@lang, @script, @locale, i18n)
        super
      end

      def eref_localities1(opt)
        @jcgm and return @iso.eref_localities1(opt)
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

      def localized_number(num, locale, precision)
        g = Regexp.quote(twitter_cldr_localiser_symbols[:group])
        f = Regexp.quote(twitter_cldr_localiser_symbols[:fraction_group])
        super.sub(/^(\d)#{g}(\d)/, "\\1\\2").sub(/(\d)#{f}(\d)$/, "\\1\\2")
      end

      def mathml1(elem, locale)
        asciimath_dup(elem)
        localize_maths(elem, locale)
      end

      def bibdata_i18n(bibdata)
        super
        bibdata_dates(bibdata)
        bibdata_titles(bibdata)
      end

      def bibdata_dates(bibdata)
        pubdate = bibdata.at(ns("./date[not(@format)][@type = 'published']"))
        return unless pubdate

        meta = metadata_init(@lang, @script, @locale, @i18n)
        pubdate.next = pubdate.dup
        pubdate.next["format"] = "ddMMMyyyy"
        pubdate.next.children = meta.monthyr(pubdate.text)
      end

      def bibdata_titles(bibdata)
        app = bibdata.at(ns("//bibdata/ext/" \
                            "structuredidentifier/part")) or return
        bibdata.xpath(ns("//bibdata/title[@type = 'part']")).each do |t|
          t.previous = t.dup
          t["type"] = "part-with-numbering"
          part = t["language"] == "en" ? "Part" : "Partie" # not looking up in YAML
          t.children = l10n("#{part} #{app.text}: #{to_xml(t.children)}",
                            t["language"])
        end
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
        if elem["status"] == "modified"
          origin = elem.at(ns("./origin"))
          # s = termsource_status(elem["status"]) and origin.next = l10n(", #{s}")
        end
        termsource_add_modification_text(elem.at(ns("./modification")))
      end

      def norm_ref_entry_code(_ordinal, identifiers, _ids, _standard, datefn,
_bib)
        ret = (identifiers[0] || identifiers[1])
        ret += " #{identifiers[1]}" if identifiers[0] && identifiers[1]
        "#{ret}#{datefn} "
      end

      def biblio_ref_entry_code(ordinal, ids, _id, _standard, datefn, _bib)
        # standard and id = nil
        ret = (ids[:ordinal] || ids[:metanorma] || "[#{ordinal}]")
        if ids[:sdo]
          ret = prefix_bracketed_ref(ret)
          ret += "#{ids[:sdo]}#{datefn} "
        else
          ret = prefix_bracketed_ref("#{ret}#{datefn}")
        end
        ret
      end

      def bibrenderer
        ::Relaton::Render::BIPM::General.new(language: @lang)
      end

      include Init
    end
  end
end
