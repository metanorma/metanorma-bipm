require "isodoc"
require "metanorma-generic"
require "metanorma-iso"
require_relative "init"
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

      def annex_delim(elem)
        @jcgm and return super
        ".<tab/>"
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

      def prefix_name(node, delims, number, elem)
        if n = node.at(ns("./#{elem}[@type = 'quoted']"))
          n1 = n.dup
          n1.name = "fmt-#{elem}"
          n.next = n1
          prefix_name_postprocess(node, elem)
        else
          super
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
        jcgm_eref(docxml, "//fmt-eref")
      end

      def origin(docxml)
        super
        jcgm_eref(docxml, "//fmt-origin[not(.//termref)]")
      end

      # KILL
      def quotesourcex(docxml)
        super
        jcgm_eref(docxml, "//quote//source")
      end

      def jcgm_eref(docxml, xpath)
        @jcgm or return
        docxml.xpath(ns(xpath)).each { |x| extract_brackets(x) }
        # merge adjacent text nodes
        docxml.root.replace(Nokogiri::XML(docxml.root.to_xml).root)
        docxml.xpath(ns(xpath)).each do |x| # rubocop: disable Style/CombinableLoops
          if x.parent.next&.text? && /^\],\s+\[$/.match?(x.parent.next.text) &&
              %w(eref origin fmt-eref
                 fmt-origin).include?(x.parent.next.next&.name)
            x.parent.next.replace(", ")
          end
        end
      end

      def extract_brackets(node)
        start = node.at("./text()[1]")
        finish = node.at("./text()[last()]")
        (/^\[/.match?(start&.text) && /\]$/.match?(finish&.text)) or return
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

      # KILL
      def termsource1_xx(elem)
        # elem["status"] == "modified" and return super
        while elem&.next_element&.name == "termsource"
          elem << "; #{to_xml(elem.next_element.remove.children)}"
        end
        elem.children = l10n("[#{termsource_adapt(elem['status'])}" \
                             "#{to_xml(elem.children).strip}]")
      end

      def termsource_label(elem, sources)
        elem.replace(l10n("[#{termsource_adapt(elem['status'])} #{sources}]"))
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

      def enable_indexsect
        true
      end

      def index1(docxml, indexsect, index)
        index.keys.sort.each do |k|
          c = indexsect.add_child "<clause #{add_id}><title>#{k}</title><ul></ul></clause>"
          words = index[k].keys.each_with_object({}) do |w, v|
            v[sortable(w).downcase] = w
          end
          words.keys.localize(@lang.to_sym).sort.to_a.each do |w|
            c.first.at(ns("./ul")).add_child index_entries(words, index[k], w)
          end
        end
        docxml.xpath(ns("//indexsect//xref")).each { |x| x.children.remove }
        @xrefs.bookmark_anchor_names(docxml)
      end

      def fn_label_brackets(fnote)
        "<sup><span class='fmt-label-delim'>(</span>" \
        "#{fn_label(fnote)}" \
          "<span class='fmt-label-delim'>)</span></sup>"
      end

      def fn_ref_label(fnote)
        if @jcgm then iso_fn_ref_label(fnote)
        else fn_label_brackets(fnote)
        end
      end

      # copied from ISO
      def iso_fn_ref_label(fnote)
        if fnote.ancestors("table, figure").empty? ||
            !fnote.ancestors("name, fmt-name").empty?
          "<sup>#{fn_label(fnote)}" \
            "<span class='fmt-label-delim'>)</span></sup>"
        else
          super
        end
      end

      def fn_body_label(fnote)
        if @jcgm then super
        else fn_label_brackets(fnote)
        end
      end

      include Init
    end
  end
end
