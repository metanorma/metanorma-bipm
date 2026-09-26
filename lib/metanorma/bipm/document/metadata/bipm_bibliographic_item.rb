# frozen_string_literal: true

require "metanorma/iso/document"

module Metanorma
  module Bipm::Document
    module Metadata
      class BipmBibliographicItem < Metanorma::Iso::Document::Metadata::IsoBibliographicItem
        attribute :ext, BipmBibDataExtensionType
        attribute :depiction, DepictionElement

        xml do
          element "bibdata"
          map_element "depiction", to: :depiction
        end
      end
    end
  end
end
