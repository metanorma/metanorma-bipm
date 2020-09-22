require "isodoc"
require "isodoc/generic/html_convert"
require_relative "init"
require_relative "base_convert"

module IsoDoc
  module BIPM
    class HtmlConvert < IsoDoc::Generic::HtmlConvert

      include BaseConvert
      include Init
    end
  end
end

