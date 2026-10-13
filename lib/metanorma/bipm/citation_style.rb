require "relaton-render"

module Metanorma
  module Bipm
    #
    # The BIPM flavor's citation renderer: an extension of the
    # relaton-render General facade carrying this gem's CitationStyle
    # instance and its BIPM data elements. Supersedes the 1.x stack
    # this gem carried under lib/metanorma/bipm/relaton_render, which
    # subclassed relaton-render 1.x internals that the 3.0.0.pre
    # engine no longer ships.
    #
    class CitationStyle < ::Relaton::Render::General
      STYLE_PATH = File.join(__dir__, "bipm-style.yml")

      # The BIPM presentation-of-models rules are engine-registered
      # (bipm_*) and selected as pack data in bipm-style.yml. The home
      # resolution stays here: it is the flavor's own
      HOME_PUBLISHERS =
        ["International Organization for Standardization",
         "International Electrotechnical Commission"].freeze

      # 1.x home_standard: ISO/IEC documents by publisher NAME (an
      # abbreviation-only publisher is not home)
      def self.home_publisher?(model)
        Array(model.contributor).any? do |c|
          next false unless Array(c.role).any? do |r|
            r.is_a?(String) ? r == "publisher" : r.type == "publisher"
          end

          Array(c.organization&.name)
            .any? { |n| HOME_PUBLISHERS.include?(n.content) }
        end
      end

      # The BIPM renderer: the engine's with the home-docid test by
      # publisher name
      class Renderer < ::Relaton::Render::Iso690::Renderer
        def home_docid?(model)
          CitationStyle.home_publisher?(model)
        end
      end

      private

      # 1.x use_terminator?: home standards carry no bibliography
      # terminator (the entry code ends the cite)
      def terminate_reference(ref, item = nil)
        return ref if item && CitationStyle.home_publisher?(item)

        super
      end

      # The BIPM identifier never surfaces for articles, journals and
      # books (the 1.x authoritative-identifier filter)
      def facade_docids(doc)
        return [] if %w[article journal book].include?(doc["type"])

        super
      end

      def initialize(options = {})
        super
        options = deep_symbolize(options)
        @renderer = Renderer.new(
          lang: @lang,
          script: options[:script] || "Latn",
          labels: options[:i18nhash] || {},
          style: options[:style] || STYLE_PATH,
        )
      end
    end
  end
end
