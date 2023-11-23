module Metanorma
  module BIPM
    class Converter < Metanorma::Generic::Converter
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
            **attr_code(acronym: node.attr("workgroup-acronym_#{i}")),
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
        xml.relation type: "supersedes" do |r|
          r.bibitem do |b|
            date and b.date(date,
                            type: edition ? "published" : "circulated")
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
        xml.role type: role.downcase do |d|
          d << desc
        end
      end

      def title(node, xml)
        ["en", "fr"].each do |lang|
          at = { language: lang, format: "text/plain" }
          xml.title **attr_code(at.merge(type: "title-main")) do |t1|
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

        xml.title **attr_code(at.merge(type: "title-#{type}")) do |t1|
          t1 << Metanorma::Utils::asciidoc_sub(title)
        end
      end
    end
  end
end
