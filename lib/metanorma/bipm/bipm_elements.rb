# frozen_string_literal: true

module Metanorma
  module Bipm
    # BIPM-specific data elements extending the engine's ISO 690
    # vocabulary, passed to the renderer as its element map
    module BipmElements
      # The BIPM component-part order: the host editors before the host
      # title, the host medium after it, and the production
      # parenthesized with its own trailing period ("In: Pellegrini A D
      # and Smith P K (Eds.) <em>The nature of play</em> [electronic
      # resource, 8vo] (New York, NY: Guilford Press).")
      class BipmComponentPart < ::Relaton::Render::Iso690::Elements::ComponentPart
        def render
          h = host or return ""
          out = +"#{lead}#{host_names(h)} (#{eds_label(h)})"
          out += " #{host_title}" unless host_title_text.empty?
          out += medium_text(h)
          out += production_text(h)
          out
        end

        private

        def host_editors(h)
          Array(h.contributor).select { |c| has_role?(c, "editor") }
        end

        def eds_label(h)
          @i18n.label(host_editors(h).one? ? "ed" : "eds")
        end

        def host_names(h)
          names = host_editors(h).map { |c|
            person = c.person or next ""

            [person_surname(person), person_given(person)].reject(&:empty?)
              .join(" ")
          }.reject(&:empty?)
          join_names(names)
        end

        def medium_text(h)
          BipmMedium.new(h, style: @style, i18n: @i18n).render.to_s
        end

        def production_text(h)
          production = ::Relaton::Render::Iso690::Elements::Production
            .new(h, style: @style, i18n: @i18n).render.to_s
          production.empty? ? "" : " (#{production})."
        end
      end

      # The BIPM journal numeration: the volume bold and the issue in
      # parens, pages unlabelled. Separate extent elements join with
      # semicolons ("<strong>8</strong>; (1); 32–36"), localities
      # within one element with spaces
      class BipmExtent < ::Relaton::Render::Iso690::Elements::Extent
        def render
          groups = extent_locality_groups.map { |g| group_text(g) }
            .reject(&:empty?)
          groups.join("; ")
        end

        private

        def extent_locality_groups
          Array(@model.extent).map do |e|
            Array(e.locality) +
              Array(e.locality_stack).flat_map { |s| Array(s.locality) }
          end
        end

        def group_text(localities)
          volume = plain_locality(localities, "volume")
          volume = volume.empty? ? "" : "<strong>#{volume}</strong>"
          issue = plain_locality(localities, "issue")
          issue = issue.empty? ? "" : "(#{issue})"
          [volume, issue, page_text(localities)].reject(&:empty?).join(" ")
        end

        def plain_locality(localities, type)
          loc = localities.find { |l| l.type == type } or return ""
          loc.reference_from.to_s
        end

        def page_text(localities)
          loc = localities.find { |l| l.type == "page" } or return ""
          from = loc.reference_from.to_s
          to = loc.reference_to.to_s
          text = to.empty? || to == from ? from :
            "#{from}#{@i18n.label('date_range')}#{to}"
          return text if item_kind == "serial_part"

          "#{@i18n.label(to.empty? || to == from ? 'page' : 'pages')} #{text}"
        end
      end

      # The BIPM production: the no-place placeholder stands only
      # with a publisher ("(n.p.: Publisher)"); a nameless publisher
      # drops the production entirely
      class BipmProduction < ::Relaton::Render::Iso690::Elements::Production
        private

        def no_place_production
          return "" if publishers.empty?

          super
        end
      end

      # The serial volume, bold, from the size's volume value
      class BipmVolume < ::Relaton::Render::Iso690::Element
        def present?
          !render.empty?
        end

        def render
          volume = Array(@model.size&.value).find do |v|
            !v.is_a?(String) && !v.is_a?(Hash) && v.type == "volume"
          end or return ""

          "<strong>#{volume.content}</strong>"
        end
      end

      # The BIPM medium, verbatim and bracketed with its leading
      # separator (" [Online]", " [dataset]", " [electronic resource,
      # 8vo]") — an absent medium attaches to nothing
      class BipmMedium < ::Relaton::Render::Iso690::Elements::Medium
        private

        def medium
          m = @model.medium or return ""
          text = m.carrier.to_s
          text = m.genre.to_s if text.empty?
          text = [m.form.to_s, m.size.to_s].reject(&:empty?)
            .join(", ") if text.empty?
          text.empty? ? "" : " [#{text}]"
        end
      end

      # The BIPM edition carries its own leading separator (", First
      # edition" for monographs, ". Version 2" online), so its absence
      # drops the separator with it
      class BipmEdition < ::Relaton::Render::Iso690::Elements::Edition
        def render
          text = super.to_s
          sep = item_kind == "monograph" ? ", " : ". "
          text.empty? ? "" : "#{sep}#{text}"
        end
      end

      HOME_PUBLISHERS =
        ["International Organization for Standardization",
         "International Electrotechnical Commission"].freeze

      class << self
        # 1.x home_standard: ISO/IEC documents by publisher NAME (an
        # abbreviation-only publisher is not home)
        def home_publisher?(model)
          Array(model.contributor).any? do |c|
            next false unless Array(c.role).any? do |r|
              r.is_a?(String) ? r == "publisher" : r.type == "publisher"
            end

            Array(c.organization&.name)
              .any? { |n| HOME_PUBLISHERS.include?(n.content) }
          end
        end
      end

      class BipmRenderer < ::Relaton::Render::Iso690::Renderer
        def home_docid?(model)
          BipmElements.home_publisher?(model)
        end
      end

      # The BIPM organization creator: the name alone, no abbreviation
      # suffix. Standards without personal creators cite their
      # publisher's name; monographs cite nothing (their "(n.d.)"
      # comes from the perType fallback)
      class BipmCreator < ::Relaton::Render::Iso690::Elements::Creator
        private

        def org_name(contributor)
          Array(contributor.organization&.name).map { |n| localized(n) }
            .join(", ")
        end

        def fallback_name
          return "" if %w[monograph continuing component_part]
            .include?(@style.kind_for(@model.type))

          publishers = contributors("publisher").filter_map do |c|
            localized(Array(c.organization&.name).first)
          end
          publishers.reject(&:empty?).first.to_s
        end
      end
    end
  end
end
