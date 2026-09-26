# frozen_string_literal: true

require "metanorma/standoc"
# Forward-declare parent namespace so this file is safe to require
# directly (without first requiring metanorma/bipm.rb).
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

require "metanorma-core"
require "metanorma/document"

Metanorma::Core::Flavors.register(
  Metanorma::Core::Flavor.new(
    name: :bipm,
    gem: "metanorma-bipm",
    model_root: Metanorma::Bipm::Document::Root,
    processor: defined?(Metanorma::Bipm::Processor) ? Metanorma::Bipm::Processor : nil,
    pubid_module: :"Pubid::Bipm",
    renderers: { html: Metanorma::Html::StandardRenderer },
  ),
)

# Backwards-compat alias so external consumers that reference
# Metanorma::BipmDocument keep resolving during the transition.
module Metanorma
  existing = defined?(Metanorma::BipmDocument) && Metanorma::BipmDocument
  if !existing.equal?(Metanorma::Bipm::Document)
    Metanorma.send(:remove_const, :BipmDocument) if existing
    BipmDocument = Metanorma::Bipm::Document
  end
end

if defined?(Metanorma::Registers::Setup.setup_bipm_register)
  Metanorma::Registers::Setup.setup_bipm_register
end

module Metanorma
  deprecate_constant :BipmDocument
end
