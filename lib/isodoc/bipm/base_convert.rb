require "isodoc"

module IsoDoc
  module Bipm
    module BaseConvert
      attr_accessor :jcgm

      def configuration
        Metanorma::Bipm.configuration
      end

      def convert1(docxml, filename, dir)
        @jcgm = docxml&.at(ns("//bibdata/ext/editorialgroup/committee/" \
                              "@acronym"))&.value == "JCGM"
        super
      end
=begin
      def update_i18n(i18n)
        #require "debug"; binding.b
        if %w(2019).include?(@docscheme)
          %w(level2_ancillary level3_ancillary level2_ancillary_alt
             level3_ancillary_alt).each do |w|
            i18n_conditional_set(i18n, w, "#{w}_2019")
          end
        end
        i18n.set("annex", i18n.get["level2_ancillary"])
        i18n.set("appendix", i18n.get["level3_ancillary"])
      end

      def convert_i18n_init(docxml)
        #require "debug"; binding.b
        @docscheme =
          docxml.at(ns("//presentation-metadata[name" \
                       "[text() = 'document-scheme']]/value"))&.text || "2021"
        super
        update_i18n(@i18n)
      end

      def i18n_conditional_set(i18n, old, new)
        i18n.get[new] or return
        i18n.set(old, i18n.get[new])
      end
=end
      def middle_clause(_docxml)
        if @jcgm
          "//clause[parent::sections][not(@type = 'scope')]" \
            "[not(descendant::terms)][not(descendant::references)]"
        else
          "//sections/*[not(local-name() = 'references')][not(.//references)]"
        end
      end

      def term_cleanup(docxml)
        @jcgm ? docxml : super
      end

      def table_footnote?(node)
        super && !node.ancestors.map(&:name).include?("quote")
      end
    end
  end
end
