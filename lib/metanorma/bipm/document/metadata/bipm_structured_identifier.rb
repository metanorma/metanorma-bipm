# frozen_string_literal: true

module Metanorma
  module Bipm::Document
    module Metadata
      # Structured identifier for BIPM documents (docnumber only).
      class BipmStructuredIdentifier < Lutaml::Model::Serializable
        attribute :docnumber, :string
        attribute :part, :string
        attribute :appendix, :string
        attribute :annexid, :string

        xml do
          element "structuredidentifier"
          map_element "docnumber", to: :docnumber
          map_element "part", to: :part
          map_element "appendix", to: :appendix
          map_element "annexid", to: :annexid
        end
      end
    end
  end
end
