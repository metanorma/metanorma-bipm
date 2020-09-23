module IsoDoc
  module BIPM
    class Xref < IsoDoc::Xref
      def back_anchor_names(docxml)
        super
        docxml.xpath(ns("//annex")).each_with_index do |c, i|
          annex_names(c, (i+1).to_s)
        end
      end

      def annex_name_lbl(clause, num)
        l10n("<strong>#{@labels["annex"]} #{num}</strong>")
      end
    end
  end
end
