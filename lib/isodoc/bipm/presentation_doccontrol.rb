module IsoDoc
  module Bipm
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def doccontrol(doc)
        doc.at(ns("//bibdata/relation[@type = 'supersedes']")) or return
        clause = <<~DOCCONTROL
          <clause class="doccontrol" #{add_id_text}>
          <fmt-title #{add_id_text}>Document Control</fmt-title>
          <table #{add_id_text} unnumbered="true"><tbody>
          <tr #{add_id_text}><th #{add_id_text}>Authors:</th><td #{add_id_text}/><td #{add_id_text}>#{list_authors(doc)}</td></tr>
          #{doccontrol_row1(doc)} #{doccontrol_row2(doc)} #{list_drafts(doc)}
          </tbody></table></clause>
        DOCCONTROL
        ins = doc.root.at(ns("./colophon")) ||
          doc.root.add_child("<colophon/>").first
        ins << clause
      end

      def doccontrol_row1(doc)
        return "" if list_draft(doc,
                                1) == ["", ""] && list_cochairs(doc).empty?

        <<~ROW
          <tr #{add_id_text}>#{list_draft(doc, 1)&.map { |x| "<td #{add_id_text}>#{x}</td>" }&.join}
          <td #{add_id_text}>#{list_cochairs(doc)}</td></tr>
        ROW
      end

      def doccontrol_row2(docxml)
        list_draft(docxml, 2) == ["", ""] && list_chairs(docxml).empty? and
          return ""

        <<~ROW
          <tr #{add_id_text}>#{list_draft(docxml, 2)&.map { |x| "<td>#{x}</td>" }&.join}
          <td #{add_id_text}>#{list_chairs(docxml)}</td></tr>
        ROW
      end

      def list_drafts(xml)
        ret = ""
        i = 3
        while list_draft(xml, i) != ["", ""]
          ret += "<tr #{add_id_text}>#{list_draft(xml, i).map do |x|
            "<td #{add_id_text}>#{x}</td>"
          end.join} " \
                 "<td/></tr>"
          i += 1
        end
        ret
      end

      def list_draft(xml, idx)
        d = xml.at(ns("//bibdata/relation[@type = 'supersedes'][#{idx}]" \
                      "/bibitem")) or return ["", ""]
        draft = d.at(ns("./version/draft"))&.text and draft = "Draft #{draft}"
        edn = d.at(ns("./edition"))&.text and edn = "Version #{edn}"
        [[draft, edn].join(" "), d.at(ns("./date"))&.text]
      end

      def list_authors(xml)
        ret = list_people(
          xml, "//bibdata/contributor[xmlns:role/@type = 'author']/person"
        )
        connectives_spans(@i18n.boolean_conj(ret, "and"))
      end

      COCHAIR = "xmlns:role[contains(text(),'co-chair')]".freeze
      CHAIR = "[xmlns:role[contains(text(),'chair')]" \
              "[not(contains(text(),'co-chair'))]]".freeze

      def list_cochairs(xml)
        ret = list_people(xml, "//bibdata/contributor[#{COCHAIR}]/person")
        ret.empty? and return ""
        role = xml&.at(ns("//bibdata/contributor[#{COCHAIR}]/role"))&.text
        label = ret.size > 1 && role ? "#{role}s" : role
        "#{label}: #{connectives_spans(@i18n.boolean_conj(ret, 'and'))}"
      end

      def list_chairs(xml)
        ret = list_people(xml, "//bibdata/contributor#{CHAIR}/person")
        ret.empty? and return ""
        role = xml&.at(ns("//bibdata/contributor#{CHAIR}/role"))&.text
        label = ret.size > 1 && role ? "#{role}s" : role
        "#{label}: #{connectives_spans(@i18n.boolean_conj(ret, 'and'))}"
      end

      def list_people(xml, xpath)
        ret = []
        xml.xpath(ns(xpath)).each do |p|
          name = p.at(ns("./name/completename"))&.text
          aff = p.at(ns("./affiliation/organization/abbreviation"))&.text ||
            p.at(ns("./affiliation/organization/name"))&.text
          c = name || ""
          aff and c += " (#{aff})"
          ret << c
        end
        ret
      end
    end
  end
end
