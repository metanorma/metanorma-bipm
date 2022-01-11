require "metanorma"
require "metanorma/bipm"
require "metanorma/bipm/version"
require "isodoc/bipm"

require "asciidoctor" unless defined? Asciidoctor::Converter

if defined? Metanorma
  require_relative "metanorma/bipm"
  Metanorma::Registry.instance.register(Metanorma::BIPM::Processor)
end
