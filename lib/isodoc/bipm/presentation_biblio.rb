module IsoDoc
  module Bipm
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def bibdata_i18n(bibdata)
        super
        bibdata_dates(bibdata)
        bibdata_titles(bibdata)
      end

      def bibdata_dates(bibdata)
        pubdate = bibdata.at(ns("./date[not(@format)][@type = 'published']"))
        pubdate or return
        meta = metadata_init(@lang, @script, @locale, @i18n)
        pubdate.next = pubdate.dup
        pubdate.next["format"] = "ddMMMyyyy"
        pubdate.next.children = meta.monthyr(pubdate.text)
      end

      def bibdata_titles(bibdata)
        app = bibdata.at(ns("//bibdata/ext/" \
                            "structuredidentifier/part")) or return
        bibdata.xpath(ns("//bibdata/title[@type = 'title-part']")).each do |t|
          t.previous = t.dup
          t["type"] = "title-part-with-numbering"
          part = t["language"] == "en" ? "Part" : "Partie" # not looking up in YAML
          t.children = l10n("#{part} #{app.text}: #{to_xml(t.children)}",
                            t["language"])
        end
      end

      def norm_ref_entry_code(_ordinal, identifiers, _ids, _standard, datefn,
_bib)
        ret = identifiers[0] || identifiers[1]
        ret += " #{identifiers[1]}" if identifiers[0] && identifiers[1]
        "#{ret}#{datefn} "
      end

      def biblio_ref_entry_code(ordinal, ids, _id, _standard, datefn, _bib)
        # standard and id = nil
        ret = ids[:ordinal] || ids[:metanorma] || "[#{ordinal}]"
        if ids[:sdo]
          ret = prefix_bracketed_ref(ret)
          ret += "#{ids[:sdo]}#{datefn} "
        else
          ret = prefix_bracketed_ref("#{ret}#{datefn}")
        end
        ret
      end

      def implicit_reference(bib)
        b = bib.at(ns("./docidentifier[@primary = 'true'][@type = 'BIPM']"))
        return true if @doctype == "brochure" && /^(CGPM|CIPM|CCDS|CCTF)[  ]
        (Resolution|Recommendation|Declaration|Decision|Recommendation|Meeting)/x
          .match?(b&.text)

        super
      end

      def omit_docid_prefix(prefix)
        %w(BIPM BIPM-long).include? prefix and return true
        super
      end

      def render_identifier(ident)
        ret = super
        ret[:sdo] = ret[:sdo]&.sub(/^(BIPM)([  ])(PV|CR)([  ])(\d.*)$/,
                                   "\\1\\2<strong>\\3</strong>,\\4\\5")
        ret
      end
    end
  end
end
