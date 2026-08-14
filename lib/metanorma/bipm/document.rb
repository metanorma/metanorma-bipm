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
