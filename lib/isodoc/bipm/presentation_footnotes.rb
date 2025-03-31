module IsoDoc
  module Bipm
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
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
          "<sup>#{fn_label(fnote)}</sup>"
        end
      end

      def fn_body_label(fnote)
        if @jcgm then super
        else fn_label_brackets(fnote)
        end
      end

      # explode out all the subclauses into separate entries
      # assume no hanging clauses
      def sort_footnote_sections(docxml)
        ret = super
        ret.flat_map do |x|
          explode_subclauses(x)
        end
      end

      def explode_subclauses(clause)
        clause.at(ns(".//clause")) or return [clause]
        (clause.xpath(ns(".//clause")) - clause.xpath(ns(".//clause//clause")))
          .map { |x| explode_subclauses(x) }
          .flatten.unshift(clause)
      end

      # quote/table/fn references are not unique within quote
      # if there are multiple tables
      def renumber_document_footnote_key(fnote)
        key = fnote["reference"]
        !@jcgm && (t = fnote.at("./ancestor::xmlns:table")) and
          key = "#{t['id']} #{key}"
        key
      end

      def renumber_document_footnote(fnote, idx, seen)
        fnote["original-reference"] = fnote["reference"]
        key = renumber_document_footnote_key(fnote)
        if seen[key]
          fnote["reference"] = seen[fnote["reference"]]
        else
          seen[key] = idx
          fnote["reference"] = idx
          idx += 1
        end
        idx
      end

      def document_footnotes(docxml)
        @jcgm and return super
        sects = sort_footnote_sections(docxml)
        excl = non_document_footnotes(docxml)
        fns = filter_document_footnotes(sects, excl)
        sects.each_with_index do |s, i|
          ret = footnote_collect(renumber_document_footnotes(fns[i], 1))
          f = footnote_container(fns[i], ret) and s << f
        end
      end

      def filter_document_footnotes(sects, excl)
        sects.each_with_object([]) do |s, m|
          docfns = s.xpath(ns(".//fn")) - excl - s.xpath(ns(".//clause//fn"))
          m << docfns
        end
      end

      def renumber_document_footnotes(fns, idx)
        @jcgm and return super
        fns.each_with_object({}) do |f, seen|
          idx = renumber_document_footnote(f, idx, seen)
        end
        fns
      end

      def table_fn(elem)
        !@jcgm && !elem.ancestors("quote").empty? and return
        super
      end

      def non_document_footnotes(docxml)
        table_fns = docxml.xpath(ns("//table//fn")) -
          docxml.xpath(ns("//table/name//fn"))
        @jcgm or table_fns -= docxml.xpath(ns("//quote//table//fn"))
        fig_fns = docxml.xpath(ns("//figure//fn")) -
          docxml.xpath(ns("//figure/name//fn"))
        table_fns + fig_fns
      end
    end
  end
end
