module Metanorma
  module Bipm
    class Converter < Metanorma::Generic::Converter
      def metadata_committee(node, xml)
        node.attr("committee-en") || node.attr("committee-fr") or return
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
        %w(en fr).each do |lg|
          e = node.attr("committee-#{lg}") or next
          xml.committee e, **attr_code(acronym: node.attr("committee-acronym"),
                                       language: lg, script: "Latn")
        end
      end

      def metadata_committee2(node, xml, num)
        %w(en fr).each do |lg|
          e = node.attr("committee-#{lg}_#{num}") or next
          xml.committee e, **attr_code(acronym: node.attr("committee-acronym"),
                                       language: lg, script: "Latn")
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

      def contrib_committee_subdiv(xml, committee)
        contributors_committees_filter_empty?(committee) and return
        xml.subdivision **attr_code(type: committee[:subdivtype],
                                    subtype: committee[:type]) do |o|
          # warn pp committee
          committee[:name] and o.name committee[:name]
          committee[:name_en] and o.name committee[:name_en],
                                         language: "en"
          committee[:name_fr] and o.name committee[:name_fr],
                                         language: "fr"
          committee[:abbr] and o.abbreviation committee[:abbr]
          committee[:ident] and o.identifier committee[:ident]
        end
      end

      def contributors_committees_filter_empty?(committee)
        (committee[:name].nil? || committee[:name].empty?) &&
          (committee[:name_en].nil? || committee[:name_en].empty?) &&
          (committee[:name_fr].nil? || committee[:name_fr].empty?) &&
          committee[:ident].nil?
      end

      def committee_number_or_name?(node, type, suffix)
        node.attr("#{type}-number#{suffix}") || node.attr("#{type}#{suffix}") ||
          node.attr("#{type}-en#{suffix}") || node.attr("#{type}-fr#{suffix}")
      end

      def committee_org_prep_agency(node, type, agency, agency_arr, agency_abbr)
        i = 1
        suffix = ""
        while committee_number_or_name?(node, type, suffix)
          agency_arr << (node.attr("#{type}-agency#{suffix}") || agency)
          agency_abbr << node.attr("#{type}-agency-abbr#{suffix}")
          i += 1
          suffix = "_#{i}"
        end
        [agency_arr, agency_abbr]
      end

      def extract_org_attrs_complex(node, opts, source, suffix)
        super.merge(name_en: node.attr("#{source}-en#{suffix}"),
                    name_fr: node.attr("#{source}-fr#{suffix}"))
      end

      def metadata_author(node, xml)
        # require "debug"; binding.b
        super
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
        title = node.attr("title-#{type}-#{lang}") or return
        xml.title **attr_code(at.merge(type: "title-#{type}")) do |t1|
          t1 << Metanorma::Utils::asciidoc_sub(title)
        end
      end
    end
  end
end
