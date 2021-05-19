require "asciidoctor/standoc/converter"
require "asciidoctor/generic/converter"

module Asciidoctor
  module BIPM
    class Converter < Asciidoctor::Generic::Converter
      register_for "bipm"

      def configuration
        Metanorma::BIPM.configuration
      end

      def org_name_long
        configuration.organization_name_long[@lang]
      end

      def default_publisher
        org_name_long
      end

      def org_abbrev
        { org_name_long => configuration.organization_name_short }
      end

      def metadata_committee(node, xml)
        return unless node.attr("committee-en") || node.attr("committee-fr")

        xml.editorialgroup do |a|
          metadata_committee1(node, a)
          i = 2
          while node.attr("committee-en_#{i}") || node.attr("committee-fr_#{i}")
            metadata_committee2(node, a, i)
            i += 1
          end
          metadata_workgroup(node, a)
        end
      end

      def metadata_committee1(node, xml)
        xml.committee **attr_code(acronym:
                                  node.attr("committee-acronym")) do |c|
          e = node.attr("committee-en") and
            c.variant e, language: "en", script: "Latn"
          e = node.attr("committee-fr") and
            c.variant e, language: "fr", script: "Latn"
        end
      end

      def metadata_committee2(node, xml, num)
        xml.committee **attr_code(acronym:
                                  node.attr("committee-acronym_#{num}")) do |c|
          %w(en fr).each do |lg|
            e = node.attr("committee-#{lg}_#{num}") and
              c.variant e, language: lg, script: "Latn"
          end
        end
      end

      def metadata_workgroup(node, xml)
        xml.workgroup(node.attr("workgroup"),
                      **attr_code(acronym: node.attr("workgroup-acronym")))
        i = 2
        while node.attr("workgroup_#{i}")
          xml.workgroup(
            node.attr("workgroup_#{i}"),
            **attr_code(acronym: node.attr("workgroup-acronym_#{i}"))
          )
          i += 1
        end
      end

      def metadata_relations(node, xml)
        super
        relation_supersedes_self(node, xml, "")
        i = 2
        while relation_supersedes_self(node, xml, "_#{i}")
          i += 1
        end
      end

      def relation_supersedes_self(node, xml, suffix)
        d = node.attr("supersedes-date#{suffix}")
        draft = node.attr("supersedes-draft#{suffix}")
        edition = node.attr("supersedes-edition#{suffix}")
        return false unless d || draft || edition

        relation_supersedes_self1(xml, d, edition, draft)
      end

      def relation_supersedes_self1(xml, date, edition, draft)
        xml.relation **{ type: "supersedes" } do |r|
          r.bibitem do |b|
            date and b.date(date,
                            **{ type: edition ? "published" : "circulated" })
            edition and b.edition edition
            draft and b.version do |v|
              v.draft draft
            end
          end
        end
      end

      def personal_role(node, xml, suffix)
        role = node.attr("role#{suffix}") || "author"
        unless %w(author editor).include?(role.downcase)
          desc = role
          role = "editor"
        end
        xml.role desc, **{ type: role.downcase }
      end

      def title(node, xml)
        ["en", "fr"].each do |lang|
          at = { language: lang, format: "text/plain" }
          xml.title **attr_code(at.merge(type: "main")) do |t1|
            t1 << Metanorma::Utils::asciidoc_sub(node.attr("title-#{lang}"))
          end
          %w(cover appendix annex part subpart provenance).each do |w|
            typed_title(node, xml, lang, w)
          end
        end
      end

      def typed_title(node, xml, lang, type)
        at = { language: lang, format: "text/plain" }
        return unless title = node.attr("title-#{type}-#{lang}")

        xml.title **attr_code(at.merge(type: type)) do |t1|
          t1 << Metanorma::Utils::asciidoc_sub(title)
        end
      end

      def sectiontype_streamline(ret)
        case ret
        when "introduction" then @jcgm ? "introduction" : "clause"
        else
          super
        end
      end

      def sectiontype(node, level = true)
        ret = sectiontype1(node)
        return ret if ret == "terms and definitions"

        super
      end

      def inline_anchor_xref_attrs(node)
        flags = %w(pagenumber nosee nopage).each_with_object({}) do |w, m|
          if /#{w}%/.match?(node.text)
            node.text = node.text.sub(/#{w}%/, "")
            m[w] = true
          end
        end
        ret = super
        flags.each_key { |k| ret[k.to_sym] = true }
        ret
      end

      def clause_parse(attrs, xml, node)
        node.option?("unnumbered") and attrs[:unnumbered] = true
        super
      end

      def annex_parse(attrs, xml, node)
        node.option?("unnumbered") and attrs[:unnumbered] = true
        super
      end

      def ol_attrs(node)
        super.merge(attr_code(start: node.attr("start")))
      end

      def committee_validate(xml)
        committees = Array(configuration&.committees) || return
        committees.empty? and return
        xml.xpath("//bibdata/ext/editorialgroup/committee/variant").each do |c|
          committees.include? c.text or
            @log.add("Document Attributes", nil,
                     "#{c.text} is not a recognised committee")
        end
        xml.xpath("//bibdata/ext/editorialgroup/committee/@acronym").each do |c|
          committees.include? c.text or
            @log.add("Document Attributes", nil,
                     "#{c.text} is not a recognised committee")
        end
      end

      def boilerplate_file(xmldoc)
        return super unless @jcgm

        File.join(File.dirname(__FILE__), "boilerplate-jcgm-en.xml")
      end

      def sections_cleanup(xml)
        super
        jcgm_untitled_sections_cleanup(xml) if @jcgm
      end

      def jcgm_untitled_sections_cleanup(xml)
        xml.xpath("//clause//clause | //annex//clause | //introduction/clause")
          .each do |c|
          next if !c&.at("./title")&.text&.empty?

          c["inline-header"] = true
        end
      end

      def section_names_terms_cleanup(xml); end

      def section_names_refs_cleanup(xml); end

      def mathml_mi_italics
        { uppergreek: false, upperroman: false,
          lowergreek: false, lowerroman: true }
      end

      def document(node)
        @jcgm = node.attr("committee-acronym") == "JCGM"
        super
      end

      def outputs(node, ret)
        File.open("#{@filename}.xml", "w:UTF-8") { |f| f.write(ret) }
        presentation_xml_converter(node).convert("#{@filename}.xml")
        html_converter(node).convert("#{@filename}.presentation.xml",
                                     nil, false, "#{@filename}.html")
        pdf_converter(node)&.convert("#{@filename}.presentation.xml",
                                     nil, false, "#{@filename}.pdf")
      end

      def html_converter(node)
        IsoDoc::BIPM::HtmlConvert.new(html_extract_attributes(node))
      end

      def presentation_xml_converter(node)
        IsoDoc::BIPM::PresentationXMLConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")

        IsoDoc::BIPM::PdfConvert.new(doc_extract_attributes(node))
      end
    end
  end
end
