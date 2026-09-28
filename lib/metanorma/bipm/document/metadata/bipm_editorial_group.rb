# frozen_string_literal: true

require "metanorma/document"

module Metanorma
  module Bipm::Document
    module Metadata
      # BIPM legacy presentation XML states the editorial committee as
      # <editorialgroup><committee acronym="JCGM"><variant language="en">
      # Joint Committee for Guides in Metrology</variant>...</committee>
      # </editorialgroup>, unlike the ISO <editorial-group> shape.
      class BipmCommittee < Lutaml::Model::Serializable
        attribute :acronym, :string
        attribute :variant,
                  Metanorma::Document::Components::DataTypes::LocalizedString,
                  collection: true

        xml do
          element "committee"
          map_attribute "acronym", to: :acronym
          map_element "variant", to: :variant
        end
      end

      class BipmEditorialGroup < Lutaml::Model::Serializable
        attribute :committee, BipmCommittee, collection: true

        xml do
          element "editorialgroup"
          map_element "committee", to: :committee
        end
      end
    end
  end
end
