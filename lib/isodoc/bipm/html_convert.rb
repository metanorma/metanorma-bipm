require "isodoc"
require "isodoc/generic/html_convert"
require_relative "init"
require_relative "base_convert"

module IsoDoc
  module BIPM
    class HtmlConvert < IsoDoc::Generic::HtmlConvert

      def middle(isoxml, out)
        super
        doccontrol isoxml, out
      end

      def doccontrol(isoxml, out)
        c = isoxml.at(ns("//doccontrol")) or return
        out.div **attr_code(class: "doccontrol") do |div|
          clause_parse_title(c, div, c.at(ns("./title")), out)
          c.children.reject { |c1| c1.name == "title" }.each do |c1|
            parse(c1, div)
          end
        end
      end

      include BaseConvert
      include Init
    end
  end
end

