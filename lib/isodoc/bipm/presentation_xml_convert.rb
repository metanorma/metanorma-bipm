require "isodoc"
require "metanorma-generic"
require "metanorma-iso"
require_relative "init"
require_relative "presentation_doccontrol"
require_relative "../../relaton/render/general"
require_relative "presentation_blocks"
require_relative "presentation_biblio"
require_relative "presentation_footnotes"

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

      def update_i18n(i18n)
        if %w(2019).include?(@docscheme)
          %w(level2_ancillary level3_ancillary level2_ancillary_alt
             level3_ancillary_alt).each do |w|
            i18n_conditional_set(i18n, w, "#{w}_2019")
          end
        end
        i18n.set("annex", i18n.get["level2_ancillary"])
        i18n.set("appendix", i18n.get["level3_ancillary"])
      end

      def convert_i18n_init(docxml)
        @docscheme =
          docxml.at(ns("//presentation-metadata[name" \
                       "[text() = 'document-scheme']]/value"))&.text || "2021"
        super
        update_i18n(@i18n)
      end

      def i18n_conditional_set(i18n, old, new)
        i18n.get[new] or return
        i18n.set(old, i18n.get[new])
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
        # quotedtitles(docxml)
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
        if elem == "title" &&
            n = node.at(ns("./variant-#{elem}[@type = 'quoted']"))
          quoted_title_render(node, elem, n)
        else
          super
        end
      end

      def quoted_title_render(node, elem, variant_title)
        add_id(variant_title)
        variant_title.next =
          fmt_caption("&#x2580;", elem, variant_title, {}, {})
        if s = variant_title.next.at(ns("./semx[@element='title']"))
          s["source"] = variant_title["id"]
        end
        # to prevent it rendering, as Semantic XML element
        variant_title.name = "title"
        prefix_name_postprocess(node, elem)
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

      def enable_indexsect
        true
      end

      def index1(docxml, indexsect, index)
        index.keys.sort.each do |k|
          c = indexsect
            .add_child "<clause #{add_id_text}><title #{add_id_text}>#{k}</title><ul></ul></clause>"
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

      include Init
    end
  end
end
