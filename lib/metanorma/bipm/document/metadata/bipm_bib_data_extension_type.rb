# frozen_string_literal: true

require "metanorma/iso/document"

module Metanorma
  module Bipm::Document
    module Metadata
      # Extension point for bibliographical definitions of BIPM documents.
      # Inherits all ISO extension fields; overrides structuredidentifier for BIPM format.
      class BipmBibDataExtensionType < Metanorma::Iso::Document::Metadata::IsoBibDataExtensionType
        attribute :structuredidentifier, BipmStructuredIdentifier
        attribute :si_aspect, :string
        attribute :editorial_group, BipmEditorialGroup

        xml do
          element "ext"
          map_element "structuredidentifier", to: :structuredidentifier
          map_element "si-aspect", to: :si_aspect
          # BIPM legacy XML spells the element <editorialgroup> and nests
          # <committee> directly (ISO uses <editorial-group>).
          map_element "editorialgroup", to: :editorial_group
        end
      end
    end
  end
end
