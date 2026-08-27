# frozen_string_literal: true

require "metanorma/standoc"
require "metanorma/iso/document/models"
module Metanorma
  module Bipm
  end
end

module Metanorma
  module Bipm::Document
    autoload :Metadata, "metanorma/bipm/document/metadata"
    autoload :Root, "metanorma/bipm/document/root"
  end
end

module Metanorma
  existing = defined?(Metanorma::BipmDocument) && Metanorma::BipmDocument
  if !existing.equal?(Metanorma::Bipm::Document)
    Metanorma.send(:remove_const, :BipmDocument) if existing
    BipmDocument = Metanorma::Bipm::Document
  end
end

# OCP adoption: ONE registration in the metanorma-core flavor table
require "metanorma-core"

Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
  name: :bipm,
  gem: "metanorma-bipm",
  model_root: Metanorma::Bipm::Document::Root,
  pubid_module: nil,
  renderers: { html: lambda do |_document, **_options|
    Metanorma::Html::StandardRenderer
  end },
))
