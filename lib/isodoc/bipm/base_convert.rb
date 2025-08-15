require "isodoc"

module IsoDoc
  module Bipm
    module BaseConvert
      attr_accessor :jcgm

      def configuration
        Metanorma::Bipm.configuration
      end

      def convert1(docxml, filename, dir)
        @jcgm = docxml.at(ns(<<~XPATH))&.text == "JCGM"
          //bibdata/contributor[role/description = 'committee']/organization/subdivision[@type = 'Committee']/identifier[not(@type = 'full')]
        XPATH
        super
      end

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
