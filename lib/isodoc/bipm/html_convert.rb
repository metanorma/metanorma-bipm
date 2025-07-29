require "isodoc"
require "isodoc/generic/html_convert"
require_relative "init"
require_relative "base_convert"

module IsoDoc
  module Bipm
    class HtmlConvert < IsoDoc::Generic::HtmlConvert
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
                    style: style, class: klass))
      end

      include BaseConvert
      include Init
    end
  end
end
