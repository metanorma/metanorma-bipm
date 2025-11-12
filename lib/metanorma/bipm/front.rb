module Metanorma
  module Bipm
    class Converter < Metanorma::Generic::Converter
      def contrib_committee_subdiv(xml, comm)
        contributors_committees_filter_empty?(comm) and return
        xml.subdivision **attr_code(type: comm[:subdivtype],
                                    subtype: comm[:type]) do |o|
          add_noko_elem(o, "name", comm[:name])
          add_noko_elem(o, "name", comm[:name_en], language: "en")
          add_noko_elem(o, "name", comm[:name_fr], language: "fr")
          add_noko_elem(o, "abbreviation", comm[:abbr])
          add_noko_elem(o, "identifier", comm[:ident])
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
        ident = node.attr("#{source}-acronym#{suffix}")
        ret = super.merge(name_en: node.attr("#{source}-en#{suffix}"),
                          name_fr: node.attr("#{source}-fr#{suffix}"))
        ident and ret[:ident] = ident
        ret
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
            add_noko_elem(b, "date", date,
                          type: edition ? "published" : "circulated")
            add_noko_elem(b, "edition", edition)
            draft and b.version do |v|
              add_noko_elem(v, "draft", draft)
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
          d << desc # can be empty
        end
      end

      def title(node, xml)
        ["en", "fr"].each do |lang|
          add_title_xml(xml, node.attr("title-#{lang}"), lang, "title-main")
          %w(cover appendix annex part subpart provenance).each do |w|
            typed_title(node, xml, lang, w)
          end
        end
      end

      def typed_title(node, xml, lang, type)
        title = node.attr("title-#{type}-#{lang}") or return
        add_title_xml(xml, title, lang, "title-#{type}")
      end
    end
  end
end
