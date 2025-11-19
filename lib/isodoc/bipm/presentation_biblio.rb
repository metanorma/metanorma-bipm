module IsoDoc
  module Bipm
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def bibdata_i18n(bibdata)
        super
        bibdata_id(bibdata)
        bibdata_dates(bibdata)
        bibdata_titles(bibdata)
        bibdata_depictions(bibdata)
      end

      def bibdata_depictions(bibdata)
        s = bibdata.at(ns("./ext/si-aspect"))&.text or return
        ins = bibdata.at(ns("./ext"))
        name = "si-circle-constants_#{s}.svg"
        s.start_with?("units") and name = "si-circle-#{s}.svg"
        file = svg_load("si-aspect", name) or return
        ins.previous = <<~XML
          <depiction type='si-aspect'><image src="" mimetype="image/svg+xml">#{file}</image></depiction>
        XML
      end

      def svg_load(directory, filename)
        dir = File.join(File.dirname(__FILE__), "html", directory)
        filename = File.join(dir, filename)
        File.exist?(filename) or return
        file = File.read(filename) or return
        file.sub(
          '<?xml version="1.0" encoding="UTF-8"?>', ""
        )
      end

      def bibdata_id(bibdata)
        id = bibdata.at(ns("./docidentifier[@type = 'BIPM-parent-document']")) or
          return
        parts = %w(appendix annexid part subpart).each_with_object([]) do |w, m|
          dn = bibdata.at(ns("./ext/structuredidentifier/#{w}"))
          m << dn&.text
        end
        id.next = bibdata_id1(@lang, id.dup, parts, false)
        id.next = bibdata_id1(@lang == "en" ? "fr" : "en", id.dup, parts, true)
      end

      def bibdata_id1(lang, id, parts, alt)
        id["type"] = "BIPM"
        id["language"] = lang
        m = []
        parts.each_with_index do |p, i|
          p.nil? and next
          lbl = @i18n.get["level#{i + 2}_ancillary#{alt ? '_alt' : ''}"]
          m << "#{lbl} #{p}"
        end
        id.children = "#{id.text} #{m.join(' ')}"
        id
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
        app = bibdata.at(ns("//bibdata/ext/structuredidentifier/part")) or
          return
        bibdata_part_titles(bibdata, app.text.sub(/\.\d+/, ""))
        bibdata_subpart_titles(bibdata, app.text.sub(/\d+\./, ""))
      end

      def bibdata_part_titles(bibdata, num)
        bibdata.xpath(ns("//bibdata/title[@type = 'title-part']")).each do |t|
          t.previous = t.dup
          t["type"] = "title-part-with-numbering"
          alt = t["language"] == @lang ? "" : "_alt"
          t.children = l10n("#{@i18n.get["level4_ancillary#{alt}"]} #{num}: #{to_xml(t.children)}",
                            t["language"])
        end
      end

      def bibdata_subpart_titles(bibdata, num)
        bibdata.xpath(ns("//bibdata/title[@type = 'title-subpart']")).each do |t|
          t.previous = t.dup
          t["type"] = "title-subpart-with-numbering"
          alt = t["language"] == @lang ? "" : "_alt"
          t.children = l10n("#{@i18n.get["level5_ancillary#{alt}"]} #{num}: #{to_xml(t.children)}",
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

      def wrap_brackets(txt)
        /^\[.*\]$/.match?(txt) ? txt : "[#{txt}]"
      end

      def reference_name(ref)
        super
        @jcgm and @xrefs.get[ref["id"]][:xref] =
                    wrap_brackets(@xrefs.get[ref["id"]][:xref])
      end
    end
  end
end
