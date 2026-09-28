# frozen_string_literal: true

require "metanorma/html"
require "yaml"

module Metanorma
  module Bipm
    # HTML format adapter slice for the BIPM flavor: binds the flavor's
    # document root to the standard document rendering.
    module Html
      class Renderer < Metanorma::Html::StandardRenderer
        register_render "Metanorma::Bipm::Document::Root", :render_standard_document

        I18N_DIR = File.expand_path("../../isodoc/bipm", __dir__)

        # isodoc's BIPM i18n labels layered over the isodoc defaults.
        BIPM_LABELS = {
          "en" => { "date" => "Date", "draft_label" => "draft" },
          "fr" => { "date" => "Date", "draft_label" => "brouillon" },
        }.freeze

        # The BIPM/JCGM native titlepage (isodoc bipm) carries the full
        # cover identity: the stage/type bands, the docnumber line with
        # its draft date, the bilingual cover title, the publisher line,
        # the committee line and the author roster. Render the same text
        # in the same order from the parsed bibdata.
        def render_coverpage(doc)
          bibdata = doc.bibdata
          return super unless bibdata

          render_liquid("_element.html.liquid", {
                          "tag" => "div",
                          "extra_attrs" => %( class="title-section"),
                          "content" => bipm_cover_furniture(bibdata),
                        }) + render_liquid("_element.html.liquid", {
                          "tag" => "hr",
                          "extra_attrs" => %( class="cover-separator"),
                          "content" => "",
                        })
        end

        # The BIPM bibdata carries its titles in the ISO TitleCollection
        # vocabulary; the base extraction only reads a bare +title+.
        def extract_display_title(bibdata)
          title = bipm_cover_title_items(bibdata, bipm_primary_lang(bibdata)).first
          return title if title && !title.empty?

          super
        end

        private

        def bipm_cover_furniture(bibdata)
          lang = bipm_primary_lang(bibdata)
          year = bipm_docyear(bibdata)
          title_runs = bipm_cover_title_items(bibdata, lang)
          org = bipm_org_abbrev(bibdata)
          doctype = bipm_doctype_display(bibdata)
          stage = bipm_stage_display(bibdata)
          type_line = "#{org} #{doctype}".strip

          parts = []
          parts << bipm_cover_title_html(title_runs, "cover-title")
          parts << bipm_band_html("document-stage-band", "document-stage", stage)
          parts << bipm_band_html("document-type-band", "document-type", type_line)
          parts << bipm_doc_number_html(bibdata, year)
          parts << bipm_cover_title_html(title_runs, "cover-title cover-title-sub")
          parts << bipm_text_html("coverpage-logo",
                                  "Bureau International de Poids et Mesures #{year}".strip)
          committee = bipm_committee_line(bibdata, lang)
          parts << bipm_text_html("coverpage-tc-name", committee) if committee
          authors = bipm_cover_authors(bibdata)
          unless authors.empty?
            parts << bipm_text_html("coverpage-tc-name", "#{authors.join(', ')}.")
          end
          parts << bipm_text_html("coverpage-stage", type_line)
          parts << bipm_text_html("coverpage-maturity", stage) if stage
          parts.join
        end

        def bipm_cover_title_html(runs, css_class)
          return "" if runs.empty?

          spans = runs.map do |run|
            render_liquid("_element.html.liquid", {
                            "tag" => "span",
                            "extra_attrs" => "",
                            "content" => escape_html(run),
                          })
          end
          render_liquid("_element.html.liquid", {
                          "tag" => "div",
                          "extra_attrs" => %( class="#{css_class}"),
                          "content" => spans.join(" "),
                        })
        end

        def bipm_band_html(css_class, text_class, text)
          return "" unless text

          inner = render_liquid("_element.html.liquid", {
                                  "tag" => "p",
                                  "extra_attrs" => %( class="#{text_class}"),
                                  "content" => escape_html(text),
                                })
          render_liquid("_element.html.liquid", {
                          "tag" => "div",
                          "extra_attrs" => %( class="#{css_class}"),
                          "content" => inner,
                        })
        end

        def bipm_text_html(css_class, text)
          render_liquid("_element.html.liquid", {
                          "tag" => "div",
                          "extra_attrs" => %( class="#{css_class}"),
                          "content" => escape_html(text),
                        })
        end

        # docnumber ":" docyear "(draft revdate)" and the "Date:" line.
        def bipm_doc_number_html(bibdata, year)
          docnumber = bipm_primary_docnumber(bibdata)
          revdate = bipm_revdate(bibdata)
          draftinfo = revdate ? " (#{bipm_label('draft_label')} #{revdate})" : ""
          line = "#{docnumber} : #{year}#{draftinfo}".strip
          parts = [bipm_text_html("doc-number", line)]
          if revdate
            parts << bipm_text_html("doc-revdate",
                                    "#{bipm_label('date')}: #{revdate}")
          end
          parts.join
        end

        # Cover title runs in native order: main title in the document
        # language, main title in the other language, then the
        # provenance title ("GUM 1995 with minor corrections").
        def bipm_cover_title_items(bibdata, lang)
          titles = safe_attr(bibdata, :titles)
          return [] unless titles.respond_to?(:items)

          items = titles.items
          other = lang == "fr" ? "en" : "fr"
          main = lambda { |l|
            item = items.find do |t|
              t.language == l && %w[title-main main].include?(t._type.to_s)
            end || items.find { |t| t.language == l && t._type.to_s.empty? }
            item && extract_text_value(item.value).to_s.strip
          }
          provenance = items.find do |t|
            t.language == lang && t._type.to_s == "title-provenance"
          end
          runs = [main.call(lang), main.call(other)].reject { |run| run.nil? || run.empty? }
          prov = provenance && extract_text_value(provenance.value).to_s.strip
          runs << prov if prov && !prov.empty?
          runs
        end

        def bipm_primary_docnumber(bibdata)
          ids = Array(safe_attr(bibdata, :doc_identifier))
          primary = ids.find { |di| safe_attr(di, :primary).to_s == "true" } ||
                    ids.first
          Array(safe_attr(primary, :value)).join.strip
        end

        # The BIPM draft date is the bare <version> text; it doubles as
        # the revdate of the "Date:" line.
        def bipm_revdate(bibdata)
          version = safe_attr(bibdata, :version)
          content = safe_attr(version, :content).to_s.strip
          content.empty? ? nil : content
        end

        def bipm_docyear(bibdata)
          copyright = safe_attr(bibdata, :copyright)
          from = safe_attr(copyright, :from)
          from.to_s[/\d{4}/]
        end

        def bipm_org_abbrev(bibdata)
          committee = bipm_committee(bibdata)
          acronym = safe_attr(committee, :acronym).to_s.strip
          acronym.empty? ? "BIPM" : acronym
        end

        def bipm_committee(bibdata)
          ext = safe_attr(bibdata, :ext)
          group = safe_attr(ext, :editorial_group)
          Array(safe_attr(group, :committee)).first
        end

        def bipm_committee_line(bibdata, lang)
          committee = bipm_committee(bibdata)
          return nil unless committee

          acronym = safe_attr(committee, :acronym).to_s.strip
          variant = Array(safe_attr(committee, :variant)).find do |v|
            safe_attr(v, :language) == lang
          end
          name = variant ? extract_text_value(variant).to_s.strip : ""
          line = [acronym, name].reject(&:empty?).join(": ")
          line.empty? ? nil : line
        end

        # The author roster of the native coverpage-tc-name block:
        # "Name (Affiliation), Name (Affiliation), ..." — authors and
        # editors carrying a person name.
        def bipm_cover_authors(bibdata)
          Array(safe_attr(bibdata, :contributor)).filter_map do |contributor|
            roles = Array(safe_attr(contributor, :role))
            next unless roles.any? { |role| %w(author editor).include?(safe_attr(role, :type).to_s) }

            person = safe_attr(contributor, :person)
            next unless person

            name = extract_text_value(
              safe_attr(safe_attr(person, :name), :completename),
            ).to_s.strip
            next if name.empty?

            affiliation = bipm_person_affiliation(person)
            affiliation.empty? ? name : "#{name} (#{affiliation})"
          end
        end

        def bipm_person_affiliation(person)
          Array(safe_attr(person, :affiliation)).filter_map do |aff|
            org = safe_attr(aff, :organization)
            name = org ? extract_text_value(safe_attr(org, :name)).to_s.strip : ""
            name.empty? ? nil : name
          end.first.to_s
        end

        def bipm_stage_display(bibdata)
          stage = Array(safe_attr(safe_attr(bibdata, :status), :stage)).first
          value = Array(safe_attr(stage, :value)).join.strip
          return nil if value.empty?

          # isodoc prints the stage through the flavor stage_dict
          # ("in-force" becomes "En Vigeur" on French covers), not the
          # raw bibdata value.
          localized = bipm_gem_labels.dig("stage_dict", value) || value
          bipm_status_print(localized)
        end

        def bipm_doctype_display(bibdata)
          ext = safe_attr(bibdata, :ext)
          doctypes = safe_attr(ext, :doctype_element)
          return nil if Array(doctypes).empty?

          value = Array(safe_attr(Array(doctypes).first, :value)).join.strip
          value.empty? ? nil : bipm_status_print(value)
        end

        # isodoc BIPM status_print: capitalize words but keep en/de
        # particles lowercase after the first ("Mise en Pratique");
        # "cipm-mra" and "procès-verbal" stay as printed.
        def bipm_status_print(status)
          return "Procès-Verbal" if status == "procès-verbal"
          return "CIPM-MRA" if status == "cipm-mra"

          status.split(/[- ]/).map.with_index do |word, i|
            if %w(en de).include?(word) && i.positive?
              word
            else
              word.capitalize
            end
          end.join(" ")
        end

        def bipm_primary_lang(bibdata)
          %w[en fr].include?(language) ? language : "en"
        end

        def bipm_label(key)
          labels = BIPM_LABELS[language] || BIPM_LABELS["en"]
          gem_labels = bipm_gem_labels[language] || {}
          gem_labels[key.to_s] || labels[key.to_s]
        end

        def bipm_gem_labels
          @bipm_gem_labels ||= begin
            path = File.join(I18N_DIR, "i18n-#{language}.yaml")
            path = File.join(I18N_DIR, "i18n-en.yaml") unless File.exist?(path)
            YAML.safe_load(File.read(path)) || {}
          rescue StandardError
            {}
          end
        end
      end
    end
  end
end
