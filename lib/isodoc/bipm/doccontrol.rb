module IsoDoc
  module BIPM
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def doccontrol(doc)
        return unless doc.at(ns("//bibdata/relation[@type = 'supersedes']"))

        clause = <<~DOCCONTROL
          <doccontrol displayorder="999">
          <title>Document Control</title>
          <table unnumbered="true"><tbody>
          <tr><th>Authors:</th><td/><td>#{list_authors(doc)}</td></tr>
          #{doccontrol_row1(doc)} #{doccontrol_row2(doc)} #{list_drafts(doc)}
          </tbody></table></doccontrol>
        DOCCONTROL
        doc.root << clause
      end

      def doccontrol_row1(doc)
        return "" if list_draft(doc,
                                1) == ["", ""] && list_cochairs(doc).empty?

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
          ret += "<tr>#{list_draft(xml, i).map do |x|
                          "<td>#{x}</td>"
                        end.join} " \
                 "<td/></tr>"
          i += 1
        end
        ret
      end

      def list_draft(xml, idx)
        d = xml.at(ns("//bibdata/relation[@type = 'supersedes'][#{idx}]" \
                      "/bibitem")) or return ["", ""]

        draft = d&.at(ns("./version/draft"))&.text and draft = "Draft #{draft}"
        edn = d&.at(ns("./edition"))&.text and edn = "Version #{edn}"
        [[draft, edn].join(" "), d&.at(ns("./date"))&.text]
      end

      def list_authors(xml)
        ret = list_people(
          xml, "//bibdata/contributor[xmlns:role/@type = 'author']/person"
        )
        @i18n.boolean_conj(ret, "and")
      end

      COCHAIR = "xmlns:role[contains(text(),'co-chair')]".freeze
      CHAIR = "[xmlns:role[contains(text(),'chair')]" \
              "[not(contains(text(),'co-chair'))]]".freeze

      def list_cochairs(xml)
        ret = list_people(xml, "//bibdata/contributor[#{COCHAIR}]/person")
        ret.empty? and return ""
        role = xml&.at(ns("//bibdata/contributor[#{COCHAIR}]/role"))&.text
        label = ret.size > 1 && role ? "#{role}s" : role
        "#{label}: #{@i18n.boolean_conj(ret, 'and')}"
      end

      def list_chairs(xml)
        ret = list_people(xml, "//bibdata/contributor#{CHAIR}/person")
        ret.empty? and return ""
        role = xml&.at(ns("//bibdata/contributor#{CHAIR}/role"))&.text
        label = ret.size > 1 && role ? "#{role}s" : role
        "#{label}: #{@i18n.boolean_conj(ret, 'and')}"
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
