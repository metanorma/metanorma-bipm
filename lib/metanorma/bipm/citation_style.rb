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

      # The BIPM data elements, scoped to this renderer alone: the
      # component-part order (host editors before the host title, the
      # host medium and the parenthesized production) and the
      # bold-volume journal numeration
      ELEMENTS = {
        creator: BipmElements::BipmCreator,
        component_part: BipmElements::BipmComponentPart,
        production: BipmElements::BipmProduction,
        extent: BipmElements::BipmExtent,
        medium: BipmElements::BipmMedium,
        edition: BipmElements::BipmEdition,
        volsize: BipmElements::BipmVolume,
      }.freeze

      private

      # 1.x use_terminator?: home standards carry no bibliography
      # terminator (the entry code ends the cite)
      def terminate_reference(ref, item = nil)
        return ref if item && BipmElements.home_publisher?(item)

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
        @renderer = BipmElements::BipmRenderer.new(
          lang: @lang,
          script: options[:script] || "Latn",
          labels: options[:i18nhash] || {},
          style: options[:style] || STYLE_PATH,
          elements: ELEMENTS,
        )
      end
    end
  end
end
