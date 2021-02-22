module IsoDoc
  module BIPM
    class Counter < IsoDoc::XrefGen::Counter
    end

    class Xref < IsoDoc::Xref
      def initialize(lang, script, klass, i18n, options = {})
        super
      end

      def clause_names(docxml, sect_num)
        if docxml&.at(ns("//bibdata/ext/editorialgroup/committee/@acronym"))&.value == "JCGM"
          clause_names_jcgm(docxml, sect_num)
        else
          clause_names_bipm(docxml, sect_num)
        end
      end

      def clause_names_jcgm(docxml, sect_num)
        docxml.xpath(ns("//clause[parent::sections][not(@type = 'scope')][not(descendant::terms)]")).
          each_with_index do |c, i|
          section_names(c, sect_num, 1)
        end
      end

      def clause_names_bipm(docxml, sect_num)
        n = Counter.new
        docxml.xpath(ns("//sections/clause[not(@unnumbered = 'true')] | "\
                        "//sections/terms[not(@unnumbered = 'true')] | "\
                        "//sections/definitions[not(@unnumbered = 'true')]")).
        each { |c| section_names(c, n, 1) }
        docxml.xpath(ns("//sections/clause[@unnumbered = 'true'] | "\
                        "//sections/terms[@unnumbered = 'true'] | "\
                        "//sections/definitions[@unnumbered = 'true']")).
        each { |c| unnumbered_section_names(c, 1) }
      end

      NUMBERED_SUBCLAUSES = "./clause[not(@unnumbered = 'true')] | "\
        "./references[not(@unnumbered = 'true')] | "\
        "./term[not(@unnumbered = 'true')] | "\
        "./terms[not(@unnumbered = 'true')] | "\
        "./definitions[not(@unnumbered = 'true')]".freeze

      UNNUMBERED_SUBCLAUSES = "./clause[@unnumbered = 'true'] | "\
        "./references[@unnumbered = 'true'] | "\
        "./term[@unnumbered = 'true'] | "\
        "./terms[@unnumbered = 'true'] | "\
        "./definitions[@unnumbered = 'true']".freeze

      def section_names(clause, num, lvl)
        return num if clause.nil?
        num.increment(clause)
        @anchors[clause["id"]] = { label: num.print, xref: l10n("#{@labels["clause"]} #{num.print}"),
                                   level: lvl, type: "clause" }
        i = Counter.new
        clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
          i.increment(c)
          section_names1(c, "#{num.print}.#{i.print}", lvl + 1)
        end
        clause.xpath(ns(UNNUMBERED_SUBCLAUSES)).each_with_index do |c, i|
          unnumbered_section_names1(c, lvl + 1)
        end
        num
      end

      def unnumbered_section_names(clause, lvl)
        return if clause.nil?
        lbl = clause&.at(ns("./title"))&.text || "[#{clause["id"]}]"
        @anchors[clause["id"]] = { label: lbl, xref: l10n(%{"#{lbl}"}), level: lvl, type: "clause" }
        clause.xpath(ns(SUBCLAUSES)).each_with_index do |c, i|
          unnumbered_section_names1(c, lvl + 1)
        end
      end

      def section_names1(clause, num, level)
        @anchors[clause["id"]] =
          { label: num, level: level, xref: l10n("#{@labels["subclause"]} #{num}"),
            type: "clause" }
        i = Counter.new
        clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
          i.increment(c)
          section_names1(c, "#{num}.#{i.print}", level + 1)
        end
        clause.xpath(ns(UNNUMBERED_SUBCLAUSES)).each_with_index do |c, i|
          unnumbered_section_names1(c, lvl + 1)
        end
      end

      def unnumbered_section_names1(clause, level)
        lbl = clause&.at(ns("./title"))&.text || "[#{clause["id"]}]"
        @anchors[clause["id"]] =
          { label: lbl, xref: l10n(%{"#{lbl}"}), level: level, type: "clause" }
        clause.xpath(ns(SUBCLAUSES)).each do |c|
          unnumbered_section_names1(c, level + 1)
        end
      end

      def back_anchor_names(docxml)
        super
        @annexlbl = docxml.at(ns("//bibdata/ext/structuredidentifier/appendix")) ?
          @labels["appendix"] : @labels["annex"]
        docxml.xpath(ns("//annex[not(@unnumbered = 'true')]")).each_with_index { |c, i| annex_names(c, (i+1).to_s) }
        docxml.xpath(ns("//annex[@unnumbered = 'true']")).each { |c| unnumbered_annex_names(c) }
        docxml.xpath(ns("//indexsect")).each { |b| preface_names(b) }
      end

      def annex_names(clause, num)
        @anchors[clause["id"]] = { label: annex_name_lbl(clause, num), type: "clause", value: num.to_s,
                                   xref: l10n("#{@annexlbl} #{num}"), level: 1 }
        if a = single_annex_special_section(clause)
          annex_names1(a, "#{num}", 1)
        else
          i = Counter.new
          clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
            i.increment(c)
            annex_names1(c, "#{num}.#{i.print}", 2)
          end
          clause.xpath(ns(UNNUMBERED_SUBCLAUSES)).each { |c| unnumbered_annex_names1(c, 2) }
        end
        hierarchical_asset_names(clause, num)
      end

      def unnumbered_annex_names(clause)
        lbl = clause&.at(ns("./title"))&.text || "[#{clause["id"]}]"
        @anchors[clause["id"]] = { label: lbl, type: "clause", value: "", xref: l10n(%{"#{lbl}"}), level: 1 }
        if a = single_annex_special_section(clause)
          annex_names1(a, "#{num}", 1)
        else
          clause.xpath(ns(SUBCLAUSES)).each { |c| unnumbered_annex_names1(c, 2) }
        end
        hierarchical_asset_names(clause, lbl)
      end

      def annex_names1(clause, num, level)
        @anchors[clause["id"]] = { label: num, xref: l10n("#{@annexlbl} #{num}"),
                                   level: level, type: "clause" }
        i = Counter.new
        clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
          i.increment(c)
          annex_names1(c, "#{num}.#{i.print}", level + 1)
        end
        clause.xpath(ns(UNNUMBERED_SUBCLAUSES)).each { |c| unnumbered_annex_names1(c, level + 1) }
      end

      def unnumbered_annex_names1(clause, level)
        lbl = clause&.at(ns("./title"))&.text || "[#{clause["id"]}]"
        @anchors[clause["id"]] = { label: lbl, xref: l10n(%{"#{lbl}"}),
                                   level: level, type: "clause" }
        clause.xpath(ns(SUBCLAUSES)).each { |c| unnumbered_annex_names1(c, level + 1) }
      end

      def annex_name_lbl(clause, num)
        l10n("<strong>#{@annexlbl} #{num}</strong>")
      end
    end
  end
end
