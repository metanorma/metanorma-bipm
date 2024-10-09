require "metanorma"
require "metanorma/bipm"
require "metanorma/bipm/version"
require "isodoc/bipm"

require "asciidoctor" unless defined? Asciidoctor::Converter

if defined? Metanorma::Registry
  require_relative "metanorma/bipm"
  Metanorma::Registry.instance.register(Metanorma::Bipm::Processor)
end
