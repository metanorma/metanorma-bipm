require "isodoc"
require "isodoc/generic/html_convert"
require_relative "init"
require_relative "base_convert"

module IsoDoc
  module Bipm
    class HtmlConvert < IsoDoc::Generic::HtmlConvert
      def doccontrol(elem, out)
        out.div **attr_code(class: "doccontrol") do |div|
          clause_parse_title(elem, div, elem.at(ns("./fmt-title")), out)
          elem.children.reject { |c1| c1.name == "fmt-title" }.each do |c1|
            parse(c1, div)
          end
        end
      end

      def counter_reset(node)
        s = node["start"]
        return nil unless s && !s.empty? && !s.to_i.zero?

        "counter-reset: #{node['type']} #{s.to_i - 1};"
      end

      def ol_attrs(node)
        klass, style = if (node["type"] == "roman" &&
            !node.at("./ancestor::xmlns:ol[@type = 'roman']")) ||
            (node["type"] == "alphabet" &&
                !node.at("./ancestor::xmlns:ol[@type = 'alphabet']"))
                         [node["type"], counter_reset(node)]
                       end
        super.merge(attr_code(type: ol_style((node["type"] || "arabic").to_sym),
                              start: node["start"]), style: style, class: klass)
      end

      include BaseConvert
      include Init
    end
  end
end
