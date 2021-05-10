require "metanorma"
require "metanorma/bipm"
require "isodoc/bipm"

require "asciidoctor" unless defined? Asciidoctor::Converter
require "asciidoctor/bipm"

if defined? Metanorma
  require_relative "metanorma/bipm"
  Metanorma::Registry.instance.register(Metanorma::BIPM::Processor)
end
